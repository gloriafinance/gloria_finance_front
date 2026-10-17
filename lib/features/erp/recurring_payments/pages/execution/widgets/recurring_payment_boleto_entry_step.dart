import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

/// Primeira pergunta do boleto: câmera ou digitação.
///
/// As duas formas ficam visíveis e com o mesmo peso, porque só o usuário sabe
/// se tem o boleto em mãos.
class RecurringPaymentBoletoEntryStep extends StatelessWidget {
  const RecurringPaymentBoletoEntryStep({
    super.key,
    required this.onCamera,
    required this.onType,
  });

  final VoidCallback onCamera;
  final VoidCallback onType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.recurringPaymentsExecution_boleto_entry_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        _EntryOption(
          icon: Icons.photo_camera_outlined,
          title: l10n.recurringPaymentsExecution_boleto_camera_action,
          subtitle: l10n.recurringPaymentsExecution_boleto_camera_hint,
          onTap: onCamera,
        ),
        const SizedBox(height: 12),
        _EntryOption(
          icon: Icons.keyboard_alt_outlined,
          title: l10n.recurringPaymentsExecution_boleto_type_action,
          subtitle: l10n.recurringPaymentsExecution_boleto_type_hint,
          onTap: onType,
        ),
      ],
    );
  }
}

class _EntryOption extends StatelessWidget {
  const _EntryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyMiddle),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.purple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
