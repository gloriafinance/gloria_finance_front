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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DialogHeader(
                title: l10n.settings_banks_asaas_dialog_title,
                subtitle: l10n.settings_banks_asaas_dialog_subtitle,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.greyMiddle),
                ),
                child: Column(
                  children: [
                    const _IntegrationSteps(),
                    const SizedBox(height: 28),
                    const _CapabilitiesSection(),
                    const SizedBox(height: 16),
                    const _SecuritySection(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.end,
                  children: [
                    CustomButton(
                      text: l10n.settings_banks_asaas_close,
                      backgroundColor: AppColors.purple,
                      typeButton: CustomButton.outline,
                      textColor: AppColors.purple,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    if (onConnectAsaas != null)
                      CustomButton(
                        text: l10n.settings_banks_asaas_connect_account,
                        backgroundColor: AppColors.purple,
                        textColor: Colors.white,
                        onPressed: () => _connect(context),
                        icon: Icons.arrow_forward,
                      ),
                  ],
                ),
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

  const _DialogHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: AppColors.grey),
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
        Icons.key_outlined,
        l10n.settings_banks_asaas_step_connect_title,
        l10n.settings_banks_asaas_step_connect_description,
      ),
      _StepData(
        Icons.sync_outlined,
        l10n.settings_banks_asaas_step_sync_title,
        l10n.settings_banks_asaas_step_sync_description,
      ),
      _StepData(
        Icons.qr_code_2_outlined,
        l10n.settings_banks_asaas_step_pix_title,
        l10n.settings_banks_asaas_step_pix_description,
      ),
      _StepData(
        Icons.check_circle_outline,
        l10n.settings_banks_asaas_step_reconcile_title,
        l10n.settings_banks_asaas_step_reconcile_description,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const SizedBox(
                  width: 32,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: AppColors.grey,
                    ),
                  ),
                );
              }
              final stepIndex = index ~/ 2;
              return Expanded(
                child: _IntegrationStep(
                  number: stepIndex + 1,
                  data: steps[stepIndex],
                ),
              );
            }),
          );
        }

        final twoColumns = constraints.maxWidth >= 480;
        final width =
            twoColumns ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 20,
          children: List.generate(
            steps.length,
            (index) => SizedBox(
              width: width,
              child: _IntegrationStep(number: index + 1, data: steps[index]),
            ),
          ),
        );
      },
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
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.2)),
          ),
          child: Icon(data.icon, color: AppColors.purple, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 14,
            color: Colors.black,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 12,
            color: Colors.black54,
            height: 1.4,
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
      l10n.settings_banks_asaas_capability_balance,
      l10n.settings_banks_asaas_capability_pix,
      l10n.settings_banks_asaas_capability_payments,
      l10n.settings_banks_asaas_capability_reconcile,
      l10n.settings_banks_asaas_capability_webhooks,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings_banks_asaas_capabilities_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 640) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: capabilities
                      .map(
                        (capability) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _CapabilityItem(
                              text: capability,
                              expandText: true,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                );
              }

              return Wrap(
                spacing: 18,
                runSpacing: 12,
                children: capabilities
                    .map((capability) => _CapabilityItem(text: capability))
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CapabilityItem extends StatelessWidget {
  final String text;
  final bool expandText;

  const _CapabilityItem({required this.text, this.expandText = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: expandText ? MainAxisSize.max : MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, size: 17, color: AppColors.green),
        const SizedBox(width: 7),
        if (expandText)
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.purple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings_banks_asaas_security_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.settings_banks_asaas_security_description,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  final IconData icon;
  final String title;
  final String description;

  const _StepData(this.icon, this.title, this.description);
}
