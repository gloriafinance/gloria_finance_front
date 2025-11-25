import 'package:church_finance_bk/finance/trends/models/trend_model.dart';
import 'package:church_finance_bk/finance/trends/store/trend_store.dart';
import 'package:church_finance_bk/finance/trends/widgets/trend_header.dart';
import 'package:church_finance_bk/finance/trends/widgets/trend_list.dart';
import 'package:church_finance_bk/finance/trends/widgets/trend_main_cards.dart';
import 'package:church_finance_bk/finance/trends/widgets/trend_summary_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendWidget extends StatelessWidget {
  const TrendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TrendStore>(context);

    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.error != null) {
      return Center(child: Text('Erro: ${store.error}'));
    }

    final trend = store.trendResponse?.trend;

    if (trend == null) {
      return const SizedBox.shrink();
    }

    // Calculate max value for the bars relative width
    final values = [
      trend.revenue.current,
      trend.opex.current,
      trend.transfers.current,
      trend.capex.current,
      trend.netIncome.current,
    ];
    final maxValue = values.reduce((curr, next) => curr > next ? curr : next);
    final period = store.trendResponse?.period;
    final previousMonth =
        period != null ? (period.month == 1 ? 12 : period.month - 1) : 0;
    final previousYear =
        period != null
            ? (period.month == 1 ? period.year - 1 : period.year)
            : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout(
              trend,
              period,
              previousMonth,
              previousYear,
              maxValue,
            );
          } else {
            return _buildMobileLayout(
              trend,
              period,
              previousMonth,
              previousYear,
              maxValue,
            );
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    TrendData trend,
    TrendPeriod? period,
    int previousMonth,
    int previousYear,
    double maxValue,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrendHeader(
                period: period,
                previousMonth: previousMonth,
                previousYear: previousYear,
              ),
              const SizedBox(height: 20),
              TrendSummaryCards(trend: trend),
              Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: TrendList(trend: trend, maxValue: maxValue),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Expanded(
                    flex: 3,
                    child: TrendMainCards(
                      trend: trend,
                      direction: Axis.vertical,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Expanded(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           TrendHeader(
    //             period: period,
    //             previousMonth: previousMonth,
    //             previousYear: previousYear,
    //           ),
    //           const SizedBox(height: 20),
    //           TrendMainCards(trend: trend, direction: Axis.horizontal),
    //           const SizedBox(height: 20),
    //           TrendSummaryCards(trend: trend),
    //           const SizedBox(height: 20),
    //           TrendList(trend: trend, maxValue: maxValue),
    //         ],
    //       ),
    //     ),
    //     const SizedBox(width: 32),
    //   ],
    // );
  }

  Widget _buildMobileLayout(
    TrendData trend,
    TrendPeriod? period,
    int previousMonth,
    int previousYear,
    double maxValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendHeader(
          period: period,
          previousMonth: previousMonth,
          previousYear: previousYear,
        ),
        const SizedBox(height: 20),
        TrendMainCards(trend: trend, direction: Axis.horizontal),
        const SizedBox(height: 20),
        TrendSummaryCards(trend: trend),
        const SizedBox(height: 20),
        TrendList(trend: trend, maxValue: maxValue),
      ],
    );
  }
}
