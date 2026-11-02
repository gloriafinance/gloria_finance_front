import 'package:flutter/material.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_competence_model.dart';
import '../../../models/recurring_payment_competence_status.dart';
import '../../../store/recurring_payment_options_store.dart';
import '../../../utils/recurring_payment_lookup.dart';
import '../../recurring_payment_list/widgets/recurring_payment_name_cell.dart';
import '../../recurring_payment_list/widgets/recurring_payment_type_tag.dart';
import '../../recurring_payment_list/widgets/recurring_payment_value.dart';
import 'recurring_payment_monthly_actions.dart';
import 'recurring_payment_status_chip.dart';

/// Vista do mês em tabela (desktop ≥ 1024 px).
///
/// Cinco colunas cabem sem recorte, então o conceito e o centro de custo viajam
/// como segunda linha do nome, igual à listagem de configuração.
class RecurringPaymentMonthlyTable extends StatelessWidget {
  const RecurringPaymentMonthlyTable({
    super.key,
    required this.items,
    required this.symbolFormatMoney,
    required this.hasBanking,
  });

  final List<RecurringPaymentCompetenceModel> items;
  final String symbolFormatMoney;
  final bool hasBanking;

  @override
  Widget build(BuildContext context) {
    final options = context.watch<RecurringPaymentOptionsStore>().state;
    final l10n = context.l10n;

    return CustomTable(
      headers: [
        l10n.recurringPayments_table_name_concept_cost_center,
        l10n.recurringPaymentsExecution_due_date_label,
        l10n.recurringPayments_table_amount,
        l10n.common_status,
      ],
      data: FactoryDataTable<RecurringPaymentCompetenceModel>(
        data: items,
        dataBuilder:
            (item) => _mapToRow(
              context,
              item,
              options.expenseConcepts,
              options.costCenters,
            ),
      ),
      actionBuilders: [
        (item) => RecurringPaymentMonthlyActions(
          item: item as RecurringPaymentCompetenceModel,
          hasBanking: hasBanking,
        ),
      ],
    );
  }

  List<dynamic> _mapToRow(
    BuildContext context,
    dynamic item,
    List<FinancialConceptModel> concepts,
    List<CostCenterModel> costCenters,
  ) {
    final entry = item as RecurringPaymentCompetenceModel;
    final payment = entry.recurringPayment;
    final l10n = context.l10n;
    final dueDate = entry.dueDate;

    return [
      RecurringPaymentNameCell(
        name: payment.name,
        subtitle:
            '${financialConceptName(concepts, payment.financialConceptId)} · '
            '${costCenterName(costCenters, payment.costCenterId)}',
      ),
      Text(
        '${dueDate.day.toString().padLeft(2, '0')}/'
        '${dueDate.month.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 13),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RecurringPaymentTypeTag(type: payment.type),
          const SizedBox(width: 8),
          RecurringPaymentValue(
            payment: payment,
            symbolFormatMoney: symbolFormatMoney,
          ),
        ],
      ),
      RecurringPaymentStatusChip(
        status: entry.status,
        executionStatus: entry.execution?.status,
        label:
            entry.status?.friendlyName(l10n) ??
            l10n.recurringPaymentsExecution_status_unknown,
      ),
    ];
  }
}
