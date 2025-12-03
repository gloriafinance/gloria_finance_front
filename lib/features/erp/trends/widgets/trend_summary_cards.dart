import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/erp/trends/models/trend_model.dart';
import 'package:church_finance_bk/features/erp/trends/utils/trend_utils.dart';
import 'package:flutter/material.dart';

class TrendSummaryCards extends StatelessWidget {
  final TrendData trend;

  const TrendSummaryCards({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCard(
            l10n.trends_summary_revenue,
            trend.revenue.current,
            trend.revenue.previous,
          ),
          const SizedBox(width: 12),
          _buildCard(
            l10n.trends_summary_opex,
            trend.opex.current,
            trend.opex.previous,
          ),
          const SizedBox(width: 12),
          _buildCard(
            l10n.trends_summary_transfers,
            trend.transfers.current,
            trend.transfers.previous,
          ),
          const SizedBox(width: 12),
          _buildCard(
            l10n.trends_summary_capex,
            trend.capex.current,
            trend.capex.previous,
          ),
          const SizedBox(width: 12),
          _buildCard(
            l10n.trends_summary_net_income,
            trend.netIncome.current,
            trend.netIncome.previous,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String label, double current, double previous) {
    final variation = TrendUtils.getVariation(current, previous);

    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (variation != null)
            Row(
              children: [
                Icon(
                  variation['direction'] == 'up'
                      ? Icons.arrow_upward
                      : variation['direction'] == 'down'
                      ? Icons.arrow_downward
                      : Icons.remove,
                  size: 16,
                  color:
                      variation['direction'] == 'up'
                          ? Colors.green
                          : variation['direction'] == 'down'
                          ? Colors.red
                          : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${variation['pct']!.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        variation['direction'] == 'up'
                            ? Colors.green
                            : variation['direction'] == 'down'
                            ? Colors.red
                            : Colors.grey,
                  ),
                ),
              ],
            )
          else
            const Text(
              '—',
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
