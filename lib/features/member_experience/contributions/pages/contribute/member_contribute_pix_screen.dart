import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:intl/intl.dart';

import 'widgets/pix_payment_code_panel.dart';

class MemberContributePixScreen extends StatelessWidget {
  final FinancialConceptPixModel pix;
  final double amount;
  final String description;

  const MemberContributePixScreen({
    super.key,
    required this.pix,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.18)),
          ),
          child: Column(
            children: [
              Text(
                context.l10n.member_contribution_selected_value_label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 13,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(amount),
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 34,
                  color: AppColors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        PixPaymentCodePanel(
          copyPaste: pix.copyPaste,
          codeLabel: context.l10n.member_contribution_pix_code_label,
          copyLabel: context.l10n.member_contribution_copy_code,
          qrHint: context.l10n.member_contribution_pix_qr_hint,
          copiedMessage: context.l10n.member_contribution_pix_copy_success,
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                context.l10n.member_contribution_pix_footer,
                style: TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
