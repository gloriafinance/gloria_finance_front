import 'package:flutter/material.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_capabilities_section.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_how_it_works_dialog_actions.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_how_it_works_dialog_header.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_integration_steps.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_security_section.dart';

class AsaasHowItWorksDialog extends StatelessWidget {
  final VoidCallback? onConnectAsaas;

  const AsaasHowItWorksDialog({super.key, this.onConnectAsaas});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;
        return Dialog(
          insetPadding:
              compact
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
                  compact
                      ? MediaQuery.sizeOf(context).height * 0.92
                      : MediaQuery.sizeOf(context).height,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 20 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AsaasHowItWorksDialogHeader(
                    title: l10n.settings_banks_asaas_dialog_title,
                    subtitle: l10n.settings_banks_asaas_dialog_subtitle,
                    onClose: () => Navigator.of(context).pop(),
                    isCompact: compact,
                  ),
                  SizedBox(height: compact ? 20 : 28),
                  const AsaasIntegrationSteps(),
                  const SizedBox(height: 20),
                  const AsaasCapabilitiesSection(),
                  const SizedBox(height: 20),
                  const AsaasSecuritySection(),
                  const SizedBox(height: 28),
                  AsaasHowItWorksDialogActions(
                    onClose: () => Navigator.of(context).pop(),
                    onConnect:
                        onConnectAsaas == null
                            ? null
                            : () {
                              Navigator.of(context).pop();
                              onConnectAsaas?.call();
                            },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
