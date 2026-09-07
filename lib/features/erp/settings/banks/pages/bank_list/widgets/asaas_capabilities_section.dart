import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

class AsaasCapabilitiesSection extends StatelessWidget {
  const AsaasCapabilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final capabilities = [
      _Capability(
        Icons.show_chart_outlined,
        l10n.settings_banks_asaas_capability_balance,
        l10n.settings_banks_asaas_capability_balance_description,
      ),
      _Capability(
        Icons.qr_code_2_outlined,
        l10n.settings_banks_asaas_capability_pix,
        l10n.settings_banks_asaas_capability_pix_description,
      ),
      _Capability(
        Icons.person_outline,
        l10n.settings_banks_asaas_capability_payments,
        l10n.settings_banks_asaas_capability_payments_description,
      ),
      _Capability(
        Icons.check_circle_outline,
        l10n.settings_banks_asaas_capability_reconcile,
        l10n.settings_banks_asaas_capability_reconcile_description,
      ),
      _Capability(
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
                final compact = constraints.maxWidth < 620;
                final columns =
                    compact
                        ? 1
                        : constraints.maxWidth < 900
                        ? 2
                        : 3;
                final itemWidth =
                    (constraints.maxWidth - (columns - 1) * 20) / columns;
                return Wrap(
                  spacing: 20,
                  runSpacing: 22,
                  children: capabilities
                      .map(
                        (item) => SizedBox(
                          width: itemWidth,
                          child: _CapabilityItem(data: item, compact: compact),
                        ),
                      )
                      .toList(growable: false),
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  capabilities.length,
                  (index) => Expanded(
                    child: _CapabilityItem(
                      data: capabilities[index],
                      divider: index != capabilities.length - 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CapabilityItem extends StatelessWidget {
  final _Capability data;
  final bool divider;
  final bool compact;
  const _CapabilityItem({
    required this.data,
    this.divider = false,
    this.compact = false,
  });
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: compact ? 36 : 52,
            height: compact ? 26 : 42,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(compact ? 12 : 14),
            ),
            child: Icon(
              data.icon,
              color: AppColors.purple,
              size: compact ? 20 : 26,
            ),
          ),
          const SizedBox(width: 26),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: compact ? 15 : 14,
                      color: Colors.black,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: compact ? 14 : 13,
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
      if (divider)
        const Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: VerticalDivider(color: AppColors.greyMiddle),
        ),
    ],
  );
}

class _Capability {
  final IconData icon;
  final String title;
  final String description;
  const _Capability(this.icon, this.title, this.description);
}
