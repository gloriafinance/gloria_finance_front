import 'package:church_finance_bk/settings/rbac/models/permission_action_model.dart';
import 'package:church_finance_bk/settings/rbac/models/permission_module_group.dart';
import 'package:church_finance_bk/settings/rbac/models/role_model.dart';
import 'package:church_finance_bk/settings/rbac/services/role_permission_service.dart';
import 'package:church_finance_bk/settings/rbac/store/role_permission_store.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRolePermissionService extends RolePermissionService {
  _FakeRolePermissionService({
    required this.roles,
    required this.modulesByRole,
  });

  final List<RoleModel> roles;
  final Map<String, List<PermissionModuleGroup>> modulesByRole;

  int updateCalls = 0;
  int createCalls = 0;
  String? lastRoleId;
  List<PermissionActionModel>? lastPermissions;

  @override
  Future<RoleModel> createRole({
    required String name,
    String? description,
  }) async {
    createCalls++;
    final role = RoleModel(
      roleId: 'generated-$createCalls',
      name: name,
      description: description,
      roleId: 'generated-$createCalls',
      assignedUsers: const [],
    );
    roles.add(role);
    return role;
  }

  @override
  Future<List<RoleModel>> fetchRoles() async {
    return roles;
  }

  @override
  Future<List<PermissionModuleGroup>> fetchRolePermissions(
    String roleId,
  ) async {
    return modulesByRole[roleId] ?? [];
  }

  @override
  Future<void> updateRolePermissions({
    required String roleId,
    required List<PermissionActionModel> permissions,
  }) async {
    updateCalls++;
    lastRoleId = roleId;
    lastPermissions = permissions;

    final grouped = <String, List<PermissionActionModel>>{};
    for (final permission in permissions) {
      grouped.putIfAbsent(permission.module, () => []).add(permission);
    }
    modulesByRole[roleId] =
        grouped.entries
            .map(
              (entry) => PermissionModuleGroup(
                module: entry.key,
                label: entry.key,
                permissions: entry.value,
              ),
            )
            .toList();
  }
}

PermissionModuleGroup _buildModule({
  required String module,
  required List<PermissionActionModel> permissions,
}) {
  return PermissionModuleGroup(
    module: module,
    label: module,
    permissions: permissions,
  );
}

void main() {
  group('RolePermissionStore', () {
    late _FakeRolePermissionService service;
    late RolePermissionStore store;

    setUp(() {
      final roles = [
        const RoleModel(roleId: '1', name: 'Administrador'),
        const RoleModel(roleId: '2', name: 'Leitor'),
      ];

      final modulesByRole = {
        '1': [
          _buildModule(
            module: 'financial_records',
            permissions: [
              const PermissionActionModel(
                module: 'financial_records',
                action: 'create',
                label: 'Criar',
                granted: true,
              ),
              const PermissionActionModel(
                module: 'financial_records',
                action: 'approve',
                label: 'Aprovar',
                granted: true,
              ),
            ],
          ),
        ],
        '2': [
          _buildModule(
            module: 'reports',
            permissions: [
              const PermissionActionModel(
                module: 'reports',
                action: 'view',
                label: 'Visualizar',
                granted: true,
                isReadOnly: true,
              ),
            ],
          ),
        ],
      };

      service = _FakeRolePermissionService(
        roles: roles,
        modulesByRole: modulesByRole,
      );

      store = RolePermissionStore(
        service: service,
        debounceDuration: Duration.zero,
      );
    });

    test('bootstrap loads roles and selects first role', () async {
      await store.bootstrap();

      expect(store.state.roles, isNotEmpty);
      expect(store.state.selectedRole?.roleId, equals('1'));
      expect(store.state.modules, isNotEmpty);
      expect(store.state.modules.first.permissions.length, equals(2));
      expect(store.state.loadingPermissions, isFalse);
    });

    test(
      'togglePermission updates granted state and syncs with service',
      () async {
        await store.bootstrap();
        final module = store.state.modules.first;
        final permission = module.permissions.first;

        expect(permission.granted, isTrue);

        store.togglePermission(
          moduleId: permission.module,
          action: permission.action,
          granted: false,
        );

        expect(store.state.modules.first.permissions.first.granted, isFalse);
        expect(service.updateCalls, equals(1));
        expect(service.lastRoleId, equals('1'));
        expect(
          service.lastPermissions!
              .firstWhere((element) => element.action == permission.action)
              .granted,
          isFalse,
        );
        expect(store.state.pendingChanges, equals(0));
      },
    );

    test('toggleModule keeps read only permissions untouched', () async {
      await store.bootstrap();
      await store.selectRole(const RoleModel(roleId: '2', name: 'Leitor'));

      final module = store.state.modules.first;
      final readOnlyPermission = module.permissions.first;
      expect(readOnlyPermission.isReadOnly, isTrue);

      store.toggleModule(module.module, false);

      final updatedModule = store.state.modules.first;
      expect(updatedModule.permissions.first.granted, isTrue);
    });

    test('createRole delegates to service and selects returned role', () async {
      await store.bootstrap();

      final created = await store.createRole(name: 'Auditor');

      expect(service.createCalls, equals(1));
      expect(created.name, equals('Auditor'));
      expect(
        store.state.roles.any((role) => role.roleId == created.roleId),
        isTrue,
      );
      expect(store.state.selectedRole?.roleId, equals(created.roleId));
      expect(store.state.modules, isEmpty);
    });
  });
}
