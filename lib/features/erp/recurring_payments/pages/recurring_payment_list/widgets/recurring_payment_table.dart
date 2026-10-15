import 'package:flutter/material.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_options_store.dart';
import '../../../utils/recurring_payment_lookup.dart';
import 'recurring_payment_name_cell.dart';
import 'recurring_payment_row_actions.dart';
import 'recurring_payment_type_tag.dart';
import 'recurring_payment_value.dart';

/// Tabla completa de la listado (desktop ≥ 1024 px).
///
/// Nueve columnas no caben en 1440 px sin scroll horizontal, así que el concepto
/// y el centro de costo viajan como segunda línea de la celda del nombre: la
/// información sigue visible y la tabla no se recorta. Tablets agrupa aún más.
class RecurringPaymentTable extends StatelessWidget {
  const RecurringPaymentTable({
    super.key,
    required this.payments,
    required this.symbolFormatMoney,
  });

  final List<RecurringPaymentModel> payments;
  final String symbolFormatMoney;

  @override
  Widget build(BuildContext context) {
    final options = context.watch<RecurringPaymentOptionsStore>().state;
    final concepts = options.expenseConcepts;
    final costCenters = options.costCenters;
    final l10n = context.l10n;

    return CustomTable(
      headers: [
        l10n.recurringPayments_table_name_concept_cost_center,
        l10n.recurringPayments_table_type,
        l10n.recurringPayments_table_amount,
        l10n.recurringPayments_table_due_day,
        l10n.common_status,
        l10n.recurringPayments_table_pix,
      ],
      data: FactoryDataTable<RecurringPaymentModel>(
        data: payments,
        dataBuilder: (item) => _mapToRow(context, item, concepts, costCenters),
      ),
      actionBuilders: [
        (item) =>
            RecurringPaymentRowActions(payment: item as RecurringPaymentModel),
      ],
    );
  }

  List<dynamic> _mapToRow(
    BuildContext context,
    dynamic item,
    List<FinancialConceptModel> concepts,
    List<CostCenterModel> costCenters,
  ) {
    final payment = item as RecurringPaymentModel;
    final l10n = context.l10n;

    return [
      RecurringPaymentNameCell(
        name: payment.name,
        subtitle:
            '${financialConceptName(concepts, payment.financialConceptId)} · '
            '${costCenterName(costCenters, payment.costCenterId)}',
      ),
      RecurringPaymentTypeTag(type: payment.type),
      RecurringPaymentValue(
        payment: payment,
        symbolFormatMoney: symbolFormatMoney,
      ),
      Text(
        l10n.recurringPayments_due_day(payment.dayOfMonth),
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 13.5,
        ),
      ),
      tagStatus(
        payment.status.isActive ? AppColors.green : Colors.red,
        payment.status.friendlyName(l10n),
      ),
      payment.hasPixDestination
          ? tagStatus(AppColors.blue, l10n.recurringPayments_pix_configured)
          : Text(
            l10n.recurringPayments_pix_not_configured,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13,
              color: Color(0xFF838383),
            ),
          ),
    ];
  }
}
