import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/rbac_user_model.dart';
import '../models/role_model.dart';
import '../state/user_access_state.dart';
import '../store/user_access_store.dart';
import '../widgets/role_permission_matrix.dart';
import 'widgets/form_create_user.dart';

class UserAccessScreen extends StatefulWidget {
  const UserAccessScreen({super.key});

  @override
  State<UserAccessScreen> createState() => _UserAccessScreenState();
}

class _UserAccessScreenState extends State<UserAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserAccessStore()..bootstrap(),
      child: Consumer<UserAccessStore>(
        builder: (context, store, _) {
          final state = store.state;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, store),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 920;
                  if (isMobile) {
                    return _buildMobileLayout(context, store, state);
                  }
                  return _buildDesktopLayout(context, store, state);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    UserAccessStore store,
    UserAccessState state,
  ) {
    final filteredUsers = state.filteredUsers();
    final isSearching = state.searchQuery.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 320,
          child: _UserListPanel(
            users: filteredUsers,
            selectedUser: state.selectedUser,
            searchValue: state.searchQuery,
            onSearchChanged: store.updateSearchQuery,
            onUserSelected: store.selectUser,
            onCreateUser: () => _showCreateUserDialog(context, store),
            isBusy: state.loadingUsers,
            totalUsers: state.totalUsers,
            canLoadMore: state.canLoadMoreUsers,
            isLoadingMore: state.loadingMoreUsers,
            onLoadMore: store.loadNextUsersPage,
            isSearching: isSearching,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _UserDetailPanel(store: store)),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    UserAccessStore store,
    UserAccessState state,
  ) {
    final filteredUsers = state.filteredUsers();
    final isSearching = state.searchQuery.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UserListPanel(
          users: filteredUsers,
          selectedUser: state.selectedUser,
          searchValue: state.searchQuery,
          onSearchChanged: store.updateSearchQuery,
          onUserSelected: store.selectUser,
          onCreateUser: () => _showCreateUserDialog(context, store),
          isBusy: state.loadingUsers,
          totalUsers: state.totalUsers,
          canLoadMore: state.canLoadMoreUsers,
          isLoadingMore: state.loadingMoreUsers,
          onLoadMore: store.loadNextUsersPage,
          isSearching: isSearching,
        ),
        const SizedBox(height: 16),
        _UserDetailPanel(store: store, useExpansion: true),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, UserAccessStore store) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Usuários e acesso',
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Crie contas e atribua papéis para controlar o acesso da igreja.',
              ),
            ],
          ),
        ),
        ButtonActionTable(
          text: 'Novo usuário',
          icon: Icons.person_add_alt,
          color: AppColors.purple,
          onPressed: () => _showCreateUserDialog(context, store),
        ),
      ],
    );
  }

  Future<void> _showCreateUserDialog(
    BuildContext context,
    UserAccessStore store,
  ) async {
    final payload = await ModalPage(
      title: 'Criar usuário',
      width: 520,
      body: const FormCreateUser(),
    ).show<CreateUserResult>(context);

    if (payload != null) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      await store.createUser(
        name: payload.name,
        email: payload.email,
        password: payload.password,
        isActive: payload.isActive,
      );
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Usuário "${payload.name}" criado com sucesso.'),
        ),
      );
    }
  }
}

class _UserListPanel extends StatelessWidget {
  const _UserListPanel({
    required this.users,
    required this.selectedUser,
    required this.searchValue,
    required this.onSearchChanged,
    required this.onUserSelected,
    required this.onCreateUser,
    required this.isBusy,
    required this.totalUsers,
    required this.canLoadMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.isSearching,
  });

