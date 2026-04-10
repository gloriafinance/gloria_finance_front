import 'package:flutter/material.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/formatter.dart';

import '../../../../../../core/widgets/button_acton_table.dart';
import '../models/cash_flow_filter_model.dart';
import '../models/cash_flow_model.dart';
import '../utils/cash_flow_utils.dart';

class CashFlowSeriesTable extends StatelessWidget {
  final List<CashFlowSeriesRowModel> series;
  final CashFlowGroupBy groupBy;
  final DateTime reportEndDate;
  final Future<void> Function(CashFlowSeriesRowModel row) onViewDetails;

  const CashFlowSeriesTable({
    super.key,
    required this.series,
    required this.groupBy,
    required this.reportEndDate,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.reports_cash_flow_table_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        Text(
          context.l10n.reports_cash_flow_table_subtitle,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        CustomTable(
          headers: [
            context.l10n.common_period,
            context.l10n.reports_cash_flow_kpi_entries,
            context.l10n.reports_cash_flow_kpi_exits,
            context.l10n.reports_cash_flow_kpi_net,
            context.l10n.reports_cash_flow_kpi_running_balance,
          ],
          data: FactoryDataTable<CashFlowSeriesRowModel>(
            data: series,
            dataBuilder: (item) {
              final row = item as CashFlowSeriesRowModel;
              final bucketEnd =
                  groupBy == CashFlowGroupBy.week
                      ? resolveCashFlowBucketRange(
                        period: row.period,
                        groupBy: groupBy,
                        minDate: row.period,
                        maxDate: reportEndDate,
                      ).end
                      : null;

              return [
                formatCashFlowPeriodLabel(
                  row.period,
                  groupBy,
                  locale: locale,
                  bucketEnd: bucketEnd,
                ),
                _AmountText(value: row.entries, color: AppColors.green),
                _AmountText(value: row.exits, color: const Color(0xFFD62839)),
                _AmountText(
                  value: row.net,
                  color:
                      row.net >= 0 ? AppColors.green : const Color(0xFFD62839),
                ),
                _AmountText(value: row.runningBalance, color: AppColors.blue),
              ];
            },
          ),
          actionBuilders: [
            (item) => ButtonActionTable(
              color: AppColors.blue,
              text: context.l10n.reports_cash_flow_details_action,
              icon: Icons.visibility_outlined,
              onPressed: () => onViewDetails(item as CashFlowSeriesRowModel),
            ),
          ],
          dataRowMinHeight: 40,
          dataRowMaxHeight: 56,
        ),
      ],
    );
  }
}

class CashFlowProjectionTable extends StatelessWidget {
  final CashFlowProjectionModel projection;
  final CashFlowGroupBy groupBy;

  const CashFlowProjectionTable({
    super.key,
    required this.projection,
    required this.groupBy,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          projection.label,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.reports_cash_flow_projection_disclaimer,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        if (projection.message != null) ...[
          const SizedBox(height: 16),
          _ProjectionStatusBanner(message: projection.message!),
        ],
        if (!projection.hasBuckets) ...[
          const SizedBox(height: 16),
          Text(
            context.l10n.reports_cash_flow_projection_empty,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.black54,
            ),
          ),
        ] else
          CustomTable(
            headers: [
              context.l10n.common_period,
              context.l10n.reports_cash_flow_projection_entries,
              context.l10n.reports_cash_flow_projection_exits,
              context.l10n.reports_cash_flow_projection_net,
              context.l10n.reports_cash_flow_projection_balance,
            ],
            data: FactoryDataTable<CashFlowProjectionBucketModel>(
              data: projection.buckets,
              dataBuilder: (item) {
                final row = item as CashFlowProjectionBucketModel;
                return [
                  formatCashFlowPeriodLabel(
                    row.period,
                    groupBy,
                    locale: locale,
                  ),
                  _AmountText(
                    value: row.projectedEntries,
                    color: AppColors.green,
                  ),
                  _AmountText(
                    value: row.projectedExits,
                    color: const Color(0xFFD62839),
                  ),
                  _AmountText(
                    value: row.projectedNet,
                    color:
                        row.projectedNet >= 0
                            ? AppColors.green
                            : const Color(0xFFD62839),
                  ),
                  _AmountText(
                    value: row.projectedBalance,
                    color: AppColors.blue,
                  ),
                ];
              },
            ),
            dataRowMinHeight: 40,
            dataRowMaxHeight: 56,
          ),
      ],
    );
  }
}

class _AmountText extends StatelessWidget {
  final double value;
  final Color color;

  const _AmountText({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatCurrency(value),
      style: TextStyle(fontFamily: AppFonts.fontSubTitle, color: color),
    );
  }
}

class _ProjectionStatusBanner extends StatelessWidget {
  final String message;

  const _ProjectionStatusBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black87,
        ),
      ),
    );
  }
}
