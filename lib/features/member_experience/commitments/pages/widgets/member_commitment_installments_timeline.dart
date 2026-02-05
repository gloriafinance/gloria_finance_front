import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:flutter/material.dart';

class MemberCommitmentInstallmentsTimeline extends StatelessWidget {
  final MemberCommitmentModel commitment;
  final ValueChanged<MemberCommitmentInstallment> onPayInstallment;

  const MemberCommitmentInstallmentsTimeline({
    super.key,
    required this.commitment,
    required this.onPayInstallment,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
          Text(
            l10n.member_commitments_installments_section_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...commitment.installments.asMap().entries.map(
            (entry) {
              final installment = entry.value;
              final index = entry.key + 1;
              return _InstallmentTile(
                installment: installment,
                index: index,
                total: commitment.installments.length,
                onPayInstallment: onPayInstallment,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InstallmentTile extends StatelessWidget {
  final MemberCommitmentInstallment installment;
  final int index;
  final int total;
  final ValueChanged<MemberCommitmentInstallment> onPayInstallment;

  const _InstallmentTile({
    required this.installment,
    required this.index,
    required this.total,
    required this.onPayInstallment,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statusColor = _statusColor(installment);
    final statusLabel = _statusLabel(context, installment);
    final icon = _statusIcon(installment);
    final isPendingAction = installment.canBePaid;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.member_commitments_payment_installment_label} $index / $total',
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.member_commitments_payment_paid_at_label}: ${formatDateToDDMMYYYY(installment.dueDate)}',
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${l10n.member_commitments_payment_amount_label}: ${CurrencyFormatter.formatCurrency(installment.amount)}',
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (installment.paymentDate != null)
                      Text(
                        l10n.member_commitments_installment_paid_on(
                          formatDateToDDMMYYYY(installment.paymentDate!),
                        ),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontText,
                          color: AppColors.green,
                        ),
                      ),
                  ],
                ),
              ),
              _StatusBadge(label: statusLabel, color: statusColor),
            ],
          ),
          if (isPendingAction) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => onPayInstallment(installment),
                child: Text(
                  l10n.member_commitments_action_pay_installment,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    color: AppColors.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(MemberCommitmentInstallment installment) {
    if (installment.isPaid) return AppColors.green;
    if (_isOverdue(installment)) return Colors.redAccent;
    switch (installment.status) {
      case 'IN_REVIEW':
        return AppColors.mustard;
      case 'PARTIAL_PAYMENT':
        return AppColors.blue;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _statusIcon(MemberCommitmentInstallment installment) {
    if (installment.isPaid) return Icons.check_circle;
    if (_isOverdue(installment)) return Icons.error_outline;
    switch (installment.status) {
      case 'IN_REVIEW':
        return Icons.search;
      case 'PARTIAL_PAYMENT':
        return Icons.timelapse;
      default:
        return Icons.schedule;
    }
  }

  bool _isOverdue(MemberCommitmentInstallment installment) {
    return installment.canBePaid && installment.dueDate.isBefore(DateTime.now());
  }

  String _statusLabel(
    BuildContext context,
    MemberCommitmentInstallment installment,
  ) {
    final l10n = context.l10n;
    if (installment.isPaid) {
      return l10n.member_commitments_installment_status_paid;
    }
    if (_isOverdue(installment)) {
      return l10n.member_commitments_installment_status_overdue;
    }
    switch (installment.status) {
      case 'IN_REVIEW':
        return l10n.member_commitments_installment_status_in_review;
      case 'PARTIAL_PAYMENT':
        return l10n.member_commitments_installment_status_partial;
      default:
        return l10n.member_commitments_installment_status_pending;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
