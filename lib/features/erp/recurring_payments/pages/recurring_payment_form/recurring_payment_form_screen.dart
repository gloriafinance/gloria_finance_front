import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:provider/provider.dart';

import '../../models/recurring_payment_model.dart';
import 'widgets/recurring_payment_form_view.dart';

/// Entrada de navegación del formulario de configuración.
///
/// Es una página y no un modal: tiene URL propia, sobrevive a un refresh y usa
/// el mismo código para desktop (dos columnas) y mobile (una columna).
class RecurringPaymentFormScreen extends StatelessWidget {
  const RecurringPaymentFormScreen({
    super.key,
    this.recurringPayment,
    this.recurringPaymentId,
  });

  /// Objeto ya cargado cuando se llega desde el listado.
  final RecurringPaymentModel? recurringPayment;

  /// Id usado cuando se entra por URL directa.
  final String? recurringPaymentId;

  @override
  Widget build(BuildContext context) {
    final symbol =
        context.watch<AuthSessionStore>().state.session.symbolFormatMoney;

    return RecurringPaymentFormView(
      symbolFormatMoney: symbol,
      recurringPayment: recurringPayment,
      recurringPaymentId: recurringPaymentId,
    );
  }
}
