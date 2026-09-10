import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
            border: Border.all(
              color: AppColors.purple.withValues(alpha: 0.18),
            ),
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
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E5EF)),
          ),
          child: Column(
            children: [
              QrImageView(
                data: pix.copyPaste,
                version: QrVersions.auto,
                size: 230,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 14),
              Text(
                context.l10n.member_contribution_pix_qr_hint,
                style: TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E5EF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.member_contribution_pix_code_label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 16,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  pix.copyPaste,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ButtonActionTable(
                  color: AppColors.purple,
                  text: context.l10n.member_contribution_copy_code,
                  icon: Icons.copy,
                  onPressed: () => _copyToClipboard(context),
                ),
              ),
            ],
          ),
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

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: pix.copyPaste));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.member_contribution_pix_copy_success),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
