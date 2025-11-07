import 'dart:async';

import 'package:flutter/material.dart';

import '../models/permission_action_model.dart';
import '../models/permission_module_group.dart';
import '../models/role_model.dart';
import '../services/role_permission_service.dart';
import '../state/role_permission_state.dart';

class RolePermissionStore extends ChangeNotifier {
  RolePermissionStore({
    RolePermissionService? service,
    Duration debounceDuration = const Duration(milliseconds: 900),
  })  : service = service ?? RolePermissionService(),
        debounceDuration = debounceDuration,
        state = RolePermissionState.initial();

  final RolePermissionService service;
  RolePermissionState state;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  bool _disposed = false;

  Future<void> bootstrap() async {
    await loadRoles();
  }

  Future<void> loadRoles({bool autoSelectFirst = true}) async {
    state = state.copyWith(loadingRoles: true);
    _notify();
    try {
      final roles = await service.fetchRoles();
      state = state.copyWith(
        loadingRoles: false,
        roles: roles,
        roleSearchQuery: state.roleSearchQuery,
      );
      if (roles.isEmpty) {
        state = state.copyWith(
          modules: const [],
          originalModules: const [],
          clearSelectedRole: true,
        );
      } else if (autoSelectFirst) {
        await selectRole(roles.first);
      }
    } catch (_) {
      state = state.copyWith(loadingRoles: false);
      rethrow;
    } finally {
      _notify();
    }
  }

  Future<void> selectRole(RoleModel role) async {
    if (state.selectedRole?.id == role.id && state.loadingPermissions) {
      return;
    }
    state = state.copyWith(
      selectedRole: role,
      loadingPermissions: true,
      searchQuery: '',
      modules: const [],
      originalModules: const [],
    );
    _notify();
    try {
      final modules = await service.fetchRolePermissions(role.id);
      state = state.copyWith(
        loadingPermissions: false,
        modules: modules,
        originalModules: _cloneModules(modules),
      );
    } catch (_) {
      state = state.copyWith(loadingPermissions: false);
      rethrow;
    }
    _notify();
  }

  void updatePermissionSearch(String query) {
    state = state.copyWith(searchQuery: query);
    _notify();
  }

  void updateRoleSearch(String query) {
    state = state.copyWith(roleSearchQuery: query);
    _notify();
  }

  void togglePermission({
    required String moduleId,
    required String action,
    required bool granted,
  }) {
    if (!state.hasSelection) {
      return;
    }
    final updatedModules = state.modules.map((module) {
      if (module.module != moduleId) {
        return module;
      }
      final updatedPermissions = module.permissions.map((permission) {
        if (permission.action != action) {
          return permission;
        }
        if (permission.isReadOnly) {
          return permission;
        }
        if (permission.isInherited && !granted) {
          return permission;
        }
        return permission.copyWith(granted: granted);
      }).toList();
      return module.copyWith(permissions: updatedPermissions);
    }).toList();

    state = state.copyWith(modules: updatedModules);
    _notify();
    _scheduleAutoSave();
  }

  void toggleModule(String moduleId, bool granted) {
    if (!state.hasSelection) {
      return;
    }
    final updatedModules = state.modules.map((module) {
      if (module.module != moduleId) {
        return module;
      }
      final updatedPermissions = module.permissions.map((permission) {
        if (permission.isReadOnly) {
          return permission;
        }
        if (permission.isInherited && !granted) {
          return permission;
        }
        return permission.copyWith(granted: granted);
      }).toList();
      return module.copyWith(permissions: updatedPermissions);
    }).toList();

    state = state.copyWith(modules: updatedModules);
    _notify();
    _scheduleAutoSave();
  }

  void revertToOriginal() {
    if (!state.hasSelection) {
      return;
    }
    state = state.copyWith(
      modules: _cloneModules(state.originalModules),
      searchQuery: state.searchQuery,
    );
    _notify();
  }

  Future<RoleModel> createRole({
    required String name,
    String? description,
  }) async {
    final newRole = RoleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      assignedUsers: const [],
    );
    final updatedRoles = List<RoleModel>.from(state.roles)..add(newRole);
    state = state.copyWith(roles: updatedRoles);
    _notify();
    await selectRole(newRole);
    return newRole;
  }

  void _scheduleAutoSave() {
    _debounceTimer?.cancel();
    if (debounceDuration == Duration.zero) {
      _syncPermissions();
      return;
    }
    _debounceTimer = Timer(debounceDuration, _syncPermissions);
  }

  Future<void> _syncPermissions() async {
    if (!state.hasSelection) {
      return;
    }
    state = state.copyWith(saving: true);
    _notify();
    try {
      await service.updateRolePermissions(
        roleId: state.selectedRole!.id,
        permissions: _collectPermissions(),
      );
      state = state.copyWith(
        saving: false,
        originalModules: _cloneModules(state.modules),
        lastSavedAt: DateTime.now(),
      );
    } catch (_) {
      state = state.copyWith(saving: false);
      rethrow;
    }
    _notify();
  }

  List<PermissionModuleGroup> _cloneModules(List<PermissionModuleGroup> modules) {
    return modules
        .map(
          (module) => PermissionModuleGroup(
            module: module.module,
            label: module.label,
            description: module.description,
            permissions: module.permissions
                .map(
                  (permission) => PermissionActionModel(
                    module: permission.module,
                    action: permission.action,
                    label: permission.label,
                    granted: permission.granted,
                    isInherited: permission.isInherited,
                    isCritical: permission.isCritical,
                    isReadOnly: permission.isReadOnly,
                    description: permission.description,
                    impactLabel: permission.impactLabel,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  List<PermissionActionModel> _collectPermissions() {
    return state.modules
        .expand((module) => module.permissions)
        .map(
          (permission) => PermissionActionModel(
            module: permission.module,
            action: permission.action,
            label: permission.label,
            granted: permission.granted,
            isInherited: permission.isInherited,
            isCritical: permission.isCritical,
            isReadOnly: permission.isReadOnly,
            description: permission.description,
            impactLabel: permission.impactLabel,
          ),
        )
        .toList();
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _disposed = true;
    super.dispose();
  }
}
