import 'package:flutter/material.dart';

import '../../../models/recurring_payment_competence_model.dart';
import 'recurring_payment_monthly_card.dart';

/// Tarjetas do mês em uma ou duas colunas.
///
/// Mobile usa uma coluna; tablet usa duas. A tabela de dados fica reservada para
/// desktop, onde há largura para ela.
class RecurringPaymentMonthlyCards extends StatelessWidget {
  const RecurringPaymentMonthlyCards({
    super.key,
    required this.items,
    required this.symbolFormatMoney,
    required this.hasBanking,
    this.columns = 1,
  });

  final List<RecurringPaymentCompetenceModel> items;
  final String symbolFormatMoney;
  final bool hasBanking;
  final int columns;

  static const double _spacing = 16;

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            RecurringPaymentMonthlyCard(
              item: item,
              symbolFormatMoney: symbolFormatMoney,
              hasBanking: hasBanking,
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
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: RecurringPaymentMonthlyCard(
                  item: item,
                  symbolFormatMoney: symbolFormatMoney,
                  hasBanking: hasBanking,
                ),
              ),
          ],
        );
      },
    );
  }
}
