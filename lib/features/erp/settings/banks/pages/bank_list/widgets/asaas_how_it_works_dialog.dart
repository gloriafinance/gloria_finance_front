import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

class AsaasHowItWorksDialog extends StatelessWidget {
  final VoidCallback? onConnectAsaas;

  const AsaasHowItWorksDialog({super.key, this.onConnectAsaas});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1120,
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(
                title: l10n.settings_banks_asaas_dialog_title,
                subtitle: l10n.settings_banks_asaas_dialog_subtitle,
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 28),
              const _IntegrationSteps(),
              const SizedBox(height: 20),
              const _CapabilitiesSection(),
              const SizedBox(height: 20),
              const _SecuritySection(),
              const SizedBox(height: 28),
              _DialogActions(
                onClose: () => Navigator.of(context).pop(),
                onConnect:
                    onConnectAsaas == null ? null : () => _connect(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _connect(BuildContext context) {
    Navigator.of(context).pop();
    onConnectAsaas?.call();
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onClose;

  const _DialogHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.menu_book_outlined,
            color: AppColors.purple,
            size: 32,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 28,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 16,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: AppColors.grey, size: 30),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
      ],
    );
  }
}

class _IntegrationSteps extends StatelessWidget {
  const _IntegrationSteps();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      _StepData(
        icon: Icons.key_outlined,
        title: l10n.settings_banks_asaas_step_connect_title,
        description: l10n.settings_banks_asaas_step_connect_description,
      ),
      _StepData(
        icon: Icons.volunteer_activism_outlined,
        title: l10n.settings_banks_asaas_step_contribution_title,
        description: l10n.settings_banks_asaas_step_contribution_description,
      ),
      _StepData(
        icon: Icons.receipt_long_outlined,
        title: l10n.settings_banks_asaas_step_reconcile_title,
        description: l10n.settings_banks_asaas_step_reconcile_description,
        completed: true,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Column(
              children: List.generate(steps.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == steps.length - 1 ? 0 : 28,
                  ),
                  child: _IntegrationStep(
                    number: index + 1,
                    data: steps[index],
                  ),
                );
              }),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _IntegrationStep(number: 1, data: steps[0])),
              const _StepConnector(),
              Expanded(child: _IntegrationStep(number: 2, data: steps[1])),
              const _StepConnector(),
              Expanded(child: _IntegrationStep(number: 3, data: steps[2])),
            ],
          );
        },
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Padding(
        padding: const EdgeInsets.only(top: 92),
        child: Row(
          children: [
            const Expanded(
              child: Divider(color: Color(0xFFD9C8F5), thickness: 2),
            ),
            Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5D9F7)),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: AppColors.purple,
                size: 24,
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0xFFD9C8F5), thickness: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntegrationStep extends StatelessWidget {
  final int number;
  final _StepData data;

  const _IntegrationStep({required this.number, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 22),
        _StepIcon(icon: data.icon, completed: data.completed),
        const SizedBox(height: 18),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: AppColors.grey,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final bool completed;

  const _StepIcon({required this.icon, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 116,
          height: 116,
          decoration: BoxDecoration(
            color:
                completed
                    ? AppColors.green.withValues(alpha: 0.1)
                    : AppColors.purple.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 52, color: AppColors.purple),
        ),
        if (completed)
          const Positioned(
            right: 2,
            bottom: 5,
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.green,
              child: Icon(Icons.check, size: 22, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _CapabilitiesSection extends StatelessWidget {
  const _CapabilitiesSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final capabilities = [
      _CapabilityData(
        Icons.show_chart_outlined,
        l10n.settings_banks_asaas_capability_balance,
        l10n.settings_banks_asaas_capability_balance_description,
      ),
      _CapabilityData(
        Icons.qr_code_2_outlined,
        l10n.settings_banks_asaas_capability_pix,
        l10n.settings_banks_asaas_capability_pix_description,
      ),
      _CapabilityData(
        Icons.person_outline,
        l10n.settings_banks_asaas_capability_payments,
        l10n.settings_banks_asaas_capability_payments_description,
      ),
      _CapabilityData(
        Icons.check_circle_outline,
        l10n.settings_banks_asaas_capability_reconcile,
        l10n.settings_banks_asaas_capability_reconcile_description,
      ),
      _CapabilityData(
        Icons.webhook_outlined,
        l10n.settings_banks_asaas_capability_webhooks,
        l10n.settings_banks_asaas_capability_webhooks_description,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings_banks_asaas_capabilities_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 760) {
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: capabilities
                      .map(
                        (capability) => SizedBox(
                          width:
                              constraints.maxWidth < 480
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 18) / 2,
                          child: _CapabilityItem(data: capability),
                        ),
                      )
                      .toList(growable: false),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(capabilities.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 14,
                        right: index == capabilities.length - 1 ? 0 : 14,
                      ),
                      child: _CapabilityItem(
                        data: capabilities[index],
                        showDivider: index != capabilities.length - 1,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CapabilityItem extends StatelessWidget {
  final _CapabilityData data;
  final bool showDivider;

  const _CapabilityItem({required this.data, this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: AppColors.purple, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 13,
                      color: Colors.black,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 12,
                      color: AppColors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider)
          const Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: VerticalDivider(color: AppColors.greyMiddle),
          ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings_banks_asaas_security_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.settings_banks_asaas_security_description,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.lock_outline,
            color: AppColors.purple.withValues(alpha: 0.22),
            size: 54,
          ),
        ],
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onConnect;

  const _DialogActions({required this.onClose, this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 14,
      runSpacing: 12,
      children: [
        CustomButton(
          text: context.l10n.settings_banks_asaas_close,
          backgroundColor: AppColors.purple,
          typeButton: CustomButton.outline,
          textColor: AppColors.purple,
          onPressed: onClose,
        ),
        if (onConnect != null)
          CustomButton(
            text: context.l10n.settings_banks_asaas_connect_account,
            backgroundColor: AppColors.purple,
            textColor: Colors.white,
            icon: Icons.arrow_forward,
            onPressed: onConnect,
          ),
      ],
    );
  }
}

class _StepData {
  final IconData icon;
  final String title;
  final String description;
  final bool completed;

  const _StepData({
    required this.icon,
    required this.title,
    required this.description,
    this.completed = false,
  });
}

class _CapabilityData {
  final IconData icon;
  final String title;
  final String description;

  const _CapabilityData(this.icon, this.title, this.description);
}
