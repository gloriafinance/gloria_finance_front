import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/trends/models/trend_model.dart';
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
    final l10n = context.l10n;

    String _formatMonthYear(int month, int year) {
      final mm = month.toString().padLeft(2, '0');
      return '$mm/$year';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.trends_header_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
          ),
        ),
        if (period != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              l10n.trends_header_comparison(
                _formatMonthYear(period!.month, period!.year),
                _formatMonthYear(previousMonth, previousYear),
              ),
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
