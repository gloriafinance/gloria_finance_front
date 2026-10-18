import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_competence_model.dart';
import '../../../models/recurring_payment_competence_status.dart';
import '../../../store/recurring_payment_options_store.dart';
import '../../../utils/recurring_payment_lookup.dart';
import '../../recurring_payment_list/widgets/recurring_payment_value.dart';
import 'recurring_payment_monthly_actions.dart';
import 'recurring_payment_status_chip.dart';

/// Compromisso do mês em tarjeta (tablet e mobile).
///
/// Ordem pensada para o tesoureiro: o que é, quando vence e de que centro de
/// custo, quanto, em que estado e a ação.
class RecurringPaymentMonthlyCard extends StatelessWidget {
  const RecurringPaymentMonthlyCard({
    super.key,
    required this.item,
    required this.symbolFormatMoney,
    required this.hasBanking,
  });

  final RecurringPaymentCompetenceModel item;
  final String symbolFormatMoney;
  final bool hasBanking;

  @override
  Widget build(BuildContext context) {
    final options = context.watch<RecurringPaymentOptionsStore>().state;
    final payment = item.recurringPayment;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  payment.name,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RecurringPaymentStatusChip(
                status: item.status,
                executionStatus: item.execution?.status,
                label:
                    item.status?.friendlyName(l10n) ??
                    l10n.recurringPaymentsExecution_status_unknown,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${item.month.dueDayLabel(item.dueDate)} · '
            '${costCenterName(options.costCenters, payment.costCenterId)}',
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 12.5,
              color: Color(0xFF5F5F5F),
            ),
          ),
          const SizedBox(height: 12),
          RecurringPaymentValue(
            payment: payment,
            symbolFormatMoney: symbolFormatMoney,
          ),
          if (item.isPaidButInactive) ...[
            const SizedBox(height: 8),
            Text(
              l10n.recurringPaymentsExecution_paid_inactive_note,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 11.5,
                height: 1.5,
                color: AppColors.grey,
              ),
            ),
          ],
          const SizedBox(height: 14),
          RecurringPaymentMonthlyActions(
            item: item,
            hasBanking: hasBanking,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
