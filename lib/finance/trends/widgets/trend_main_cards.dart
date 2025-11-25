import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/trends/models/trend_model.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:flutter/material.dart';

class TrendMainCards extends StatelessWidget {
  final TrendData trend;
  final Axis direction;

  const TrendMainCards({
    super.key,
    required this.trend,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total expenses as sum of Opex + Transfers + Capex
    final totalExpenses =
        trend.opex.current + trend.transfers.current + trend.capex.current;

    final cards = [
      _buildMainCard(
        'Receita Bruta',
        'RECEITA',
        trend.revenue.current,
        Icons.attach_money,
        const Color(0xFFE8F5E9),
        const Color(0xFF2E7D32),
        direction == Axis.vertical,
      ),
      SizedBox(
        width: direction == Axis.horizontal ? 12 : 0,
        height: direction == Axis.vertical ? 12 : 0,
      ),
      _buildMainCard(
        'Despesas Operacionais',
        'DESPESAS',
        totalExpenses,
        Icons.work,
        const Color(0xFFFFEBEE),
        const Color(0xFFC62828),
        direction == Axis.vertical,
      ),
      SizedBox(
        width: direction == Axis.horizontal ? 12 : 0,
        height: direction == Axis.vertical ? 12 : 0,
      ),
      _buildMainCard(
        'Resultado do Período',
        'RESULTADO',
        trend.netIncome.current,
        Icons.trending_up,
        const Color(0xFFE3F2FD),
        const Color(0xFF1565C0),
        direction == Axis.vertical,
      ),
    ];

    if (direction == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: cards),
      );
    } else {
      return Column(children: cards);
    }
  }

  Widget _buildMainCard(
    String title,
    String subtitle,
    double value,
    IconData icon,
    Color bgColor,
    Color textColor,
    bool isVertical,
  ) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: textColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 10,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              CurrencyFormatter.formatCurrency(value),
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
