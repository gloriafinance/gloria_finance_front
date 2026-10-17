import 'package:flutter/material.dart';

import '../../../models/recurring_payment_model.dart';
import 'recurring_payment_card.dart';

/// Tarjetas de recurrencia en una o dos columnas.
///
/// Mobile usa una columna; tablet usa dos, porque la tabla de datos no cabe sin
/// recortar campos y una rejilla de tarjetas mantiene todo visible.
class RecurringPaymentCards extends StatelessWidget {
  const RecurringPaymentCards({
    super.key,
    required this.payments,
    required this.symbolFormatMoney,
    this.columns = 1,
  });

  final List<RecurringPaymentModel> payments;
  final String symbolFormatMoney;
  final int columns;

  static const double _spacing = 16;

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final payment in payments)
            RecurringPaymentCard(
              payment: payment,
              symbolFormatMoney: symbolFormatMoney,
            ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (_spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final payment in payments)
              SizedBox(
                width: itemWidth,
                child: RecurringPaymentCard(
                  payment: payment,
                  symbolFormatMoney: symbolFormatMoney,
                ),
              ),
          ],
        );
      },
    );
  }
}
