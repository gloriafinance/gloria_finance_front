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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        return Dialog(
          insetPadding:
              isCompact
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
                  : EdgeInsets.zero,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1360,
              maxHeight:
                  isCompact
                      ? MediaQuery.sizeOf(context).height * 0.92
                      : MediaQuery.sizeOf(context).height,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isCompact ? 20 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DialogHeader(
                    title: l10n.settings_banks_asaas_dialog_title,
                    subtitle: l10n.settings_banks_asaas_dialog_subtitle,
                    onClose: () => Navigator.of(context).pop(),
                    isCompact: isCompact,
                  ),
                  SizedBox(height: isCompact ? 20 : 28),
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
      },
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
  final bool isCompact;

  const _DialogHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: AppColors.purple,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 24,
                      color: Colors.black,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onClose,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                icon: const Icon(Icons.close, color: AppColors.grey, size: 26),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 68, top: 4),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 14,
                color: AppColors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.menu_book_outlined,
            color: AppColors.purple,
            size: 46,
          ),
        ),
        const SizedBox(width: 22),
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
                    fontSize: 36,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 17,
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
        contributionFlow: true,
      ),
      _StepData(
        icon: Icons.receipt_long_outlined,
        title: l10n.settings_banks_asaas_step_reconcile_title,
        description: l10n.settings_banks_asaas_step_reconcile_description,
        completed: true,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;
          if (constraints.maxWidth < 1100) {
            return Column(
              children: List.generate(steps.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index == steps.length - 1
                            ? 0
                            : isCompact
                            ? 20
                            : 24,
                  ),
                  child: _IntegrationStep(
                    number: index + 1,
                    data: steps[index],
                    isCompact: isCompact,
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
        padding: const EdgeInsets.only(top: 98),
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
  final bool isCompact;

  const _IntegrationStep({
    required this.number,
    required this.data,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isCompact ? 24 : 26,
          height: isCompact ? 24 : 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: isCompact ? 16 : 17,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: isCompact ? 18 : 20),
        _StepIcon(data: data, isCompact: isCompact),
        SizedBox(height: isCompact ? 18 : 20),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: isCompact ? 20 : 20,
            color: Colors.black,
            height: 1.25,
          ),
        ),
        SizedBox(height: isCompact ? 10 : 10),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: isCompact ? 14 : 14,
            color: AppColors.grey,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  final _StepData data;
  final bool isCompact;

  const _StepIcon({required this.data, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    if (data.contributionFlow) {
      return SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _ContributionFlowGraphic(isCompact: isCompact),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: isCompact ? 94 : 88,
          height: isCompact ? 94 : 88,
          decoration: BoxDecoration(
            color:
                data.completed
                    ? AppColors.green.withValues(alpha: 0.1)
                    : AppColors.purple.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            data.icon,
            size: isCompact ? 48 : 48,
            color: AppColors.purple,
          ),
        ),
        if (data.completed)
          Positioned(
            right: 2,
            bottom: 3,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.green,
              child: const Icon(Icons.check, size: 20, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _ContributionFlowGraphic extends StatelessWidget {
  final bool isCompact;

  const _ContributionFlowGraphic({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? 240 : 248,
      height: isCompact ? 110 : 108,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 22 : 24),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(66),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.person_outline,
                size: 52,
                color: AppColors.purple,
              ),
              const Positioned(
                right: -4,
                bottom: 0,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: AppColors.green,
                  child: Icon(Icons.check, size: 17, color: Colors.white),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.qr_code_2_outlined,
                size: 34,
                color: AppColors.green,
              ),
              Text(
                'pix',
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 24,
                  color: AppColors.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const Icon(Icons.church_outlined, size: 54, color: AppColors.purple),
        ],
      ),
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
      padding: const EdgeInsets.all(28),
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
              fontSize: 22,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1050) {
                final isCompact = constraints.maxWidth < 620;
                final columns =
                    isCompact
                        ? 1
                        : constraints.maxWidth < 900
                        ? 2
                        : 3;
                final itemWidth =
                    (constraints.maxWidth - (columns - 1) * 20) / columns;

                return Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 20,
                  runSpacing: 22,
                  children: capabilities
                      .map(
                        (capability) => SizedBox(
                          width: itemWidth,
                          child: _CapabilityItem(
                            data: capability,
                            isCompact: isCompact,
                          ),
                        ),
                      )
                      .toList(growable: false),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(capabilities.length, (index) {
                  return Expanded(
                    child: _CapabilityItem(
                      data: capabilities[index],
                      showDivider: index != capabilities.length - 1,
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
  final bool isCompact;

  const _CapabilityItem({
    required this.data,
    this.showDivider = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //padding: EdgeInsets.only(right: 10),
              width: isCompact ? 36 : 52,
              height: isCompact ? 26 : 42,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(isCompact ? 12 : 14),
              ),
              child: Icon(
                data.icon,
                color: AppColors.purple,
                size: isCompact ? 20 : 26,
              ),
            ),
            const SizedBox(width: 26),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: isCompact ? 15 : 14,
                        color: Colors.black,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.description,
                      style: TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: isCompact ? 14 : 13,
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 24,
            vertical: isCompact ? 16 : 22,
          ),
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.16)),
          ),
          child: Row(
            children: [
              Container(
                width: isCompact ? 56 : 72,
                height: isCompact ? 56 : 72,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 14),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: isCompact ? 30 : 38,
                ),
              ),
              SizedBox(width: isCompact ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settings_banks_asaas_security_title,
                      style: TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: isCompact ? 16 : 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.settings_banks_asaas_security_description,
                      style: TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: isCompact ? 14 : 16,
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.lock_outline,
                  color: AppColors.purple.withValues(alpha: 0.22),
                  size: 72,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DialogActions extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onConnect;

  const _DialogActions({required this.onClose, this.onConnect});

  @override
  Widget build(BuildContext context) {
    final closeButton = CustomButton(
      text: context.l10n.settings_banks_asaas_close,
      backgroundColor: AppColors.purple,
      typeButton: CustomButton.outline,
      textColor: AppColors.purple,
      onPressed: onClose,
    );
    final connectButton = CustomButton(
      text: context.l10n.settings_banks_asaas_connect_account,
      backgroundColor: AppColors.purple,
      textColor: Colors.white,
      icon: Icons.arrow_forward,
      onPressed: onConnect,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (onConnect != null) connectButton,
              if (onConnect != null) const SizedBox(height: 12),
              closeButton,
            ],
          );
        }

        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 14,
          runSpacing: 12,
          children: [closeButton, if (onConnect != null) connectButton],
        );
      },
    );
  }
}

class _StepData {
  final IconData icon;
  final String title;
  final String description;
  final bool completed;
  final bool contributionFlow;

  const _StepData({
    required this.icon,
    required this.title,
    required this.description,
    this.completed = false,
    this.contributionFlow = false,
  });
}

class _CapabilityData {
  final IconData icon;
  final String title;
  final String description;

  const _CapabilityData(this.icon, this.title, this.description);
}
