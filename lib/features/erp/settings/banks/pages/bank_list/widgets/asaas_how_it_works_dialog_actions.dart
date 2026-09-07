import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

class AsaasHowItWorksDialogActions extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onConnect;

  const AsaasHowItWorksDialogActions({
    super.key,
    required this.onClose,
    this.onConnect,
  });

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
