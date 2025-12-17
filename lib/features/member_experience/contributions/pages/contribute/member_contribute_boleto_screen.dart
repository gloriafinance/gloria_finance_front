import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberContributeBoletoScreen extends StatelessWidget {
  final BoletoChargeResponse boletoPayload;

  const MemberContributeBoletoScreen({
    super.key,
    required this.boletoPayload,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.l10n.member_contribution_boleto_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Value card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      currencyFormat.format(boletoPayload.amount),
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 36,
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.member_contribution_boleto_due_date_label,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontSubTitle,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          dateFormat.format(boletoPayload.dueDate),
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Info text
              Text(
                context.l10n.member_contribution_boleto_instruction,
                style: TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Digitable line
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.member_contribution_boleto_line_label,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        boletoPayload.digitableLine,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: Colors.grey.shade800,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonActionTable(
                        color: AppColors.purple,
                        text: context.l10n.member_contribution_copy_code,
                        icon: Icons.copy,
                        onPressed: () =>
                            _copyToClipboard(context, boletoPayload.digitableLine),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Download PDF button
              CustomButton(
                text: context.l10n.member_contribution_boleto_download_pdf,
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                icon: Icons.download,
                onPressed: () => _downloadPdf(context, boletoPayload.boletoPdfUrl),
              ),
              const SizedBox(height: 24),
              // Footer text
              Text(
                context.l10n.member_contribution_boleto_footer,
                style: TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Back button
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: Text(
                  context.l10n.member_contribution_back_to_home,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: AppColors.purple,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.member_contribution_boleto_copy_success),
        backgroundColor: AppColors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.member_contribution_boleto_pdf_error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
