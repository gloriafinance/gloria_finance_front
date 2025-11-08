import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import '../../../core/app_http.dart';
import '../models/permission_action_model.dart';
import '../models/permission_module_group.dart';
import '../models/role_model.dart';

class RolePermissionService extends AppHttp {
  RolePermissionService({AuthPersistence? authPersistence})
      : _authPersistence = authPersistence ?? AuthPersistence();

  final AuthPersistence _authPersistence;

  Future<List<RoleModel>> fetchRoles() async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}rbac/roles',
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(RoleModel.fromJson)
            .toList();
      }
      if (data is Map<String, dynamic>) {
        final possibleCollections = [
          data['roles'],
          data['data'],
          (data['data'] is Map<String, dynamic>)
              ? (data['data'] as Map<String, dynamic>)['roles']
              : null,
        ];
        for (final collection in possibleCollections) {
          if (collection is List) {
            return collection
                .whereType<Map<String, dynamic>>()
                .map(RoleModel.fromJson)
                .toList();
          }
        }
      }
      return const [];
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<RoleModel> createRole({
    required String name,
    String? description,
  }) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}rbac/roles',
        data: <String, dynamic>{
          'name': name,
          if (description != null && description.isNotEmpty)
            'description': description,
        },
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('role')) {
          final role = data['role'];
          if (role is Map<String, dynamic>) {
            return RoleModel.fromJson(role);
          }
        }
        return RoleModel.fromJson(data);
      }
      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) {
          return RoleModel.fromJson(first);
        }
      }
      return RoleModel(
        id: response.headers.map['location']?.first ?? '',
        name: name,
        roleId: name,
        description: description,
        assignedUsers: const [],
      );
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<List<PermissionModuleGroup>> fetchRolePermissions(String roleId) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final baseUrl = await getUrlApi();
      final options = Options(headers: bearerToken());

      final assignedResponse = await http.get(
        '${baseUrl}rbac/roles/$roleId/permissions',
        options: options,
      );
      final assignedModules =
          _parsePermissionModules(assignedResponse.data, grantByDefault: true);

      List<PermissionModuleGroup> catalogModules = const [];
      try {
        final catalogResponse = await http.get(
          '${baseUrl}rbac/permissions',
          options: options,
        );
        catalogModules = _parsePermissionModules(catalogResponse.data);
      } on DioException {
        // Ignore catalog errors and fall back to the assigned permissions only.
      }

      if (catalogModules.isEmpty) {
        return assignedModules;
      }

      return _mergeWithCatalog(catalogModules, assignedModules);
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<void> updateRolePermissions({
    required String roleId,
    required List<PermissionActionModel> permissions,
  }) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}rbac/roles/$roleId/permissions',
        data: <String, dynamic>{
          'permissions': permissions
              .map(
                (permission) => {
                  'module': permission.module,
                  'action': permission.action,
                  'granted': permission.granted,
                },
              )
              .toList(),
        },
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<List<PermissionModuleGroup>> fetchPermissionsCatalog() async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}rbac/permissions',
        options: Options(headers: bearerToken()),
      );

      return _parsePermissionModules(response.data);
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<void> bootstrapPermissions() async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}rbac/permissions/bootstrap',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  List<PermissionModuleGroup> _parsePermissionModules(
    dynamic data, {
    bool grantByDefault = false,
  }) {
    if (data is List) {
      final maps = data.whereType<Map<String, dynamic>>().toList();
      if (maps.isEmpty) {
        return const [];
      }

      final containsNestedPermissions = maps.any((item) => item['permissions'] is List);
      if (containsNestedPermissions) {
        final modules = <PermissionModuleGroup>[];
        for (final item in maps) {
          final moduleId = item['module']?.toString() ?? '';
          final normalized = Map<String, dynamic>.from(item)
            ..['module'] = moduleId;
          if (grantByDefault) {
            normalized['permissions'] = (normalized['permissions'] as List?)
                    ?.whereType<Map<String, dynamic>>()
                    .map((permission) {
              final map = Map<String, dynamic>.from(permission);
              map['module'] = map['module'] ?? moduleId;
              map['granted'] = map['granted'] ?? true;
              return map;
            }).toList() ??
                const [];
          }
          modules.add(PermissionModuleGroup.fromJson(normalized));
        }
        modules.sort((a, b) => a.label.compareTo(b.label));
        return modules;
      }

      final permissions = maps.map((item) {
        final map = Map<String, dynamic>.from(item);
        if (grantByDefault) {
          map['granted'] = map['granted'] ?? true;
        }
        return PermissionActionModel.fromJson(map);
      }).toList();

      return _groupPermissions(permissions);
    }

    if (data is Map<String, dynamic>) {
      final keys = ['modules', 'permissions', 'data', 'items'];
      for (final key in keys) {
        final value = data[key];
        if (value == null) {
          continue;
        }
        final result = _parsePermissionModules(value, grantByDefault: grantByDefault);
        if (result.isNotEmpty) {
          return result;
        }
      }
    }

    return const [];
  }

  List<PermissionModuleGroup> _mergeWithCatalog(
    List<PermissionModuleGroup> catalog,
    List<PermissionModuleGroup> assigned,
  ) {
    final assignedByModule = {for (final module in assigned) module.module: module};
    final merged = <PermissionModuleGroup>[];

    for (final module in catalog) {
      final assignedModule = assignedByModule[module.module];
      final assignedPermissions = <String, PermissionActionModel>{};
      if (assignedModule != null) {
        for (final permission in assignedModule.permissions) {
          assignedPermissions['${permission.module}:${permission.action}'] = permission;
        }
      }

      final permissions = module.permissions.map((permission) {
        final key = '${permission.module}:${permission.action}';
        final assignedPermission = assignedPermissions.remove(key);
        if (assignedPermission == null) {
          return permission.copyWith(granted: false);
        }
        return permission.copyWith(
          granted: assignedPermission.granted,
          isInherited: assignedPermission.isInherited,
          isCritical: assignedPermission.isCritical,
          isReadOnly: assignedPermission.isReadOnly,
          isSystem: assignedPermission.isSystem,
          description: assignedPermission.description ?? permission.description,
          impactLabel: assignedPermission.impactLabel ?? permission.impactLabel,
          label: assignedPermission.label.isEmpty ? permission.label : assignedPermission.label,
        );
      }).toList();

      if (assignedPermissions.isNotEmpty) {
        permissions.addAll(assignedPermissions.values.map((permission) {
          return permission.copyWith(
            label: permission.label.isEmpty
                ? _humanizeIdentifier(permission.action)
                : permission.label,
          );
        }));
      }

      permissions.sort((a, b) => a.label.compareTo(b.label));

      merged.add(module.copyWith(permissions: permissions));
    }

    final catalogModules = {for (final module in catalog) module.module};
    for (final module in assigned) {
      if (!catalogModules.contains(module.module)) {
        final normalizedModule = module.copyWith(
          label: module.label.isEmpty ? _humanizeIdentifier(module.module) : module.label,
          permissions: module.permissions
              .map(
                (permission) => permission.copyWith(
                  label: permission.label.isEmpty
                      ? _humanizeIdentifier(permission.action)
                      : permission.label,
                ),
              )
              .toList()
            ..sort((a, b) => a.label.compareTo(b.label)),
        );
        merged.add(normalizedModule);
      }
    }

    merged.sort((a, b) => a.label.compareTo(b.label));
    return merged;
  }

  List<PermissionModuleGroup> _groupPermissions(
    List<PermissionActionModel> permissions,
  ) {
    if (permissions.isEmpty) {
      return const [];
    }
    final grouped = <String, List<PermissionActionModel>>{};
    for (final permission in permissions) {
      grouped.putIfAbsent(permission.module, () => []).add(permission);
    }

    final modules = grouped.entries.map((entry) {
      final moduleId = entry.key;
      final modulePermissions = List<PermissionActionModel>.from(entry.value)
        ..sort((a, b) => a.label.compareTo(b.label));
      return PermissionModuleGroup(
        module: moduleId,
        label: _humanizeIdentifier(moduleId),
        permissions: modulePermissions,
      );
    }).toList();

    modules.sort((a, b) => a.label.compareTo(b.label));
    return modules;
  }
}

String _humanizeIdentifier(String value) {
  if (value.isEmpty) {
    return '';
  }
  return value
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .split(' ')
      .where((segment) => segment.isNotEmpty)
      .map((segment) =>
          segment[0].toUpperCase() + segment.substring(1).toLowerCase())
      .join(' ');
}
