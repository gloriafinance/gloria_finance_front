import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/app_http.dart';
import '../models/permission_action_model.dart';
import '../models/permission_module_group.dart';
import '../models/role_model.dart';

class RolePermissionService extends AppHttp {
  Future<List<RoleModel>> fetchRoles() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      // TODO(backend): reemplazar por request real
      return _demoRoles();
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<List<PermissionModuleGroup>> fetchRolePermissions(String roleId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      // TODO(backend): reemplazar por request real
      return _demoModules(roleId);
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<void> updateRolePermissions({
    required String roleId,
    required List<PermissionActionModel> permissions,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      // TODO(backend): reemplazar por request real
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (kDebugMode) {
        // ignore: avoid_print
        print('Role $roleId updated with ${permissions.length} permissions');
      }
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  List<RoleModel> _demoRoles() {
    return const [
      RoleModel(
        id: '1',
        name: 'Administrador Financeiro',
        description: 'Acesso completo aos módulos financeiros',
        isCustom: false,
        isDefault: true,
        assignedUsers: ['João', 'Maria', 'Ana'],
      ),
      RoleModel(
        id: '2',
        name: 'Tesoureiro',
        description: 'Pode cadastrar e aprovar pagamentos',
        assignedUsers: ['Carlos'],
      ),
      RoleModel(
        id: '3',
        name: 'Convidado',
        description: 'Somente leitura de relatórios financeiros',
        assignedUsers: const [],
      ),
    ];
  }

  List<PermissionModuleGroup> _demoModules(String roleId) {
    return [
      PermissionModuleGroup(
        module: 'financial_records',
        label: 'Registros Financeiros',
        description: 'Permissões para registrar e acompanhar entradas e saídas.',
        permissions: [
          PermissionActionModel(
            module: 'financial_records',
            action: 'create',
            label: 'Registrar Movimento',
            granted: roleId != '3',
            description: 'Permite lançar entradas e saídas no caixa da igreja.',
            impactLabel: 'Pleno acesso',
          ),
          PermissionActionModel(
            module: 'financial_records',
            action: 'cancel',
            label: 'Cancelar Movimento',
            granted: roleId == '1',
            isCritical: true,
            description: 'Remove permanentemente um movimento já registrado.',
            impactLabel: 'Ação crítica',
          ),
          PermissionActionModel(
            module: 'financial_records',
            action: 'report',
            label: 'Ver Relatórios',
            granted: true,
            isInherited: roleId == '3',
            isReadOnly: roleId == '3',
            description: 'Permite visualizar relatórios consolidados de finanças.',
            impactLabel: 'Somente leitura',
          ),
        ],
      ),
      PermissionModuleGroup(
        module: 'accounts_payable',
        label: 'Contas a Pagar',
        description: 'Controle e aprovação dos pagamentos da igreja.',
        permissions: [
          PermissionActionModel(
            module: 'accounts_payable',
            action: 'create',
            label: 'Criar Conta a Pagar',
            granted: roleId != '3',
            description: 'Cadastro de novas contas e despesas recorrentes.',
            impactLabel: 'Acesso operacional',
          ),
          PermissionActionModel(
            module: 'accounts_payable',
            action: 'approve',
            label: 'Aprovar Pagamento',
            granted: roleId == '1',
            isCritical: true,
            description: 'Autoriza pagamentos e liquidações de contas.',
            impactLabel: 'Acesso crítico',
          ),
        ],
      ),
      PermissionModuleGroup(
        module: 'banking',
        label: 'Bancário',
        description:
            'Sincronização com extratos bancários e conciliações automáticas.',
        permissions: [
          PermissionActionModel(
            module: 'banking',
            action: 'sync',
            label: 'Sincronizar Extratos',
            granted: roleId == '1',
            isCritical: true,
            description: 'Importa dados bancários e atualiza saldos automaticamente.',
            impactLabel: 'Pleno acesso',
          ),
          PermissionActionModel(
            module: 'banking',
            action: 'view',
            label: 'Visualizar Saldos',
            granted: roleId != '3',
            description: 'Exibe saldos consolidados das contas bancárias.',
            impactLabel: 'Somente leitura',
          ),
        ],
      ),
    ];
  }
}
