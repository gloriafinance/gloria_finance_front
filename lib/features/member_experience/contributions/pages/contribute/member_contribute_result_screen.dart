import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MemberContributeResultScreen extends StatelessWidget {
  final bool success;
  final MemberContributionType? type;
  final double? amount;
  final DateTime? paidAt;
  final String? errorMessage;

  const MemberContributeResultScreen({
    super.key,
    required this.success,
    this.type,
    this.amount,
    this.paidAt,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: success ? Colors.white : Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child:
                success
                    ? _buildSuccessContent(context)
                    : _buildErrorContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 60),
        ),
        const SizedBox(height: 32),
        // Title
        const Text(
          'Contribuição realizada\ncom sucesso!',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Subtitle
        Text(
          'Obrigado pela sua generosidade.',
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              if (amount != null) ...[
                Text(
                  currencyFormat.format(amount),
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 28,
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (type != null) ...[
                Text(
                  type!.displayName,
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (paidAt != null) ...[
                Text(
                  'Data: ${dateFormat.format(paidAt!)}',
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Info text
        Text(
          'O seu comprovante será conferido pela tesouraria.',
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Buttons
        CustomButton(
          text: 'Ver histórico',
          backgroundColor: AppColors.purple,
          textColor: Colors.white,
          onPressed: () => context.go('/member/contribute'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/member/dashboard'),
          child: const Text(
            'Voltar ao início',
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.purple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, color: Colors.white, size: 60),
        ),
        const SizedBox(height: 32),
        // Title
        const Text(
          'Não foi possível\nprocessar o pagamento',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Error message
        Text(
          errorMessage ??
              'Verifique os dados do cartão ou tente outro método de pagamento.',
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 15,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Buttons
        CustomButton(
          text: 'Tentar novamente',
          backgroundColor: AppColors.purple,
          textColor: Colors.white,
          onPressed: () => context.go('/member/contribute'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/member/dashboard'),
          child: const Text(
            'Voltar ao início',
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.purple,
            ),
          ),
        ),
      ],
    );
  }
}
