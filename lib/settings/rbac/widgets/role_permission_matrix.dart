import 'dart:math';

import 'package:flutter/material.dart';

import '../models/permission_action_model.dart';
import '../models/permission_module_group.dart';

typedef PermissionToggleCallback = Future<void> Function(
  PermissionActionModel permission,
  bool granted,
);
typedef ModuleToggleCallback = Future<void> Function(
  PermissionModuleGroup module,
  bool granted,
);

class RolePermissionMatrix extends StatelessWidget {
  const RolePermissionMatrix({
    super.key,
    required this.modules,
    required this.onPermissionToggle,
    required this.onModuleToggle,
    this.isLoading = false,
    this.searchQuery,
    this.useExpansionLayout = false,
  });

  final List<PermissionModuleGroup> modules;
  final PermissionToggleCallback? onPermissionToggle;
  final ModuleToggleCallback? onModuleToggle;
  final bool isLoading;
  final String? searchQuery;
  final bool useExpansionLayout;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (modules.isEmpty) {
      return _EmptyState(searchQuery: searchQuery);
    }

    if (useExpansionLayout) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return _ModuleExpansionTile(
            module: module,
            onModuleToggle: onModuleToggle,
            onPermissionToggle: onPermissionToggle,
            searchQuery: searchQuery,
          );
        },
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return _ModuleCard(
          module: module,
          onModuleToggle: onModuleToggle,
          onPermissionToggle: onPermissionToggle,
          searchQuery: searchQuery,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.module,
    required this.onPermissionToggle,
    required this.onModuleToggle,
    this.searchQuery,
  });

  final PermissionModuleGroup module;
  final PermissionToggleCallback? onPermissionToggle;
  final ModuleToggleCallback? onModuleToggle;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.outlineVariant;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModuleHeader(
              module: module,
              onModuleToggle: onModuleToggle,
            ),
            const SizedBox(height: 8),
            _ModuleSummary(module: module),
            if (module.description != null) ...[
              const SizedBox(height: 8),
              Text(
                module.description!,
                style: theme.textTheme.bodySmall,
              ),
            ],
            const Divider(height: 24),
            _PermissionList(
              permissions: module.permissions,
              onPermissionToggle: onPermissionToggle,
              module: module,
              searchQuery: searchQuery,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleExpansionTile extends StatelessWidget {
  const _ModuleExpansionTile({
    required this.module,
    required this.onPermissionToggle,
    required this.onModuleToggle,
    this.searchQuery,
  });

  final PermissionModuleGroup module;
  final PermissionToggleCallback? onPermissionToggle;
  final ModuleToggleCallback? onModuleToggle;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: _ModuleTitle(module: module),
        subtitle: _ModuleSummary(module: module),
        trailing: _ModuleToggleButton(module: module, onModuleToggle: onModuleToggle),
        children: [
          if (module.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  module.description!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          const SizedBox(height: 8),
          _PermissionList(
            permissions: module.permissions,
            onPermissionToggle: onPermissionToggle,
            module: module,
            searchQuery: searchQuery,
          ),
        ],
      ),
    );
  }
}

class _PermissionList extends StatelessWidget {
  const _PermissionList({
    required this.permissions,
    required this.onPermissionToggle,
    required this.module,
    this.searchQuery,
  });

  final List<PermissionActionModel> permissions;
  final PermissionToggleCallback? onPermissionToggle;
  final PermissionModuleGroup module;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: permissions.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final permission = permissions[index];
        return _PermissionTile(
          permission: permission,
          module: module,
          onPermissionToggle: onPermissionToggle,
          searchQuery: searchQuery,
        );
      },
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.permission,
    required this.module,
    required this.onPermissionToggle,
    this.searchQuery,
  });

  final PermissionActionModel permission;
  final PermissionModuleGroup module;
  final PermissionToggleCallback onPermissionToggle;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = permission.isReadOnly
        ? theme.disabledColor
        : theme.textTheme.bodyMedium?.color;
    final highlight = searchQuery?.isNotEmpty == true
        ? searchQuery!.toLowerCase()
        : null;

    final labelWidget = highlight == null
        ? Text(permission.label)
        : _HighlightText(text: permission.label, query: highlight);

    return CheckboxListTile(
      value: permission.granted,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: permission.isReadOnly
          ? null
          : (value) {
              if (value == null) {
                return;
              }
              final callback = onPermissionToggle;
              if (callback != null) {
                callback(permission, value);
              }
            },
      dense: true,
      title: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(color: textColor),
        child: Row(
          children: [
            Flexible(child: labelWidget),
            const SizedBox(width: 8),
            if (permission.isInherited) const _PermissionBadge(label: 'Efetivo'),
            if (permission.isReadOnly)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: _PermissionBadge(label: 'Somente leitura'),
              ),
            if (permission.isCritical)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Tooltip(
                  message: 'Esta permissão impacta ações críticas do sistema.',
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (permission.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                permission.description!,
                style: theme.textTheme.bodySmall?.copyWith(color: textColor),
              ),
            ),
          if (permission.impactLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _ImpactChip(permission: permission),
            ),
        ],
      ),
      tileColor: permission.isInherited
          ? theme.colorScheme.surfaceVariant.withOpacity(0.35)
          : null,
    );
  }
}

