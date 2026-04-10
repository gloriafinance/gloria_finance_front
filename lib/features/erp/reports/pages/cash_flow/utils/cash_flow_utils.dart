import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cash_flow_filter_model.dart';

CashFlowGroupBy suggestCashFlowGroupBy(DateTime startDate, DateTime endDate) {
  final normalizedStart = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
  );
  final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
  final diffDays = normalizedEnd.difference(normalizedStart).inDays + 1;

  if (diffDays <= 45) {
    return CashFlowGroupBy.day;
  }

  if (diffDays <= 180) {
    return CashFlowGroupBy.week;
  }

  return CashFlowGroupBy.month;
}

String cashFlowApiDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String cashFlowDisplayDate(DateTime date, {String? locale}) {
  return DateFormat('dd/MM/yyyy', locale).format(date);
}

String cashFlowDateTime(DateTime date, {String? locale}) {
  return DateFormat('dd/MM/yyyy HH:mm', locale).format(date);
}

String formatCashFlowPeriodLabel(
  DateTime period,
  CashFlowGroupBy groupBy, {
  required String locale,
  DateTime? bucketEnd,
}) {
  switch (groupBy) {
    case CashFlowGroupBy.day:
      return DateFormat('dd/MM', locale).format(period);
    case CashFlowGroupBy.week:
      final end = bucketEnd ?? period.add(const Duration(days: 6));
      return '${DateFormat('dd/MM', locale).format(period)} - ${DateFormat('dd/MM', locale).format(end)}';
    case CashFlowGroupBy.month:
      return DateFormat('MMM yyyy', locale).format(period);
  }
}

DateTime _endOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0);
}

DateTimeRange resolveCashFlowBucketRange({
  required DateTime period,
  required CashFlowGroupBy groupBy,
  required DateTime minDate,
  required DateTime maxDate,
}) {
  DateTime start = DateTime(period.year, period.month, period.day);
  DateTime end = start;

  switch (groupBy) {
    case CashFlowGroupBy.day:
      end = start;
      break;
    case CashFlowGroupBy.week:
      end = start.add(const Duration(days: 6));
      break;
    case CashFlowGroupBy.month:
      start = DateTime(period.year, period.month, 1);
      end = _endOfMonth(period);
      break;
  }

  final safeMin = DateTime(minDate.year, minDate.month, minDate.day);
  final safeMax = DateTime(maxDate.year, maxDate.month, maxDate.day);

  if (start.isBefore(safeMin)) {
    start = safeMin;
  }
  if (end.isAfter(safeMax)) {
    end = safeMax;
  }

  return DateTimeRange(start: start, end: end);
}
