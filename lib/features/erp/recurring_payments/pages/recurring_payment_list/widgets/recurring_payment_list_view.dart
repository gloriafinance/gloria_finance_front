import 'package:flutter/material.dart';

import 'recurring_payment_filters.dart';
import 'recurring_payment_list_body.dart';
import 'recurring_payment_list_header.dart';
import 'recurring_payment_summary.dart';

/// Composición del módulo de pagos recurrentes.
///
/// Se separa de la pantalla para que no dependa de la sesión y pueda renderizarse
/// en pruebas de widget con el símbolo de moneda inyectado.
class RecurringPaymentListView extends StatelessWidget {
  const RecurringPaymentListView({super.key, required this.symbolFormatMoney});

  final String symbolFormatMoney;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecurringPaymentListHeader(),
        RecurringPaymentSummary(symbolFormatMoney: symbolFormatMoney),
        const RecurringPaymentFilters(),
        RecurringPaymentListBody(symbolFormatMoney: symbolFormatMoney),
      ],
    );
  }
}
