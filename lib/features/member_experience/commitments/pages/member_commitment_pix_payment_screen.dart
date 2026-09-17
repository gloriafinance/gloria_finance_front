import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:gloria_finance/features/member_experience/commitments/store/member_commitment_pix_payment_store.dart';
import 'package:gloria_finance/features/member_experience/contributions/pages/contribute/widgets/pix_payment_code_panel.dart';
import 'package:provider/provider.dart';

class MemberCommitmentPixRouteArgs {
  final MemberCommitmentInstallment installment;
  final int installmentIndex;
  final int totalInstallments;

  const MemberCommitmentPixRouteArgs({
    required this.installment,
    required this.installmentIndex,
    required this.totalInstallments,
  });
}

class MemberCommitmentPixPaymentScreen extends StatelessWidget {
  final MemberCommitmentInstallment installment;
  final int installmentIndex;
  final int totalInstallments;

  const MemberCommitmentPixPaymentScreen({
    super.key,
    required this.installment,
    required this.installmentIndex,
    required this.totalInstallments,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => MemberCommitmentPixPaymentStore(installment)..createPayment(),
      child: Consumer<MemberCommitmentPixPaymentStore>(
        builder: (context, store, _) {
          final l10n = context.l10n;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                l10n.member_commitments_pix_title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.member_commitments_payment_installment_label} $installmentIndex / $totalInstallments',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (store.isLoading) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(
                  l10n.member_commitments_pix_generating,
                  textAlign: TextAlign.center,
                ),
              ] else if (store.status ==
                  MemberCommitmentPixPaymentUiStatus.error) ...[
                Text(
                  l10n.member_commitments_pix_error,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: l10n.member_commitments_pix_retry,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  icon: Icons.refresh,
                  onPressed: store.retry,
                ),
              ] else if (store.payment != null) ...[
                _PaymentContent(store: store),
                const SizedBox(height: 20),
                if (store.status == MemberCommitmentPixPaymentUiStatus.paid)
                  CustomButton(
                    text: l10n.member_commitments_pix_paid,
                    backgroundColor: AppColors.green,
                    textColor: Colors.white,
                    icon: Icons.check,
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                else if (store.status ==
                    MemberCommitmentPixPaymentUiStatus.expired)
                  CustomButton(
                    text: l10n.member_commitments_pix_retry,
                    backgroundColor: AppColors.purple,
                    textColor: Colors.white,
                    icon: Icons.refresh,
                    onPressed: store.retry,
                  )
                else
                  CustomButton(
                    text: l10n.member_commitments_pix_verify,
                    backgroundColor: AppColors.purple,
                    textColor: Colors.white,
                    icon: Icons.refresh,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PaymentContent extends StatelessWidget {
  final MemberCommitmentPixPaymentStore store;

  const _PaymentContent({required this.store});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final payment = store.payment!;
    final copyPaste = payment.copyPaste;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AmountRow(
          l10n.member_commitments_pix_principal_amount,
          payment.principalAmount,
        ),
        _AmountRow(
          l10n.member_commitments_pix_transaction_fee,
          payment.transactionFee,
        ),
        const Divider(),
        _AmountRow(
          l10n.member_commitments_pix_total_amount,
          payment.chargeAmount,
          highlighted: true,
        ),
        if (payment.expirationDate != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.member_commitments_pix_expiration(
              formatDateToDDMMYYYY(payment.expirationDate!),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (copyPaste != null && copyPaste.isNotEmpty) ...[
          const SizedBox(height: 20),
          PixPaymentCodePanel(
            copyPaste: copyPaste,
            codeLabel: l10n.member_commitments_pix_code_label,
            copyLabel: l10n.member_commitments_pix_copy,
            qrHint: l10n.member_contribution_pix_qr_hint,
            copiedMessage: l10n.member_commitments_pix_copy_success,
          ),
        ],
        const SizedBox(height: 16),
        Text(
          switch (store.status) {
            MemberCommitmentPixPaymentUiStatus.paid =>
              l10n.member_commitments_pix_paid,
            MemberCommitmentPixPaymentUiStatus.expired =>
              l10n.member_commitments_pix_expired,
            MemberCommitmentPixPaymentUiStatus.unknown => payment.status,
            _ => l10n.member_commitments_pix_waiting,
          },
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool highlighted;

  const _AmountRow(this.label, this.amount, {this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            CurrencyFormatter.formatCurrency(amount),
            style: TextStyle(
              fontWeight: highlighted ? FontWeight.bold : FontWeight.w500,
              fontSize: highlighted ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
