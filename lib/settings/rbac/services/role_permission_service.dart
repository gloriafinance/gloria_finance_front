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
        final items = data['roles'] ?? data['data'];
        if (items is List) {
          return items
              .whereType<Map<String, dynamic>>()
              .map(RoleModel.fromJson)
              .toList();
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
      final response = await http.get(
        '${await getUrlApi()}rbac/roles/$roleId/permissions',
        options: Options(headers: bearerToken()),
      );

      return _parsePermissionModules(response.data);
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

  List<PermissionModuleGroup> _parsePermissionModules(dynamic data) {
    final modules = <PermissionModuleGroup>[];
    if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          modules.add(PermissionModuleGroup.fromJson(item));
        }
      }
      return modules;
    }
    if (data is Map<String, dynamic>) {
      final items = data['modules'] ?? data['permissions'] ?? data['data'];
      if (items is List) {
        for (final item in items) {
          if (item is Map<String, dynamic>) {
            modules.add(PermissionModuleGroup.fromJson(item));
          }
        }
      }
    }
    return modules;
  }
}
