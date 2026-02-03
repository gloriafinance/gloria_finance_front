import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/monthly_tithes_list_store.dart';

class CardsSummaryTithes extends StatelessWidget {
  const CardsSummaryTithes({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MonthlyTithesListStore>();
    final data = store.state.data;
    final totalsBySymbol = {
      for (final item in data.totalsBySymbol) item.symbol: item.total,
    };

    final symbols = data.orderedSymbols.where(
      (item) => totalsBySymbol.containsKey(item),
    );

    if (symbols.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          symbols
              .map(
                (symbol) => _SummaryCard(
                  title: context.l10n.reports_monthly_tithes_total_title,
                  symbol: symbol,
                  total: totalsBySymbol[symbol]!,
                ),
              )
              .toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String symbol;
  final double total;

  const _SummaryCard({
    required this.title,
    required this.symbol,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = total >= 0;
    final amountColor = isPositive ? AppColors.black : const Color(0xFFD62839);

    return Container(
      width: isMobile(context) ? double.infinity : 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title + " " + symbol,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: AppColors.blue,
            ),
          ),

          const SizedBox(height: 14),
          Text(
            _formatCurrency(total, symbol),
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 30,
              color: amountColor,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.l10n.reports_monthly_tithes_tithes_of_tithes,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              color: AppColors.grey,
            ),
          ),
          Text(
            _formatCurrency(total * 0.10, symbol),
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value, String symbol) {
    final formatted = CurrencyFormatter.formatCurrency(
      value.abs(),
      symbol: symbol,
    );
    return value < 0 ? '($formatted)' : formatted;
  }
}
