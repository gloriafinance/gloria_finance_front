import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/confirmation_dialog.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/permission_action_model.dart';
import '../models/permission_module_group.dart';
import '../state/role_permission_state.dart';
import '../store/role_permission_store.dart';
import '../widgets/create_role_form.dart';
import '../widgets/role_permission_matrix.dart';
import '../widgets/role_selector_panel.dart';

class RolePermissionScreen extends StatefulWidget {
  const RolePermissionScreen({super.key});

  @override
  State<RolePermissionScreen> createState() => _RolePermissionScreenState();
}

class _RolePermissionScreenState extends State<RolePermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RolePermissionStore()..bootstrap(),
      child: Consumer<RolePermissionStore>(
        builder: (context, store, _) {
          final state = store.state;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, store),

              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 920;
                  if (isMobile) {
                    return _buildMobileLayout(context, store);
                  }
                  return _buildDesktopLayout(context, store);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, RolePermissionStore store) {
    final state = store.state;
    final filteredRoles = state.filteredRoles();
    final filteredModules = state.filteredModules();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 320,
          child: RoleSelectorPanel(
            roles: filteredRoles,
            selectedRole: state.selectedRole,
            searchValue: state.roleSearchQuery,
            onSearchChanged: store.updateRoleSearch,
            onRoleSelected: (role) => store.selectRole(role),
            onCreateRole: () => _showCreateRoleDialog(context, store),
            isBusy: state.loadingRoles,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _RoleDetailPanel(
            store: store,
            modules: filteredModules,
            permissionSearchQuery: state.searchQuery,
            onPermissionSearch: store.updatePermissionSearch,
            onPermissionToggle:
                (permission, granted) => _handlePermissionToggle(
                  context,
                  store,
                  permission,
                  granted,
                ),
            onModuleToggle:
                (module, granted) =>
                    _handleModuleToggle(context, store, module, granted),
            isLoading: state.loadingPermissions,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, RolePermissionStore store) {
    final state = store.state;
    final filteredRoles = state.filteredRoles();
    final filteredModules = state.filteredModules();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoleSelectorPanel(
          roles: filteredRoles,
          selectedRole: state.selectedRole,
          searchValue: state.roleSearchQuery,
          onSearchChanged: store.updateRoleSearch,
          onRoleSelected: (role) {
            store.selectRole(role);
          },
          onCreateRole: () => _showCreateRoleDialog(context, store),
          isBusy: state.loadingRoles,
        ),
        const SizedBox(height: 16),
        _RoleDetailPanel(
          store: store,
          modules: filteredModules,
          permissionSearchQuery: state.searchQuery,
          onPermissionSearch: store.updatePermissionSearch,
          onPermissionToggle:
              (permission, granted) =>
                  _handlePermissionToggle(context, store, permission, granted),
          onModuleToggle:
              (module, granted) =>
                  _handleModuleToggle(context, store, module, granted),
          isLoading: state.loadingPermissions,
          useExpansion: true,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, RolePermissionStore store) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perfis e permissões',
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Gerencie papéis, permissões e impactos de acesso na igreja.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        ButtonActionTable(
          color: AppColors.purple,
          text: 'Novo papel',
          icon: Icons.add,
          onPressed: () => _showCreateRoleDialog(context, store),
        ),
      ],
    );
  }

  Future<void> _showCreateRoleDialog(
    BuildContext context,
    RolePermissionStore store,
  ) async {
    final modal = ModalPage(
      title: 'Criar novo papel',
      width: 520,
      body: Builder(
        builder: (dialogContext) {
          return CreateRoleForm(
            onCancel: () => Navigator.of(dialogContext).pop(),
            onSubmit: (name, description) {
              Navigator.of(dialogContext).pop((name, description));
            },
          );
        },
      ),
    );

    final result = await modal.show<(String name, String? description)>(
      context,
    );

    if (result != null) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      await store.createRole(name: result.$1, description: result.$2);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Papel "${result.$1}" criado com sucesso.')),
      );
    }
  }

  Future<void> _handlePermissionToggle(
    BuildContext context,
    RolePermissionStore store,
    PermissionActionModel permission,
    bool granted,
  ) async {
    if (!granted && permission.isCritical) {
      final confirmed = await _showCriticalRemovalDialog(
        context,
        message:
            'Remover a permissão "${permission.label}" pode bloquear ações críticas. Deseja continuar?',
      );
      if (confirmed != true) {
        return;
      }
    }
    store.togglePermission(
      moduleId: permission.module,
      action: permission.action,
      granted: granted,
    );
  }

  Future<void> _handleModuleToggle(
    BuildContext context,
    RolePermissionStore store,
    PermissionModuleGroup module,
    bool granted,
  ) async {
    if (!granted) {
      final fullModule = store.state.modules.firstWhere(
        (element) => element.module == module.module,
        orElse: () => module,
      );
      final hasCritical = fullModule.permissions.any(
        (permission) => permission.isCritical && permission.granted,
      );
      if (hasCritical) {
        final confirmed = await _showCriticalRemovalDialog(
          context,
          message:
              'Existem permissões críticas ativas em "${module.label}". Deseja desabilitá-las?',
        );
        if (confirmed != true) {
          return;
        }
      }
    }
    store.toggleModule(module.module, granted);
  }

  Future<bool?> _showCriticalRemovalDialog(
    BuildContext context, {
    required String message,
  }) {
    return confirmationDialog(context, message);
  }
}

