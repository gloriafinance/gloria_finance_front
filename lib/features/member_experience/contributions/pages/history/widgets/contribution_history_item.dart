import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContributionHistoryItem extends StatelessWidget {
  final MemberContributionHistoryModel contribution;

  const ContributionHistoryItem({super.key, required this.contribution});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        contribution.conceptName.isNotEmpty
                            ? contribution.conceptName
                            : (contribution.accountName.isNotEmpty
                                ? contribution.accountName
                                : context
                                    .l10n.member_contribution_history_item_default_title),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      CurrencyFormatter.formatCurrency(contribution.amount),
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat(
                    'dd/MM/yyyy – HH:mm',
                  ).format(contribution.createdAt),
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getPaymentMethod(context),
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (contribution.status) {
      case MemberContributionStatus.PROCESSED:
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case MemberContributionStatus.PENDING_VERIFICATION:
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case MemberContributionStatus.REJECTED:
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case MemberContributionStatus.CANCELED:
        icon = Icons.cancel_outlined;
        color = Colors.grey;
        break;
    }

    return Icon(icon, color: color, size: 28);
  }

  String _getPaymentMethod(BuildContext context) {
    if (contribution.bankTransferReceipt != null) {
      return context.l10n.member_contribution_history_item_receipt_submitted;
    }
    return context.l10n.member_contribution_history_item_default_title;
  }
}