  final List<RbacUserModel> users;
  final RbacUserModel? selectedUser;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RbacUserModel> onUserSelected;
  final VoidCallback onCreateUser;
  final bool isBusy;
  final int totalUsers;
  final bool canLoadMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Usuários',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ButtonActionTable(
                  color: AppColors.purple,
                  text: 'Novo',
                  icon: Icons.add,
                  onPressed: onCreateUser,
                ),
              ],
            ),
            Input(
              label: 'Buscar por nome ou e-mail',
              icon: Icons.search,
              initialValue: searchValue,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 16),
            Text(
              'Mostrando ${users.length} de $totalUsers usuários',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (isBusy)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (users.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    const Text('Nenhum usuário encontrado.'),
                    const SizedBox(height: 8),
                    const Text('Crie o primeiro usuário para atribuir papéis.'),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isSelected = user.userId == selectedUser?.userId;
                  return _UserListTile(
                    user: user,
                    isSelected: isSelected,
                    onTap: () => onUserSelected(user),
                  );
                },
              ),
            if (!isBusy && canLoadMore && !isSearching) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child:
                    isLoadingMore
                        ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(),
                        )
                        : OutlinedButton.icon(
                          onPressed: onLoadMore,
                          icon: const Icon(Icons.expand_more),
                          label: const Text('Carregar mais'),
                        ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  final RbacUserModel user;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceVariant.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withOpacity(0.6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  user.isActive ? Icons.verified_user : Icons.block,
                  size: 18,
                  color:
                      user.isActive ? colorScheme.primary : colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            if (user.assignedRoles.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    user.assignedRoles
                        .take(3)
                        .map(
                          (role) => Chip(
                            label: Text(role),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
              ),
              if (user.assignedRoles.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${user.assignedRoles.length - 3} papéis',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserDetailPanel extends StatelessWidget {
  const _UserDetailPanel({required this.store, this.useExpansion = false});

  final UserAccessStore store;
  final bool useExpansion;

  @override
  Widget build(BuildContext context) {
    final state = store.state;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            state.selectedUser == null
                ? const _UserPlaceholder()
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _UserSummaryHeader(state: state),
                      const SizedBox(height: 12),
                      _AssignmentStatus(state: state),
                      const SizedBox(height: 16),
                      _RoleAssignmentList(
                        roles: state.roles,
                        selectedRoleIds: state.selectedRoleIds,
                        onToggle:
                            (role, granted) => store.toggleRole(role, granted),
                        isBusy: state.loadingRoles,
                      ),
                      const SizedBox(height: 24),
                      _EffectivePermissionsSection(
                        state: state,
                        useExpansion: useExpansion,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _UserSummaryHeader extends StatelessWidget {
  const _UserSummaryHeader({required this.state});

  final UserAccessState state;

  @override
  Widget build(BuildContext context) {
    final user = state.selectedUser!;
    final theme = Theme.of(context);
    final chips = <Widget>[
      Chip(
        label: Text(user.isActive ? 'Ativo' : 'Inativo'),
        avatar: Icon(
          user.isActive
              ? Icons.check_circle_outline
              : Icons.pause_circle_outline,
          size: 16,
          color:
              user.isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
        ),
        visualDensity: VisualDensity.compact,
      ),
      Chip(
        label: Text('${state.selectedRoleIds.length} papéis'),
        avatar: const Icon(Icons.shield_outlined, size: 16),
        visualDensity: VisualDensity.compact,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(user.email),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
      ],
    );
  }
}

class _AssignmentStatus extends StatelessWidget {
  const _AssignmentStatus({required this.state});

  final UserAccessState state;

  @override
  Widget build(BuildContext context) {
    if (state.savingAssignments) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Sincronizando papéis…'),
        ],
      );
    }

    if (state.pendingAssignments > 0) {
      return Row(
        children: [
          const Icon(Icons.pending_actions, size: 18),
          const SizedBox(width: 8),
          Text('${state.pendingAssignments} alterações pendentes'),
        ],
      );
    }

    if (state.lastSyncedAt != null) {
      final formatter = DateFormat('HH:mm');
      return Text(
        'Última sincronização às ${formatter.format(state.lastSyncedAt!)}',
      );
    }

    return const SizedBox.shrink();
  }
}

class _RoleAssignmentList extends StatelessWidget {
  const _RoleAssignmentList({
    required this.roles,
    required this.selectedRoleIds,
    required this.onToggle,
    required this.isBusy,
  });

  final List<RoleModel> roles;
  final Set<String> selectedRoleIds;
  final void Function(String roleId, bool granted) onToggle;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Papéis atribuídos',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (isBusy)
          const Center(child: CircularProgressIndicator())
        else if (roles.isEmpty)
          const Text(
            'Nenhum papel disponível. Crie papéis antes de atribuí-los.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: roles.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final role = roles[index];
              final isSelected = selectedRoleIds.contains(role.roleId);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (checked) async {
                  if (checked == null) return;
                  if (!checked && role.isSystem) {
                    final confirmed = await _confirmSystemRoleRemoval(
                      context,
                      role,
                    );
                    if (confirmed != true) {
                      return;
                    }
                  }
                  onToggle(role.roleId, checked);
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(role.name),
                subtitle:
                    role.description != null ? Text(role.description!) : null,
                secondary:
                    role.isSystem
                        ? const Tooltip(
                          message: 'Papel do sistema não pode ser removido.',
                          child: Icon(Icons.lock_outline),
                        )
                        : null,
              );
            },
          ),
      ],
    );
  }
}

Future<bool?> _confirmSystemRoleRemoval(BuildContext context, RoleModel role) {
  return ModalPage(
    title: 'Remover papel do sistema?',
    width: 520,
    body: _SystemRoleRemovalDialog(role: role),
  ).show<bool>(context);
}

class _EffectivePermissionsSection extends StatelessWidget {
  const _EffectivePermissionsSection({
    required this.state,
    required this.useExpansion,
  });

  final UserAccessState state;
  final bool useExpansion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Permissões efetivas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message:
                  'Permissões resultantes da combinação de todos os papéis atribuídos.',
              child: const Icon(Icons.info_outline, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.loadingAuthorization)
          const Center(child: CircularProgressIndicator())
        else if (state.effectivePermissions.isEmpty)
          const Text('Nenhuma permissão efetiva. Atribua papéis ao usuário.')
        else
          RolePermissionMatrix(
            modules: state.effectivePermissions,
            onPermissionToggle: null,
            onModuleToggle: null,
            isLoading: false,
            useExpansionLayout: useExpansion,
            readOnly: true,
          ),
      ],
    );
  }
}

class _UserPlaceholder extends StatelessWidget {
  const _UserPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Selecione um usuário para visualizar suas permissões.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SystemRoleRemovalDialog extends StatelessWidget {
  const _SystemRoleRemovalDialog({required this.role});

  final RoleModel role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O papel "${role.name}" faz parte da configuração base. Tem certeza que deseja removê-lo deste usuário?',
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ButtonActionTable(
                  color: AppColors.greyMiddle,
                  text: 'Cancelar',
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ButtonActionTable(
                  color: Colors.redAccent,
                  text: 'Remover',
                  icon: Icons.delete_outline,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
