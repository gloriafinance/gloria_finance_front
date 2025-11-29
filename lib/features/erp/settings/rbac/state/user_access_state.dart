import '../models/permission_module_group.dart';
import '../models/rbac_user_model.dart';
import '../models/role_model.dart';

class UserAccessState {
  const UserAccessState({
    required this.loadingUsers,
    required this.loadingRoles,
    required this.loadingAuthorization,
    required this.savingAssignments,
    required this.creatingUser,
    required this.users,
    required this.roles,
    required this.permissionCatalog,
    required this.effectivePermissions,
    required this.selectedRoleIds,
    required this.totalUsers,
    required this.nextUsersPage,
    required this.loadingMoreUsers,
    this.selectedUser,
    this.searchQuery = '',
    this.lastSyncedAt,
  });

  factory UserAccessState.initial() {
    return const UserAccessState(
      loadingUsers: false,
      loadingRoles: false,
      loadingAuthorization: false,
      savingAssignments: false,
      creatingUser: false,
      users: [],
      roles: [],
      permissionCatalog: [],
      effectivePermissions: [],
      selectedRoleIds: <String>{},
      totalUsers: 0,
      nextUsersPage: null,
      loadingMoreUsers: false,
    );
  }

  final bool loadingUsers;
  final bool loadingRoles;
  final bool loadingAuthorization;
  final bool savingAssignments;
  final bool creatingUser;
  final List<RbacUserModel> users;
  final List<RoleModel> roles;
  final List<PermissionModuleGroup> permissionCatalog;
  final List<PermissionModuleGroup> effectivePermissions;
  final Set<String> selectedRoleIds;
  final int totalUsers;
  final int? nextUsersPage;
  final bool loadingMoreUsers;
  final RbacUserModel? selectedUser;
  final String searchQuery;
  final DateTime? lastSyncedAt;

  UserAccessState copyWith({
    bool? loadingUsers,
    bool? loadingRoles,
    bool? loadingAuthorization,
    bool? savingAssignments,
    bool? creatingUser,
    List<RbacUserModel>? users,
    List<RoleModel>? roles,
    List<PermissionModuleGroup>? permissionCatalog,
    List<PermissionModuleGroup>? effectivePermissions,
    Set<String>? selectedRoleIds,
    int? totalUsers,
    int? nextUsersPage,
    bool? loadingMoreUsers,
    RbacUserModel? selectedUser,
    bool clearSelection = false,
    bool clearEffectivePermissions = false,
    String? searchQuery,
    DateTime? lastSyncedAt,
    bool clearLastSyncedAt = false,
    bool clearNextUsersPage = false,
  }) {
    return UserAccessState(
      loadingUsers: loadingUsers ?? this.loadingUsers,
      loadingRoles: loadingRoles ?? this.loadingRoles,
      loadingAuthorization: loadingAuthorization ?? this.loadingAuthorization,
      savingAssignments: savingAssignments ?? this.savingAssignments,
      creatingUser: creatingUser ?? this.creatingUser,
      users: users ?? this.users,
      roles: roles ?? this.roles,
      permissionCatalog: permissionCatalog ?? this.permissionCatalog,
      effectivePermissions:
          clearEffectivePermissions ? const [] : effectivePermissions ?? this.effectivePermissions,
      selectedRoleIds:
          Set<String>.unmodifiable(selectedRoleIds ?? this.selectedRoleIds),
      totalUsers: totalUsers ?? this.totalUsers,
      nextUsersPage: clearNextUsersPage ? null : nextUsersPage ?? this.nextUsersPage,
      loadingMoreUsers: loadingMoreUsers ?? this.loadingMoreUsers,
      selectedUser: clearSelection ? null : selectedUser ?? this.selectedUser,
      searchQuery: searchQuery ?? this.searchQuery,
      lastSyncedAt: clearLastSyncedAt ? null : lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  bool get hasSelection => selectedUser != null;

  List<RbacUserModel> filteredUsers() {
    final query = searchQuery.trim();
    if (query.isEmpty) {
      return users;
    }
    return users.where((user) => user.matchesQuery(query)).toList();
  }

  int get pendingAssignments {
    final user = selectedUser;
    if (user == null) {
      return 0;
    }
    final original = user.assignedRoles.toSet();
    final current = selectedRoleIds;
    var pending = 0;

    for (final role in current) {
      if (!original.contains(role)) {
        pending++;
      }
    }
    for (final role in original) {
      if (!current.contains(role)) {
        pending++;
      }
    }

    return pending;
  }

  bool get canLoadMoreUsers => nextUsersPage != null;

  int get loadedUsers => users.length;
}
