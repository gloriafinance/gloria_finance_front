import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:flutter/material.dart';

class MemberCommitmentCard extends StatelessWidget {
  final MemberCommitmentModel commitment;
  final VoidCallback? onTap;

  const MemberCommitmentCard({super.key, required this.commitment, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  commitment.description,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _StatusChip(status: commitment.status),
            ],
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: l10n.member_commitments_total_label,
            value: CurrencyFormatter.formatCurrency(commitment.amountTotal),
          ),
          const SizedBox(height: 4),
          _MetricRow(
            label: l10n.member_commitments_paid_label,
            value: CurrencyFormatter.formatCurrency(commitment.amountPaid),
          ),
          const SizedBox(height: 4),
          _MetricRow(
            label: l10n.member_commitments_balance_label,
            value: CurrencyFormatter.formatCurrency(commitment.amountPending),
            valueColor: AppColors.purple,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: commitment.progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
            color: AppColors.purple,
            backgroundColor: AppColors.purple.withAlpha(40),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(commitment.progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ButtonActionTable(
              color: AppColors.purple,
              text: l10n.member_commitments_button_view_details,
              icon: Icons.visibility_outlined,
              onPressed: onTap ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _StatusChip extends StatelessWidget {
  final MemberCommitmentStatus status;

  const _StatusChip({required this.status});

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
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.badgeColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: status.badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
