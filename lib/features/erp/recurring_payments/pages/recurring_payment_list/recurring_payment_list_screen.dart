import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:provider/provider.dart';

import '../../store/recurring_payment_list_store.dart';
import '../../store/recurring_payment_options_store.dart';
import 'widgets/recurring_payment_list_view.dart';

/// Entrada de navegación del módulo de pagos recurrentes.
class RecurringPaymentListScreen extends StatefulWidget {
  const RecurringPaymentListScreen({super.key});

  @override
  State<RecurringPaymentListScreen> createState() =>
      _RecurringPaymentListScreenState();
}

class _RecurringPaymentListScreenState
    extends State<RecurringPaymentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<RecurringPaymentListStore>();
      if (!store.state.isLoading && !store.state.hasPayments) {
        store.searchRecurringPayments();
      }

      // La tabla y las tarjetas resuelven el nombre del concepto y del centro de
      // costo con estas opciones.
      final optionsStore = context.read<RecurringPaymentOptionsStore>();
      if (!optionsStore.state.hasExpenseConcepts) {
        optionsStore.searchOptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final symbol =
        context.watch<AuthSessionStore>().state.session.symbolFormatMoney;

    return RecurringPaymentListView(symbolFormatMoney: symbol);
  }
}