class _ImpactChip extends StatelessWidget {
  const _ImpactChip({required this.permission});

  final PermissionActionModel permission;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = _impactColors(colorScheme, permission);
    return Chip(
      label: Text(permission.impactLabel!),
      backgroundColor: colors.background,
      labelStyle: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: colors.foreground),
      visualDensity: VisualDensity.compact,
    );
  }

  ({Color background, Color foreground}) _impactColors(
    ColorScheme colorScheme,
    PermissionActionModel permission,
  ) {
    if (permission.isCritical) {
      return (background: colorScheme.errorContainer, foreground: colorScheme.onErrorContainer);
    }
    if (permission.isReadOnly || permission.isInherited) {
      return (background: colorScheme.surfaceVariant, foreground: colorScheme.onSurfaceVariant);
    }
    return (background: colorScheme.primaryContainer, foreground: colorScheme.onPrimaryContainer);
  }
}

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({
    required this.module,
    required this.onModuleToggle,
  });

  final PermissionModuleGroup module;
  final ModuleToggleCallback onModuleToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ModuleToggleButton(module: module, onModuleToggle: onModuleToggle),
        const SizedBox(width: 12),
        Expanded(child: _ModuleTitle(module: module)),
        Tooltip(
          message: module.description ?? 'Módulo ${module.label}',
          child: const Icon(Icons.help_outline, size: 20),
        ),
      ],
    );
  }
}

class _ModuleToggleButton extends StatelessWidget {
  const _ModuleToggleButton({
    required this.module,
    required this.onModuleToggle,
  });

  final PermissionModuleGroup module;
  final ModuleToggleCallback onModuleToggle;

  @override
  Widget build(BuildContext context) {
    final grantedCount = module.grantedCount;
    final total = module.permissions.length;
    final value = total == 0
        ? false
        : grantedCount == total
            ? true
            : grantedCount > 0
                ? null
                : false;

    return Checkbox(
      value: value,
      tristate: true,
      onChanged: total == 0
          ? null
          : (checked) {
              final callback = onModuleToggle;
              if (callback == null) {
                return;
              }
              if (checked == null) {
                callback(module, false);
              } else {
                callback(module, checked);
              }
            },
    );
  }
}

class _ModuleTitle extends StatelessWidget {
  const _ModuleTitle({required this.module});

  final PermissionModuleGroup module;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      module.label,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ModuleSummary extends StatelessWidget {
  const _ModuleSummary({required this.module});

  final PermissionModuleGroup module;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '${module.grantedCount} de ${module.permissions.length} permissões ativas',
      style: theme.textTheme.bodySmall,
    );
  }
}

class _PermissionBadge extends StatelessWidget {
  const _PermissionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  const _HighlightText({required this.text, required this.query});

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    final lower = text.toLowerCase();
    final index = lower.indexOf(query);
    if (index == -1) {
      return Text(text);
    }
    final end = index + query.length;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, index), style: DefaultTextStyle.of(context).style),
          TextSpan(
            text: text.substring(index, min(end, text.length)),
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(min(end, text.length))),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.searchQuery});

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = searchQuery?.trim();
    final message = (query?.isNotEmpty ?? false)
        ? 'Nenhuma permissão encontrada para "$query".'
        : 'Selecione um papel para visualizar as permissões.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.security_outlined, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