class _RoleDetailPanel extends StatelessWidget {
  const _RoleDetailPanel({
    required this.store,
    required this.modules,
    required this.permissionSearchQuery,
    required this.onPermissionSearch,
    required this.onPermissionToggle,
    required this.onModuleToggle,
    required this.isLoading,
    this.useExpansion = false,
  });

  final RolePermissionStore store;
  final List<PermissionModuleGroup> modules;
  final String permissionSearchQuery;
  final ValueChanged<String> onPermissionSearch;
  final PermissionToggleCallback onPermissionToggle;
  final ModuleToggleCallback onModuleToggle;
  final bool isLoading;
  final bool useExpansion;

  @override
  Widget build(BuildContext context) {
    final state = store.state;
    final selectedRole = state.selectedRole;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedRole == null)
              const _RoleNotSelectedPlaceholder()
            else ...[
              _RoleHeaderSummary(state: state),
              const SizedBox(height: 16),
              Input(
                label: 'Buscar módulo ou permissão',
                icon: Icons.search,
                initialValue: permissionSearchQuery,
                onChanged: onPermissionSearch,
              ),
              const SizedBox(height: 8),
              _SavingIndicator(state: state),
              const SizedBox(height: 8),
              RolePermissionMatrix(
                modules: modules,
                onPermissionToggle: onPermissionToggle,
                onModuleToggle: onModuleToggle,
                isLoading: isLoading,
                searchQuery: state.searchQuery,
                useExpansionLayout: useExpansion,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoleHeaderSummary extends StatelessWidget {
  const _RoleHeaderSummary({required this.state});

  final RolePermissionState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('HH:mm');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.selectedRole?.name ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (state.selectedRole?.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(state.selectedRole!.description!),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(
              avatar: const Icon(Icons.check_circle_outline),
              label: Text(
                '${state.totalGranted} de ${state.totalPermissions} ativas',
              ),
              visualDensity: VisualDensity.compact,
            ),
            if (state.pendingChanges > 0)
              Chip(
                label: Text('${state.pendingChanges} alterações pendentes'),
                visualDensity: VisualDensity.compact,
                backgroundColor: theme.colorScheme.tertiaryContainer,
              )
            else if (state.lastSavedAt != null)
              Text(
                'Sincronizado às ${formatter.format(state.lastSavedAt!)}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ],
    );
  }
}

class _SavingIndicator extends StatelessWidget {
  const _SavingIndicator({required this.state});

  final RolePermissionState state;

  @override
  Widget build(BuildContext context) {
    if (!state.saving && state.pendingChanges == 0) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            state.saving
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.saving)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.pending_actions, size: 18),
          const SizedBox(width: 8),
          Text(state.saving ? 'Salvando alterações…' : 'Alterações pendentes'),
        ],
      ),
    );
  }
}

class _RoleNotSelectedPlaceholder extends StatelessWidget {
  const _RoleNotSelectedPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Selecione um papel para gerenciar suas permissões.',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
