import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/trends/models/trend_model.dart';
import 'package:flutter/material.dart';

class TrendHeader extends StatelessWidget {
  final TrendPeriod? period;
  final int previousMonth;
  final int previousYear;

  const TrendHeader({
    super.key,
    required this.period,
    required this.previousMonth,
    required this.previousYear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Composição de Receitas, Despesas e Resultado',
          style: TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 18),
        ),
        if (period != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              'Comparativo: ${period!.month.toString().padLeft(2, '0')}/${period!.year} vs ${previousMonth.toString().padLeft(2, '0')}/$previousYear',
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
