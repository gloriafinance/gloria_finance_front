import 'package:church_finance_bk/settings/rbac/models/permission_action_model.dart';
import 'package:church_finance_bk/settings/rbac/models/permission_module_group.dart';
import 'package:church_finance_bk/settings/rbac/models/rbac_user_model.dart';
import 'package:church_finance_bk/settings/rbac/models/rbac_user_page.dart';
import 'package:church_finance_bk/settings/rbac/models/role_model.dart';
import 'package:church_finance_bk/settings/rbac/models/user_authorization_model.dart';
import 'package:church_finance_bk/settings/rbac/services/rbac_user_service.dart';
import 'package:church_finance_bk/settings/rbac/services/role_permission_service.dart';
import 'package:church_finance_bk/settings/rbac/store/user_access_store.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRolePermissionService extends RolePermissionService {
  _FakeRolePermissionService({
    required this.roles,
    required this.catalog,
  });

  final List<RoleModel> roles;
  final List<PermissionModuleGroup> catalog;

  @override
  Future<List<RoleModel>> fetchRoles() async {
    return roles;
  }

  @override
  Future<List<PermissionModuleGroup>> fetchPermissionsCatalog() async {
    return catalog;
  }
}

class _FakeUserService extends RbacUserService {
  _FakeUserService({
    required List<RbacUserModel> users,
    required Map<String, Set<String>> assignments,
    required Map<String, List<String>> permissionsByRole,
  })  : _users = users,
        _assignments = assignments,
        _permissionsByRole = permissionsByRole;

  final List<RbacUserModel> _users;
  final Map<String, Set<String>> _assignments;
  final Map<String, List<String>> _permissionsByRole;

  @override
  Future<RbacUserPage> fetchUsers({int page = 1, int perPage = 50, bool? isActive, bool? isSuperuser}) async {
    final start = (page - 1) * perPage;
    final slice = _users.skip(start).take(perPage).toList();
    final next = (start + slice.length) >= _users.length ? null : page + 1;
    return RbacUserPage(
      users: slice,
      page: page,
      total: _users.length,
      nextPage: next,
    );
  }

  @override
  Future<UserAuthorizationModel> fetchAuthorization(String userId) async {
    final roles = _assignments[userId]?.toList() ?? const [];
    final permissionCodes = <String>[];
    for (final role in roles) {
      permissionCodes.addAll(_permissionsByRole[role] ?? const []);
    }
    return UserAuthorizationModel(
      roles: roles,
      permissionCodes: permissionCodes,
    );
  }

  @override
  Future<void> assignRoles({required String userId, required List<String> roleIds}) async {
    _assignments[userId] = roleIds.toSet();
  }

  @override
  Future<RbacUserModel> createUser({
    required String name,
    required String email,
    required String password,
    bool isActive = true,
    String? memberId,
  }) async {
    final newUser = RbacUserModel(
      userId: 'user-${_users.length + 1}',
      name: name,
      email: email,
      churchId: 'church-1',
      isActive: isActive,
      assignedRoles: const [],
    );
    _users.insert(0, newUser);
    _assignments[newUser.userId] = <String>{};
    return newUser;
  }
}

PermissionModuleGroup _catalogModule(
  String module,
  String label,
  List<PermissionActionModel> permissions,
) {
  return PermissionModuleGroup(
    module: module,
    label: label,
    permissions: permissions,
  );
}

PermissionActionModel _permission({
  required String module,
  required String action,
  required String label,
}) {
  return PermissionActionModel(
    module: module,
    action: action,
    label: label,
    permissionId: '$module:$action',
  );
}

void main() {
  group('UserAccessStore', () {
    late _FakeUserService userService;
    late _FakeRolePermissionService roleService;
    late UserAccessStore store;

    setUp(() {
      final roles = [
        const RoleModel(roleId: 'ADMIN', name: 'Administrador', isSystem: true),
        const RoleModel(roleId: 'AUDITOR', name: 'Auditor'),
      ];

      final catalog = [
        _catalogModule(
          'rbac',
          'RBAC',
          [
            _permission(module: 'rbac', action: 'manage_roles', label: 'Gerenciar papéis'),
          ],
        ),
        _catalogModule(
          'reports',
          'Relatórios',
          [
            _permission(module: 'reports', action: 'view', label: 'Ver relatórios'),
          ],
        ),
      ];

      userService = _FakeUserService(
        users: [
          RbacUserModel(
            userId: 'user-1',
            name: 'Alice',
            email: 'alice@test.com',
            churchId: 'church-1',
            isActive: true,
            createdAt: DateTime(2024, 1, 1),
          ),
          RbacUserModel(
            userId: 'user-2',
            name: 'Bob',
            email: 'bob@test.com',
            churchId: 'church-1',
            isActive: true,
            createdAt: DateTime(2024, 1, 2),
          ),
        ],
        assignments: {
          'user-1': {'ADMIN'},
          'user-2': {'AUDITOR'},
        },
        permissionsByRole: {
          'ADMIN': ['rbac:manage_roles'],
          'AUDITOR': ['reports:view'],
        },
      );

      roleService = _FakeRolePermissionService(
        roles: roles,
        catalog: catalog,
      );

      store = UserAccessStore(
        userService: userService,
        roleService: roleService,
        assignmentDebounce: Duration.zero,
        usersPerPage: 1,
      );
    });

    test('bootstrap loads initial state and selects first user', () async {
      await store.bootstrap();

      expect(store.state.users.length, equals(1));
      expect(store.state.roles.length, equals(2));
      expect(store.state.selectedUser?.userId, equals('user-1'));
      expect(store.state.selectedRoleIds, contains('ADMIN'));
      expect(store.state.effectivePermissions.length, equals(1));
    });

    test('toggleRole triggers assignment sync and refreshes permissions', () async {
      await store.bootstrap();

      store.toggleRole('AUDITOR', true);
      await Future<void>.delayed(Duration.zero);

      expect(store.state.selectedRoleIds, containsAll(['ADMIN', 'AUDITOR']));
      expect(store.state.effectivePermissions.length, equals(2));
    });

    test('createUser adds to list and selects new user', () async {
      await store.bootstrap();

      final created = await store.createUser(
        name: 'Charlie',
        email: 'charlie@test.com',
        password: 'ChangeMe123!',
        isActive: true,
      );

      expect(store.state.users.first.userId, equals(created.userId));
      expect(store.state.selectedUser?.userId, equals(created.userId));
    });

    test('loadNextUsersPage appends more users', () async {
      await store.bootstrap();
      expect(store.state.users.length, equals(1));
      await store.loadNextUsersPage();
      expect(store.state.users.length, equals(2));
    });
  });
}
