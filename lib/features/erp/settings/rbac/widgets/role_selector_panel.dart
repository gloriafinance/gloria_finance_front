import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';

import '../models/role_model.dart';

class RoleSelectorPanel extends StatelessWidget {
  const RoleSelectorPanel({
    super.key,
    required this.roles,
    required this.selectedRole,
    required this.searchValue,
    required this.onSearchChanged,
    required this.onRoleSelected,
    this.onCreateRole,
    this.isBusy = false,
  });

  final List<RoleModel> roles;
  final RoleModel? selectedRole;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RoleModel> onRoleSelected;
  final VoidCallback? onCreateRole;
  final bool isBusy;

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
                    'Papéis',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (onCreateRole != null)
                  ButtonActionTable(
                    color: AppColors.purple,
                    text: 'Novo',
                    icon: Icons.add,
                    onPressed: onCreateRole!,
                  ),
              ],
            ),
            Input(
              label: 'Buscar papéis',
              icon: Icons.search,
              initialValue: searchValue,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 16),
            if (isBusy)
              const Center(child: CircularProgressIndicator())
            else if (roles.isEmpty)
              _EmptyRolesState(onCreateRole: onCreateRole)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final role = roles[index];
                  final isSelected =
                      role.apiIdentifier == selectedRole?.apiIdentifier;
                  return _RoleTile(
                    role: role,
                    isSelected: isSelected,
                    onTap: () => onRoleSelected(role),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: roles.length,
              ),
          ],
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  final RoleModel role;
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
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceVariant.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
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
                    role.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (role.isDefault)
                  const _RoleBadge(
                    icon: Icons.verified_outlined,
                    label: 'Padrão',
                  ),
              ],
            ),
            if (role.description != null && role.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  role.description!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _RoleCounterChip(
                  label: 'Usuários',
                  count: role.membersCount,
                ),
                _RoleCounterChip(
                  label: role.isCustom ? 'Personalizado' : 'Sistema',
                  count: null,
                ),
              ],
            ),
            if (role.assignedUsers.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: role.assignedUsers
                    .take(6)
                    .map((user) => Chip(
                          label: Text(user),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
              if (role.assignedUsers.length > 6)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${role.assignedUsers.length - 6} outros',
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

class _RoleCounterChip extends StatelessWidget {
  const _RoleCounterChip({required this.label, this.count});

  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(count != null ? '$label: $count' : label),
      labelStyle: theme.textTheme.labelSmall,
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRolesState extends StatelessWidget {
  const _EmptyRolesState({this.onCreateRole});

  final VoidCallback? onCreateRole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups_outlined, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            'Nenhum papel encontrado',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          const Text('Crie um papel personalizado para começar a atribuir permissões.'),
          const SizedBox(height: 12),
          if (onCreateRole != null)
            CustomButton(
              text: 'Criar papel',
              backgroundColor: AppColors.purple,
              textColor: Colors.white,
              onPressed: onCreateRole,
            ),
        ],
      ),
    );
  }
}
