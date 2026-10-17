import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';

import '../../../models/recurring_payment_model.dart';

/// Valor de la recurrencia.
///
/// En `FIXED` muestra el monto; en `VARIABLE` muestra "Valor variável" en vez de
/// un cero engañoso, porque no existe valor permanente en ese tipo.
class RecurringPaymentValue extends StatelessWidget {
  const RecurringPaymentValue({
    super.key,
    required this.payment,
    required this.symbolFormatMoney,
  });

  final RecurringPaymentModel payment;
  final String symbolFormatMoney;

  @override
  Widget build(BuildContext context) {
    final amount = payment.amount;

    // Sin tipo reconocido no se puede afirmar si el valor es fijo o variable.
    if (payment.type == null) {
      return const Text(
        '—',
        style: TextStyle(
          fontFamily: AppFonts.fontText,
          fontSize: 13,
          color: AppColors.grey,
        ),
      );
    }

    if (!payment.isFixed || amount == null) {
      return Text(
        context.l10n.recurringPayments_amount_variable,
        style: const TextStyle(
          fontFamily: AppFonts.fontText,
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: AppColors.grey,
        ),
      );
    }

    return Text(
      CurrencyFormatter.formatCurrency(amount, symbol: symbolFormatMoney),
      style: const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 14),
    );
  }
}
