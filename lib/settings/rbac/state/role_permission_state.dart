import '../models/permission_module_group.dart';
import '../models/role_model.dart';

class RolePermissionState {
  const RolePermissionState({
    required this.loadingRoles,
    required this.loadingPermissions,
    required this.saving,
    required this.roles,
    required this.modules,
    required this.originalModules,
    this.selectedRole,
    this.searchQuery = '',
    this.roleSearchQuery = '',
    this.lastSavedAt,
  });

  factory RolePermissionState.initial() {
    return const RolePermissionState(
      loadingRoles: false,
      loadingPermissions: false,
      saving: false,
      roles: [],
      modules: [],
      originalModules: [],
    );
  }

  final bool loadingRoles;
  final bool loadingPermissions;
  final bool saving;
  final List<RoleModel> roles;
  final List<PermissionModuleGroup> modules;
  final List<PermissionModuleGroup> originalModules;
  final RoleModel? selectedRole;
  final String searchQuery;
  final String roleSearchQuery;
  final DateTime? lastSavedAt;

  RolePermissionState copyWith({
    bool? loadingRoles,
    bool? loadingPermissions,
    bool? saving,
    List<RoleModel>? roles,
    List<PermissionModuleGroup>? modules,
    List<PermissionModuleGroup>? originalModules,
    RoleModel? selectedRole,
    bool clearSelectedRole = false,
    String? searchQuery,
    String? roleSearchQuery,
    DateTime? lastSavedAt,
    bool clearLastSavedAt = false,
  }) {
    return RolePermissionState(
      loadingRoles: loadingRoles ?? this.loadingRoles,
      loadingPermissions: loadingPermissions ?? this.loadingPermissions,
      saving: saving ?? this.saving,
      roles: roles ?? this.roles,
      modules: modules ?? this.modules,
      originalModules: originalModules ?? this.originalModules,
      selectedRole: clearSelectedRole ? null : selectedRole ?? this.selectedRole,
      searchQuery: searchQuery ?? this.searchQuery,
      roleSearchQuery: roleSearchQuery ?? this.roleSearchQuery,
      lastSavedAt: clearLastSavedAt ? null : lastSavedAt ?? this.lastSavedAt,
    );
  }

  List<RoleModel> filteredRoles() {
    if (roleSearchQuery.isEmpty) {
      return roles;
    }
    final query = roleSearchQuery.toLowerCase();
    return roles
        .where(
          (role) =>
              role.name.toLowerCase().contains(query) ||
              (role.description ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  List<PermissionModuleGroup> filteredModules() {
    if (searchQuery.isEmpty) {
      return modules;
    }
    final normalizedQuery = searchQuery.toLowerCase();
    return modules
        .where((module) => module.matchesSearch(searchQuery))
        .map((module) {
      final filteredPermissions = module.permissions.where((permission) {
        return permission.label.toLowerCase().contains(normalizedQuery) ||
            permission.action.toLowerCase().contains(normalizedQuery) ||
            module.label.toLowerCase().contains(normalizedQuery) ||
            module.module.toLowerCase().contains(normalizedQuery);
      }).toList();
      if (filteredPermissions.isEmpty) {
        return module;
      }
      return module.copyWith(permissions: filteredPermissions);
    }).toList();
  }

  int get totalPermissions =>
      modules.fold(0, (previousValue, element) => previousValue + element.permissions.length);

  int get totalGranted =>
      modules.fold(0, (previousValue, element) => previousValue + element.grantedCount);

  int get pendingChanges {
    var total = 0;
    for (final module in modules) {
      final originalModule =
          originalModules.firstWhere((element) => element.module == module.module,
              orElse: () => module.copyWith(permissions: []));
      final originalPermissions = {
        for (final permission in originalModule.permissions)
          '${permission.module}:${permission.action}': permission.granted,
      };
      for (final permission in module.permissions) {
        final key = '${permission.module}:${permission.action}';
        final originalGranted = originalPermissions[key];
        if (originalGranted != null && originalGranted != permission.granted) {
          total++;
        } else if (originalGranted == null && permission.granted) {
          total++;
        }
      }
    }
    return total;
  }

  bool get hasSelection => selectedRole != null;
}
