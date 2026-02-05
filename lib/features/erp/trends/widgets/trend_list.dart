import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/features/erp/trends/models/trend_model.dart';
import 'package:gloria_finance/features/erp/trends/utils/trend_utils.dart';
import 'package:flutter/material.dart';

class TrendList extends StatelessWidget {
  final TrendData trend;
  final double maxValue;

  const TrendList({super.key, required this.trend, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        _buildTrendItem(
          l10n.trends_list_revenue,
          trend.revenue.current,
          trend.revenue.previous,
          maxValue,
          Colors.green,
        ),
        _buildTrendItem(
          l10n.trends_list_opex,
          trend.opex.current,
          trend.opex.previous,
          maxValue,
          Colors.redAccent,
        ),
        _buildTrendItem(
          l10n.trends_list_transfers,
          trend.transfers.current,
          trend.transfers.previous,
          maxValue,
          Colors.orange,
        ),
        _buildTrendItem(
          l10n.trends_list_capex,
          trend.capex.current,
          trend.capex.previous,
          maxValue,
          Colors.amber,
        ),
        _buildTrendItem(
          l10n.trends_list_net_income,
          trend.netIncome.current,
          trend.netIncome.previous,
          maxValue,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildTrendItem(
    String label,
    double value,
    double previousValue,
    double maxValue,
    Color color,
  ) {
    // Avoid division by zero
    final percentage = maxValue == 0 ? 0.0 : (value / maxValue);
    final variation = TrendUtils.getVariation(value, previousValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  if (variation != null) ...[
                    Icon(
                      variation['direction'] == 'up'
                          ? Icons.arrow_upward
                          : variation['direction'] == 'down'
                          ? Icons.arrow_downward
                          : Icons.remove,
                      size: 14,
                      color:
                          variation['direction'] == 'up'
                              ? Colors.green
                              : variation['direction'] == 'down'
                              ? Colors.red
                              : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${variation['pct']!.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 12,
                        color:
                            variation['direction'] == 'up'
                                ? Colors.green
                                : variation['direction'] == 'down'
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        '—',
                        style: TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  Text(
                    CurrencyFormatter.formatCurrency(value),
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage.clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
