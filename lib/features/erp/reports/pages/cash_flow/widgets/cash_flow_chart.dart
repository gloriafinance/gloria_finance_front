import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';

import '../models/cash_flow_filter_model.dart';
import '../models/cash_flow_model.dart';
import '../utils/cash_flow_utils.dart';

class CashFlowChart extends StatelessWidget {
  final List<CashFlowSeriesRowModel> series;
  final CashFlowGroupBy groupBy;
  final DateTime rangeEnd;

  const CashFlowChart({
    super.key,
    required this.series,
    required this.groupBy,
    required this.rangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.reports_cash_flow_chart_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.reports_cash_flow_chart_subtitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _LegendItem(
                label: context.l10n.reports_cash_flow_kpi_entries,
                color: const Color(0xFF1B998B),
              ),
              _LegendItem(
                label: context.l10n.reports_cash_flow_kpi_exits,
                color: const Color(0xFFD62839),
              ),
              _LegendItem(
                label: context.l10n.reports_cash_flow_kpi_running_balance,
                color: const Color(0xFF2563EB),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: CustomPaint(
              painter: _CashFlowChartPainter(series: series),
              child: Container(),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: series
                  .map(
                    (item) => SizedBox(
                      width: isMobile(context) ? 54 : 76,
                      child: Text(
                        formatCashFlowPeriodLabel(
                          item.period,
                          groupBy,
                          locale: locale,
                          bucketEnd:
                              groupBy == CashFlowGroupBy.week
                                  ? resolveCashFlowBucketRange(
                                    period: item.period,
                                    groupBy: groupBy,
                                    minDate: item.period,
                                    maxDate: rangeEnd,
                                  ).end
                                  : null,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _CashFlowChartPainter extends CustomPainter {
  final List<CashFlowSeriesRowModel> series;

  _CashFlowChartPainter({required this.series});

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    const paddingLeft = 12.0;
    const paddingRight = 12.0;
    const paddingTop = 16.0;
    const paddingBottom = 12.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;
    final columnWidth = chartWidth / math.max(series.length, 1);
    final barWidth = math.min(12.0, columnWidth / 4);

    final maxFlow = series
        .map((item) => math.max(item.entries, item.exits))
        .fold<double>(0, math.max);
    final balanceValues = series.map((item) => item.runningBalance).toList();
    final minBalance = balanceValues.reduce(math.min);
    final maxBalance = balanceValues.reduce(math.max);
    final safeMaxFlow = maxFlow <= 0 ? 1.0 : maxFlow;
    final balanceRange =
        (maxBalance - minBalance).abs() < 0.0001
            ? 1.0
            : maxBalance - minBalance;

    final gridPaint =
        Paint()
          ..color = const Color(0xFFE5E7EB)
          ..strokeWidth = 1;

    for (var i = 0; i < 4; i++) {
      final y = paddingTop + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
    }

    final entryPaint = Paint()..color = const Color(0xFF1B998B);
    final exitPaint = Paint()..color = const Color(0xFFD62839);
    final linePaint =
        Paint()
          ..color = const Color(0xFF2563EB)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

    final linePath = Path();

    for (var i = 0; i < series.length; i++) {
      final item = series[i];
      final centerX = paddingLeft + (columnWidth * i) + (columnWidth / 2);

      final entryHeight = (item.entries / safeMaxFlow) * (chartHeight * 0.78);
      final exitHeight = (item.exits / safeMaxFlow) * (chartHeight * 0.78);

      final entryRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - barWidth - 2,
          paddingTop + chartHeight - entryHeight,
          barWidth,
          entryHeight,
        ),
        const Radius.circular(6),
      );
      final exitRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX + 2,
          paddingTop + chartHeight - exitHeight,
          barWidth,
          exitHeight,
        ),
        const Radius.circular(6),
      );

      canvas.drawRRect(entryRect, entryPaint);
      canvas.drawRRect(exitRect, exitPaint);

      final normalizedBalance =
          (item.runningBalance - minBalance) / balanceRange;
      final lineY =
          paddingTop + chartHeight - (normalizedBalance * (chartHeight * 0.9));
      final point = Offset(centerX, lineY);

      if (i == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }

      canvas.drawCircle(point, 3.2, Paint()..color = const Color(0xFF2563EB));
    }

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _CashFlowChartPainter oldDelegate) {
    return oldDelegate.series != series;
  }
}
