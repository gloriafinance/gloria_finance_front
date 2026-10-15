import 'package:flutter/material.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_list_store.dart';

/// Activa o desactiva una recurrencia e informa el resultado.
///
/// Vive fuera de los widgets porque la misma acción se dispara desde la tabla (desktop),
/// la tabla compacta (tablet) y la tarjeta (mobile).
Future<void> toggleRecurringPaymentStatus(
  BuildContext context,
  RecurringPaymentModel payment,
) async {
  final l10n = context.l10n;
  final store = context.read<RecurringPaymentListStore>();
  final willActivate = !payment.status.isActive;

  final success = await store.toggleStatus(payment);

  if (!context.mounted) return;

  if (!success) return;

  Toast.showMessage(
    willActivate
        ? l10n.recurringPayments_toast_activated
        : l10n.recurringPayments_toast_deactivated,
    ToastType.info,
  );
}
