import 'dart:async';

import 'package:flutter/material.dart';

import '../models/permission_action_model.dart';
import '../models/permission_module_group.dart';
import '../models/rbac_user_model.dart';
import '../services/rbac_user_service.dart';
import '../services/role_permission_service.dart';
import '../state/user_access_state.dart';

class UserAccessStore extends ChangeNotifier {
  UserAccessStore({
    RbacUserService? userService,
    RolePermissionService? roleService,
    Duration assignmentDebounce = const Duration(milliseconds: 800),
    int usersPerPage = 10,
  }) : userService = userService ?? RbacUserService(),
       roleService = roleService ?? RolePermissionService(),
       assignmentDebounce = assignmentDebounce,
       usersPerPage = usersPerPage,
       state = UserAccessState.initial();

  final RbacUserService userService;
  final RolePermissionService roleService;
  final Duration assignmentDebounce;
  final int usersPerPage;

  UserAccessState state;

  Timer? _assignmentTimer;
  bool _disposed = false;
  Map<String, PermissionActionModel> _catalogIndex = {};

  Future<void> bootstrap() async {
    state = state.copyWith(
      loadingUsers: true,
      loadingRoles: true,
      loadingAuthorization: false,
      loadingMoreUsers: false,
      clearNextUsersPage: true,
      totalUsers: 0,
    );
    _notify();

    try {
      final rolesFuture = roleService.fetchRoles();
      final catalogFuture = roleService.fetchPermissionsCatalog();
      final usersFuture = userService.fetchUsers(
        page: 1,
        perPage: usersPerPage,
      );

      final roles = await rolesFuture;
      final catalog = await catalogFuture;
      final users = await usersFuture;

      _catalogIndex = _indexCatalog(catalog);

      state = state.copyWith(
        loadingUsers: false,
        loadingRoles: false,
        roles: roles,
        users: users.users,
        permissionCatalog: catalog,
        clearEffectivePermissions: true,
        totalUsers: users.total,
        nextUsersPage: users.nextPage,
        clearNextUsersPage: users.nextPage == null,
        loadingMoreUsers: false,
      );
      _notify();

      if (users.users.isNotEmpty) {
        await selectUser(users.users.first);
      }
    } catch (error) {
      state = state.copyWith(loadingUsers: false, loadingRoles: false);
      _notify();
      rethrow;
    }
  }

  Future<void> refreshUsers() async {
    await _loadFirstPage();
  }

  Future<void> selectUser(RbacUserModel user) async {
    _assignmentTimer?.cancel();
    state = state.copyWith(
      selectedUser: user,
      selectedRoleIds: user.assignedRoles.toSet(),
      loadingAuthorization: true,
      clearEffectivePermissions: true,
      clearLastSyncedAt: true,
    );
    _notify();
    await _refreshAuthorization(user);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _notify();
  }

  Future<RbacUserModel> createUser({
    required String name,
    required String email,
    required String password,
    bool isActive = true,
    String? memberId,
  }) async {
    state = state.copyWith(creatingUser: true);
    _notify();
    try {
      final created = await userService.createUser(
        name: name,
        email: email,
        password: password,
        isActive: isActive,
        memberId: memberId,
      );
      final updatedUsers =
          List<RbacUserModel>.from(state.users)
            ..removeWhere((user) => user.userId == created.userId)
            ..insert(0, created);
      state = state.copyWith(
        creatingUser: false,
        users: updatedUsers,
        totalUsers: state.totalUsers + 1,
      );
      _notify();
      await selectUser(created);
      return created;
    } catch (error) {
      state = state.copyWith(creatingUser: false);
      _notify();
      rethrow;
    }
  }

  void toggleRole(String roleId, bool granted) {
    if (!state.hasSelection) {
      return;
    }
    final updated = state.selectedRoleIds.toSet();
    if (granted) {
      updated.add(roleId);
    } else {
      updated.remove(roleId);
    }
    state = state.copyWith(selectedRoleIds: updated);
    _notify();
    _scheduleAssignmentSync();
  }

  void setRolesForSelection(Iterable<String> roleIds) {
    if (!state.hasSelection) {
      return;
    }
    state = state.copyWith(selectedRoleIds: roleIds.toSet());
    _notify();
    _scheduleAssignmentSync();
  }

  void _scheduleAssignmentSync() {
    _assignmentTimer?.cancel();
    if (!state.hasSelection) {
      return;
    }
    if (assignmentDebounce == Duration.zero) {
      _syncAssignments();
      return;
    }
    _assignmentTimer = Timer(assignmentDebounce, _syncAssignments);
  }

  Future<void> _syncAssignments() async {
    if (!state.hasSelection) {
      return;
    }
    final selectedUser = state.selectedUser!;
    state = state.copyWith(savingAssignments: true);
    _notify();
    try {
      await userService.assignRoles(
        userId: selectedUser.userId,
        roleIds: state.selectedRoleIds.toList(),
      );
      await _refreshAuthorization(selectedUser, showLoading: false);
    } catch (error) {
      rethrow;
    } finally {
      state = state.copyWith(savingAssignments: false);
      _notify();
    }
  }

  Future<void> _refreshAuthorization(
    RbacUserModel user, {
    bool showLoading = true,
  }) async {
    final targetUserId = user.userId;
    if (showLoading) {
      state = state.copyWith(
        loadingAuthorization: true,
        clearEffectivePermissions: true,
      );
      _notify();
    }
    try {
      final authorization = await userService.fetchAuthorization(targetUserId);
      if (!state.hasSelection || state.selectedUser?.userId != targetUserId) {
        return;
      }
      final modules = _buildEffectiveModules(authorization.permissionCodes);
      final updatedUser = state.selectedUser!.copyWith(
        assignedRoles: authorization.roles,
      );
      final updatedUsers = _replaceUser(updatedUser, state.users);
      state = state.copyWith(
        loadingAuthorization: false,
        selectedRoleIds: authorization.roles.toSet(),
        selectedUser: updatedUser,
        users: updatedUsers,
        effectivePermissions: modules,
        lastSyncedAt: DateTime.now(),
      );
    } catch (error) {
      state = state.copyWith(loadingAuthorization: false);
      _notify();
      rethrow;
    }
    _notify();
  }

