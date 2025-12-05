import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:church_finance_bk/core/utils/date_formatter.dart';
import 'package:church_finance_bk/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:flutter/material.dart';

class MemberCommitmentSummaryCard extends StatelessWidget {
  final MemberCommitmentModel commitment;

  const MemberCommitmentSummaryCard({super.key, required this.commitment});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalInstallments = commitment.installments.length;
    final paidInstallments =
        commitment.installments.where((element) => element.isPaid).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  commitment.description,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _StatusTag(status: commitment.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.member_commitments_installments_section_title}: $paidInstallments / $totalInstallments',
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: l10n.member_commitments_total_label,
            value: CurrencyFormatter.formatCurrency(commitment.amountTotal),
          ),
          _SummaryRow(
            label: l10n.member_commitments_paid_label,
            value: CurrencyFormatter.formatCurrency(commitment.amountPaid),
          ),
          _SummaryRow(
            label: l10n.member_commitments_balance_label,
            value: CurrencyFormatter.formatCurrency(commitment.amountPending),
            valueColor: AppColors.purple,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: commitment.progress,
              minHeight: 10,
              color: AppColors.purple,
              backgroundColor: AppColors.purple.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberCommitmentNextInstallmentCard extends StatelessWidget {
  final MemberCommitmentModel commitment;
  final ValueChanged<MemberCommitmentInstallment> onPayInstallment;

  const MemberCommitmentNextInstallmentCard({
    super.key,
    required this.commitment,
    required this.onPayInstallment,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final nextInstallment = commitment.nextInstallment;
    if (nextInstallment == null) return const SizedBox.shrink();

    final installmentIndex =
        commitment.installments.indexWhere(
          (element) => element.installmentId == nextInstallment.installmentId,
        ) +
        1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.member_commitments_detail_next_installment,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${l10n.member_commitments_payment_installment_label} $installmentIndex / ${commitment.installments.length}',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.member_commitments_payment_paid_at_label}: ${formatDateToDDMMYYYY(nextInstallment.dueDate)}',
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.member_commitments_payment_amount_label}: ${CurrencyFormatter.formatCurrency(nextInstallment.amount)}',
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => onPayInstallment(nextInstallment),
            child: Text(
              l10n.member_commitments_action_pay_this_installment,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final MemberCommitmentStatus status;

  const _StatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label;
    switch (status) {
      case MemberCommitmentStatus.paid:
        label = l10n.member_commitments_status_paid;
        break;
      case MemberCommitmentStatus.pendingAcceptance:
        label = l10n.member_commitments_status_pending_acceptance;
        break;
      case MemberCommitmentStatus.denied:
        label = l10n.member_commitments_status_denied;
        break;
      case MemberCommitmentStatus.pending:
      default:
        label = l10n.member_commitments_status_pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: status.badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
