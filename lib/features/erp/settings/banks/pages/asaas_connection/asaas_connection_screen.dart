import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/asaas_connection/state/asaas_connection_state.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/asaas_connection_store.dart';
import 'widgets/asaas_connection_confirmation.dart';
import 'widgets/asaas_connection_form.dart';

class AsaasConnectionScreen extends StatelessWidget {
  const AsaasConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => AsaasConnectionStore(),
      child: const _AsaasConnectionContent(),
    );
  }
}

class _AsaasConnectionContent extends StatelessWidget {
  const _AsaasConnectionContent();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AsaasConnectionStore>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Breadcrumbs(),
        const SizedBox(height: 10),
        const _Header(),
        const SizedBox(height: 22),
        _ConnectionProgress(
          isComplete: state.step == AsaasConnectionStep.confirmation,
        ),
        const SizedBox(height: 32),
        if (state.step == AsaasConnectionStep.form)
          AsaasConnectionForm(onBack: () => context.go('/banks'))
        else if (state.connection != null)
          AsaasConnectionConfirmation(
            connection: state.connection!,
            onFinish: () => context.go('/banks'),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.settings_banks_asaas_connect_title,
      style: const TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 26,
        color: Colors.black,
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.settings_banks_asaas_connect_breadcrumb_settings,
      l10n.settings_banks_asaas_connect_breadcrumb_integrations,
      l10n.settings_banks_asaas_connect_breadcrumb_asaas,
    ];

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Text(
            labels[index],
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color:
                  index == labels.length - 1
                      ? AppColors.purple
                      : AppColors.grey,
            ),
          ),
          if (index < labels.length - 1)
            const Icon(Icons.chevron_right, size: 18, color: AppColors.grey),
        ],
      ],
    );
  }
}

class _ConnectionProgress extends StatelessWidget {
  final bool isComplete;

  const _ConnectionProgress({required this.isComplete});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 960) {
          return _ProgressLabel(
            icon: isComplete ? Icons.check : Icons.key_outlined,
            label:
                isComplete
                    ? l10n.settings_banks_asaas_connect_progress_confirmation
                    : l10n.settings_banks_asaas_connect_progress_api_key,
            active: true,
          );
        }

        return Row(
          children: [
            _ProgressLabel(
              icon: Icons.check,
              label: l10n.settings_banks_asaas_connect_progress_instructions,
              active: false,
              completed: true,
            ),
            const _ProgressLine(active: true),
            _ProgressLabel(
              icon: isComplete ? Icons.check : null,
              number: 2,
              label: l10n.settings_banks_asaas_connect_progress_api_key,
              active: !isComplete,
              completed: isComplete,
            ),
            _ProgressLine(active: isComplete),
            _ProgressLabel(
              icon: isComplete ? Icons.check : null,
              number: 3,
              label: l10n.settings_banks_asaas_connect_progress_confirmation,
              active: isComplete,
            ),
          ],
        );
      },
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final bool active;

  const _ProgressLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: active ? AppColors.purple : AppColors.greyMiddle,
      ),
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  final IconData? icon;
  final int? number;
  final String label;
  final bool active;
  final bool completed;

  const _ProgressLabel({
    required this.icon,
    required this.label,
    required this.active,
    this.number,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        completed
            ? AppColors.green
            : active
            ? AppColors.purple
            : AppColors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: completed || active ? color : AppColors.greyLight,
            shape: BoxShape.circle,
            border:
                completed || active
                    ? null
                    : Border.all(color: AppColors.greyMiddle),
          ),
          child:
              icon != null
                  ? Icon(icon, color: Colors.white, size: 20)
                  : Text(
                    '$number',
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      color: active ? Colors.white : Colors.black87,
                    ),
                  ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 14,
            color: active ? AppColors.purple : Colors.black87,
          ),
        ),
      ],
    );
  }
}
