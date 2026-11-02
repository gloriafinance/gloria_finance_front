import 'package:flutter/material.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_list_store.dart';
import 'recurring_payment_cards.dart';
import 'recurring_payment_empty_state.dart';
import 'recurring_payment_no_results_state.dart';
import 'recurring_payment_table.dart';

/// Decide qué muestra el listado en el estado y el tamaño de pantalla actuales.
///
/// - Desktop (≥ 1024): tabla con todas las columnas.
/// - Tablet (768–1023): rejilla de dos columnas de tarjetas.
/// - Mobile (< 768): una columna de tarjetas, sin scroll horizontal.
class RecurringPaymentListBody extends StatelessWidget {
  const RecurringPaymentListBody({super.key, required this.symbolFormatMoney});

  final String symbolFormatMoney;

  static const double _desktopBreakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecurringPaymentListStore>().state;

    if (state.isLoading && !state.hasPayments) {
      return const Loading();
    }

    if (state.isEmpty) {
      return const RecurringPaymentEmptyState();
    }

    if (state.isFilteredWithoutResults) {
      return const RecurringPaymentNoResultsState();
    }

    final payments = state.visiblePayments;
    final isDesktop = MediaQuery.of(context).size.width >= _desktopBreakpoint;

    if (isDesktop) {
      return RecurringPaymentTable(
        payments: payments,
        symbolFormatMoney: symbolFormatMoney,
      );
    }

    return RecurringPaymentCards(
      payments: payments,
      symbolFormatMoney: symbolFormatMoney,
      columns: isMobile(context) ? 1 : 2,
    );
  }
}
