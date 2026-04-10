import 'package:flutter/material.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
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

List<AvailabilityAccountModel> resolveCashFlowVisibleAccounts({
  required List<AvailabilityAccountModel> accounts,
  required String? accountType,
}) {
  if (accountType == null) {
    return accounts;
  }

  return accounts
      .where((item) => item.accountType == accountType)
      .toList(growable: false);
}

List<String> resolveCashFlowSymbols({
  required List<AvailabilityAccountModel> accounts,
}) {
  final symbols = <String>{};

  for (final account in accounts) {
    if (account.symbol.isNotEmpty) {
      symbols.add(account.symbol);
    }
  }

  return symbols.toList(growable: false)..sort();
}

List<AvailabilityAccountModel> resolveCashFlowAccountsBySymbol({
  required List<AvailabilityAccountModel> accounts,
  required String? symbol,
}) {
  if (symbol == null || symbol.isEmpty) {
    return const [];
  }

  return accounts
      .where((item) => item.symbol == symbol)
      .toList(growable: false);
}

List<String> resolveCashFlowAccountSelection({
  required List<AvailabilityAccountModel> accounts,
  required List<String> selectedIds,
}) {
  if (accounts.isEmpty) {
    return const [];
  }

  final accountIds = accounts.map((item) => item.availabilityAccountId).toSet();
  final filteredSelection = selectedIds
      .where(accountIds.contains)
      .toList(growable: false);

  if (filteredSelection.isNotEmpty) {
    return filteredSelection;
  }

  return accounts
      .map((item) => item.availabilityAccountId)
      .toList(growable: false);
}

AvailabilityAccountModel? resolveCashFlowSelectedAccount({
  required List<AvailabilityAccountModel> accounts,
  required String? accountId,
}) {
  if (accountId == null) {
    return null;
  }

  for (final account in accounts) {
    if (account.availabilityAccountId == accountId) {
      return account;
    }
  }

  return null;
}

String cashFlowAccountsSummary({
  required List<AvailabilityAccountModel> accounts,
  required List<String> selectedIds,
  required String allAccountsLabel,
  required String Function(String count) selectedAccountsLabel,
}) {
  if (accounts.isEmpty) {
    return allAccountsLabel;
  }

  final selectedCount = selectedIds.length;
  if (selectedCount == 0 || selectedCount == accounts.length) {
    return allAccountsLabel;
  }

  if (selectedCount == 1) {
    final selectedAccount = resolveCashFlowSelectedAccount(
      accounts: accounts,
      accountId: selectedIds.first,
    );
    return selectedAccount?.accountName ?? allAccountsLabel;
  }

  return selectedAccountsLabel(selectedCount.toString());
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