  List<PermissionModuleGroup> _buildEffectiveModules(
    List<String> permissionCodes,
  ) {
    if (permissionCodes.isEmpty) {
      return const [];
    }
    final grouped = <String, List<PermissionActionModel>>{};

    for (final code in permissionCodes) {
      final moduleAction = code.split(':');
      final module = moduleAction.isNotEmpty ? moduleAction.first : code;
      final action = moduleAction.length > 1 ? moduleAction[1] : 'read';
      final metadata = _catalogIndex[code];
      final label =
          metadata?.label ??
          (metadata?.description?.isNotEmpty ?? false
              ? metadata!.description!
              : _humanize(action));

      final permission = PermissionActionModel(
        module: module,
        action: action,
        label: label,
        permissionId: metadata?.permissionId ?? code,
        granted: true,
        isInherited: true,
        isReadOnly: true,
        description: metadata?.description,
        impactLabel: metadata?.impactLabel,
        isCritical: metadata?.isCritical ?? false,
      );

      grouped.putIfAbsent(module, () => []).add(permission);
    }

    final modules = <PermissionModuleGroup>[];
    for (final entry in grouped.entries) {
      final moduleId = entry.key;
      final catalogModule = state.permissionCatalog.firstWhere(
        (module) => module.module == moduleId,
        orElse:
            () => PermissionModuleGroup(
              module: moduleId,
              label: _humanize(moduleId),
              permissions: const [],
            ),
      );

      final permissions = List<PermissionActionModel>.from(entry.value)
        ..sort((a, b) => a.label.compareTo(b.label));

      modules.add(
        PermissionModuleGroup(
          module: catalogModule.module,
          label: catalogModule.label,
          description: catalogModule.description,
          permissions: permissions,
        ),
      );
    }

    modules.sort((a, b) => a.label.compareTo(b.label));
    return modules;
  }

  Map<String, PermissionActionModel> _indexCatalog(
    List<PermissionModuleGroup> catalog,
  ) {
    final entries = <String, PermissionActionModel>{};
    for (final module in catalog) {
      for (final permission in module.permissions) {
        final key =
            (permission.permissionId?.isNotEmpty ?? false)
                ? permission.permissionId!
                : '${permission.module}:${permission.action}';
        entries[key] = permission;
      }
    }
    return entries;
  }

  List<RbacUserModel> _replaceUser(
    RbacUserModel updatedUser,
    List<RbacUserModel> users,
  ) {
    return users
        .map((user) => user.userId == updatedUser.userId ? updatedUser : user)
        .toList();
  }

  RbacUserModel? _syncSelectedUser(List<RbacUserModel> users) {
    final selected = state.selectedUser;
    if (selected == null) {
      return null;
    }
    for (final user in users) {
      if (user.userId == selected.userId) {
        return user.copyWith(assignedRoles: selected.assignedRoles);
      }
    }
    return null;
  }

  String _humanize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .split(' ')
        .where((segment) => segment.isNotEmpty)
        .map(
          (segment) =>
              segment[0].toUpperCase() + segment.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  Future<void> _loadFirstPage() async {
    state = state.copyWith(
      loadingUsers: true,
      loadingMoreUsers: false,
      clearNextUsersPage: true,
    );
    _notify();

    try {
      final page = await userService.fetchUsers(page: 1, perPage: usersPerPage);
      final updatedSelection = _syncSelectedUser(page.users);
      state = state.copyWith(
        loadingUsers: false,
        users: page.users,
        selectedUser: updatedSelection,
        totalUsers: page.total,
        nextUsersPage: page.nextPage,
        clearNextUsersPage: page.nextPage == null,
        loadingMoreUsers: false,
      );
    } catch (error) {
      state = state.copyWith(loadingUsers: false);
      _notify();
      rethrow;
    }
    _notify();
  }

  Future<void> loadNextUsersPage() async {
    final nextPage = state.nextUsersPage;
    if (nextPage == null || state.loadingMoreUsers) {
      return;
    }
    state = state.copyWith(loadingMoreUsers: true);
    _notify();
    try {
      final page = await userService.fetchUsers(
        page: nextPage,
        perPage: usersPerPage,
      );
      final merged = _mergeUsers(state.users, page.users);
      final syncedSelection = _syncSelectedUser(merged) ?? state.selectedUser;
      state = state.copyWith(
        loadingMoreUsers: false,
        users: merged,
        totalUsers: page.total,
        nextUsersPage: page.nextPage,
        clearNextUsersPage: page.nextPage == null,
        selectedUser: syncedSelection,
      );
    } catch (error) {
      state = state.copyWith(loadingMoreUsers: false);
      _notify();
      rethrow;
    }
    _notify();
  }

  List<RbacUserModel> _mergeUsers(
    List<RbacUserModel> current,
    List<RbacUserModel> incoming,
  ) {
    final merged = List<RbacUserModel>.from(current);
    for (final user in incoming) {
      final index = merged.indexWhere(
        (element) => element.userId == user.userId,
      );
      if (index == -1) {
        merged.add(user);
      } else {
        merged[index] = user;
      }
    }
    return merged;
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _assignmentTimer?.cancel();
    _disposed = true;
    super.dispose();
  }
}
