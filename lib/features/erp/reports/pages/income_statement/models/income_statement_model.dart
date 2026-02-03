import 'package:church_finance_bk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString()) ?? 0;
}

String _toSymbol(dynamic value) {
  final symbol = value?.toString().trim() ?? '';
  return symbol;
}

/// Periodo consolidado del reporte.
class IncomeStatementPeriod {
  final int year;
  final int month;

  IncomeStatementPeriod({required this.year, required this.month});

  factory IncomeStatementPeriod.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return IncomeStatementPeriod(year: 0, month: 0);
    }

    return IncomeStatementPeriod(
      year: _toInt(json['year']),
      month: _toInt(json['month']),
    );
  }
}

enum IncomeStatementCategory {
  revenue,
  cogs,
  opex,
  capex,
  other,
  unknown,
  ministry_transfers,
}

IncomeStatementCategory incomeStatementCategoryFromApi(String? value) {
  switch (value?.toUpperCase()) {
    case 'REVENUE':
      return IncomeStatementCategory.revenue;
    case 'COGS':
      return IncomeStatementCategory.cogs;
    case 'OPEX':
      return IncomeStatementCategory.opex;
    case 'CAPEX':
      return IncomeStatementCategory.capex;
    case 'OTHER':
      return IncomeStatementCategory.other;
    case 'MINISTRY_TRANSFERS':
      return IncomeStatementCategory.ministry_transfers;
    default:
      return IncomeStatementCategory.unknown;
  }
}

extension IncomeStatementCategoryExtension on IncomeStatementCategory {
  String friendlyName(AppLocalizations l10n) {
    switch (this) {
      case IncomeStatementCategory.revenue:
        return l10n.reports_income_category_revenue_title;
      case IncomeStatementCategory.cogs:
        return l10n.reports_income_category_cogs_title;
      case IncomeStatementCategory.opex:
        return l10n.reports_income_category_opex_title;
      case IncomeStatementCategory.capex:
        return l10n.reports_income_category_capex_title;
      case IncomeStatementCategory.other:
        return l10n.reports_income_category_other_title;
      case IncomeStatementCategory.ministry_transfers:
        return l10n.reports_income_category_ministry_transfers_title;
      case IncomeStatementCategory.unknown:
        return l10n.reports_income_category_unknown_title;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case IncomeStatementCategory.revenue:
        return l10n.reports_income_category_revenue_desc;
      case IncomeStatementCategory.cogs:
        return l10n.reports_income_category_cogs_desc;
      case IncomeStatementCategory.opex:
        return l10n.reports_income_category_opex_desc;
      case IncomeStatementCategory.capex:
        return l10n.reports_income_category_capex_desc;
      case IncomeStatementCategory.other:
        return l10n.reports_income_category_other_desc;
      case IncomeStatementCategory.ministry_transfers:
        return l10n.reports_income_category_ministry_transfers_desc;
      case IncomeStatementCategory.unknown:
        return '';
    }
  }

  Color get accentColor {
    switch (this) {
      case IncomeStatementCategory.revenue:
        return const Color(0xFF1B998B);
      case IncomeStatementCategory.cogs:
        return const Color(0xFF8ECAE6);
      case IncomeStatementCategory.opex:
        return const Color(0xFFD62839);
      case IncomeStatementCategory.capex:
        return const Color(0xFFFB8500);
      case IncomeStatementCategory.other:
        return const Color(0xFF6A4C93);
      case IncomeStatementCategory.ministry_transfers:
        return const Color(0xFF2A9D8F);
      case IncomeStatementCategory.unknown:
        return const Color(0xFFADB5BD);
    }
  }
}

class IncomeStatementBreakdown {
  final IncomeStatementCategory category;
  final double income;
  final double expenses;
  final double net;

  IncomeStatementBreakdown({
    required this.category,
    required this.income,
    required this.expenses,
    required this.net,
  });

  factory IncomeStatementBreakdown.fromJson(Map<String, dynamic> json) {
    return IncomeStatementBreakdown(
      category: incomeStatementCategoryFromApi(json['category']),
      income: _toDouble(json['income']),
      expenses: _toDouble(json['expenses']),
      net: _toDouble(json['net']),
    );
  }
}

class IncomeStatementBreakdownBySymbol {
  final String symbol;
  final List<IncomeStatementBreakdown> breakdown;

  IncomeStatementBreakdownBySymbol({
    required this.symbol,
    required this.breakdown,
  });

  factory IncomeStatementBreakdownBySymbol.fromJson(Map<String, dynamic> json) {
    return IncomeStatementBreakdownBySymbol(
      symbol: _toSymbol(json['symbol']),
      breakdown:
          (json['breakdown'] as List<dynamic>? ?? [])
              .map(
                (item) => IncomeStatementBreakdown.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class IncomeStatementSummary {
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double operatingExpenses;
  final double operatingIncome;
  final double capitalExpenditures;
  final double otherIncome;
  final double otherExpenses;
  final double otherNet;
  final double reversalAdjustments;
  final double totalIncome;
  final double totalExpenses;
  final double netIncome;

  IncomeStatementSummary({
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.operatingExpenses,
    required this.operatingIncome,
    required this.capitalExpenditures,
    required this.otherIncome,
    required this.otherExpenses,
    required this.otherNet,
    required this.reversalAdjustments,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netIncome,
  });

  factory IncomeStatementSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return IncomeStatementSummary.empty();
    }

    return IncomeStatementSummary(
      revenue: _toDouble(json['revenue']),
      cogs: _toDouble(json['cogs']),
      grossProfit: _toDouble(json['grossProfit']),
      operatingExpenses: _toDouble(json['operatingExpenses']),
      operatingIncome: _toDouble(json['operatingIncome']),
      capitalExpenditures: _toDouble(json['capitalExpenditures']),
      otherIncome: _toDouble(json['otherIncome']),
      otherExpenses: _toDouble(json['otherExpenses']),
      otherNet: _toDouble(json['otherNet']),
      reversalAdjustments: _toDouble(json['reversalAdjustments']),
      totalIncome: _toDouble(json['totalIncome']),
      totalExpenses: _toDouble(json['totalExpenses']),
      netIncome: _toDouble(json['netIncome']),
    );
  }

  factory IncomeStatementSummary.empty() {
    return IncomeStatementSummary(
      revenue: 0,
      cogs: 0,
      grossProfit: 0,
      operatingExpenses: 0,
      operatingIncome: 0,
      capitalExpenditures: 0,
      otherIncome: 0,
      otherExpenses: 0,
      otherNet: 0,
      reversalAdjustments: 0,
      totalIncome: 0,
      totalExpenses: 0,
      netIncome: 0,
    );
  }
}

class IncomeStatementSummaryBySymbol {
  final String symbol;
  final IncomeStatementSummary summary;

  IncomeStatementSummaryBySymbol({required this.symbol, required this.summary});

  factory IncomeStatementSummaryBySymbol.fromJson(Map<String, dynamic> json) {
    final summaryJson =
        json['summary'] is Map<String, dynamic>
            ? json['summary'] as Map<String, dynamic>
            : json;

    return IncomeStatementSummaryBySymbol(
      symbol: _toSymbol(json['symbol']),
      summary: IncomeStatementSummary.fromJson(summaryJson),
    );
  }
}

class AvailabilityAccountInfo {
  final String availabilityAccountId;
  final String accountName;
  final String symbol;

  AvailabilityAccountInfo({
    required this.availabilityAccountId,
    required this.accountName,
    required this.symbol,
  });

  factory AvailabilityAccountInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AvailabilityAccountInfo(
        availabilityAccountId: '',
        accountName: '',
        symbol: '',
      );
    }

    return AvailabilityAccountInfo(
      availabilityAccountId: json['availabilityAccountId'] ?? '',
      accountName: json['accountName'] ?? '',
      symbol: _toSymbol(json['symbol']),
    );
  }
}

class AvailabilityAccountEntry {
  final int month;
  final int year;
  final double totalOutput;
  final double totalInput;
  final AvailabilityAccountInfo availabilityAccount;
  final String availabilityAccountMasterId;
  final String churchId;

  AvailabilityAccountEntry({
    required this.month,
    required this.year,
    required this.totalOutput,
    required this.totalInput,
    required this.availabilityAccount,
    required this.availabilityAccountMasterId,
    required this.churchId,
  });

  factory AvailabilityAccountEntry.fromJson(Map<String, dynamic> json) {
    return AvailabilityAccountEntry(
      month: _toInt(json['month']),
      year: _toInt(json['year']),
      totalOutput: _toDouble(json['totalOutput']),
      totalInput: _toDouble(json['totalInput']),
      availabilityAccount: AvailabilityAccountInfo.fromJson(
        json['availabilityAccount'],
      ),
      availabilityAccountMasterId: json['availabilityAccountMasterId'] ?? '',
      churchId: json['churchId'] ?? '',
    );
  }

  double get balance => totalInput - totalOutput;
}

class AvailabilityAccountsTotal {
  final String symbol;
  final double total;
  final double income;
  final double expenses;

  AvailabilityAccountsTotal({
    required this.symbol,
    required this.total,
    required this.income,
    required this.expenses,
  });

  factory AvailabilityAccountsTotal.fromJson(Map<String, dynamic> json) {
    return AvailabilityAccountsTotal(
      symbol: _toSymbol(json['symbol']),
      total: _toDouble(json['total']),
      income: _toDouble(json['income']),
      expenses: _toDouble(json['expenses']),
    );
  }
}

class AvailabilityAccountsSnapshot {
  final List<AvailabilityAccountEntry> accounts;
  final List<AvailabilityAccountsTotal> totals;

  AvailabilityAccountsSnapshot({required this.accounts, required this.totals});

  factory AvailabilityAccountsSnapshot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AvailabilityAccountsSnapshot.empty();
    }

    final accounts =
        (json['accounts'] as List<dynamic>? ?? [])
            .map(
              (account) => AvailabilityAccountEntry.fromJson(
                account as Map<String, dynamic>,
              ),
            )
            .toList();

    List<AvailabilityAccountsTotal> totals;
    if (json['totals'] is List<dynamic>) {
      totals =
          (json['totals'] as List<dynamic>)
              .map(
                (item) => AvailabilityAccountsTotal.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
    } else {
      final total = _toDouble(json['total']);
      final income = _toDouble(json['income']);
      final expenses = _toDouble(json['expenses']);
      totals =
          (total != 0 || income != 0 || expenses != 0)
              ? [
                AvailabilityAccountsTotal(
                  symbol:
                      accounts.isNotEmpty
                          ? accounts.first.availabilityAccount.symbol
                          : '',
                  total: total,
                  income: income,
                  expenses: expenses,
                ),
              ]
              : [];
    }

    return AvailabilityAccountsSnapshot(accounts: accounts, totals: totals);
  }

  factory AvailabilityAccountsSnapshot.empty() {
    return AvailabilityAccountsSnapshot(accounts: [], totals: []);
  }
}

class CostCenterInfo {
  final String costCenterId;
  final String costCenterName;

  CostCenterInfo({required this.costCenterId, required this.costCenterName});

  factory CostCenterInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CostCenterInfo(costCenterId: '', costCenterName: '');
    }

    return CostCenterInfo(
      costCenterId: json['costCenterId'] ?? '',
      costCenterName: json['costCenterName'] ?? '',
    );
  }
}

class CostCenterUsage {
  final String id;
  final int month;
  final int year;
  final double total;
  final CostCenterInfo costCenter;
  final String churchId;
  final DateTime? lastMove;
  final String symbol;

  CostCenterUsage({
    required this.id,
    required this.month,
    required this.year,
    required this.total,
    required this.costCenter,
    required this.churchId,
    required this.lastMove,
    required this.symbol,
  });

  factory CostCenterUsage.fromJson(Map<String, dynamic> json) {
    return CostCenterUsage(
      id: json['id'] ?? '',
      month: _toInt(json['month']),
      year: _toInt(json['year']),
      total: _toDouble(json['total']),
      costCenter: CostCenterInfo.fromJson(json['costCenter']),
      churchId: json['churchId'] ?? '',
      lastMove:
          json['lastMove'] != null ? DateTime.tryParse(json['lastMove']) : null,
      symbol: _toSymbol(json['symbol']),
    );
  }
}

class CostCentersTotal {
  final String symbol;
  final double total;

  CostCentersTotal({required this.symbol, required this.total});

  factory CostCentersTotal.fromJson(Map<String, dynamic> json) {
    return CostCentersTotal(
      symbol: _toSymbol(json['symbol']),
      total: _toDouble(json['total']),
    );
  }
}

class CostCentersSnapshot {
  final List<CostCenterUsage> costCenters;
  final List<CostCentersTotal> totals;

  CostCentersSnapshot({required this.costCenters, required this.totals});

  factory CostCentersSnapshot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CostCentersSnapshot.empty();
    }

    final costCenters =
        (json['costCenters'] as List<dynamic>? ?? [])
            .map(
              (item) => CostCenterUsage.fromJson(item as Map<String, dynamic>),
            )
            .toList();

    List<CostCentersTotal> totals;
    if (json['totals'] is List<dynamic>) {
      totals =
          (json['totals'] as List<dynamic>)
              .map(
                (item) =>
                    CostCentersTotal.fromJson(item as Map<String, dynamic>),
              )
              .toList();
    } else {
      final total = _toDouble(json['total']);
      totals =
          total != 0
              ? [
                CostCentersTotal(
                  symbol:
                      costCenters.isNotEmpty ? costCenters.first.symbol : '',
                  total: total,
                ),
              ]
              : [];
    }

    return CostCentersSnapshot(costCenters: costCenters, totals: totals);
  }

  factory CostCentersSnapshot.empty() {
    return CostCentersSnapshot(costCenters: [], totals: []);
  }
}

class CashFlowSnapshot {
  final AvailabilityAccountsSnapshot availabilityAccounts;
  final CostCentersSnapshot costCenters;

  CashFlowSnapshot({
    required this.availabilityAccounts,
    required this.costCenters,
  });

  factory CashFlowSnapshot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CashFlowSnapshot.empty();
    }

    return CashFlowSnapshot(
      availabilityAccounts: AvailabilityAccountsSnapshot.fromJson(
        json['availabilityAccounts'],
      ),
      costCenters: CostCentersSnapshot.fromJson(json['costCenters']),
    );
  }

  factory CashFlowSnapshot.empty() {
    return CashFlowSnapshot(
      availabilityAccounts: AvailabilityAccountsSnapshot.empty(),
      costCenters: CostCentersSnapshot.empty(),
    );
  }
}

class IncomeStatementModel {
  final IncomeStatementPeriod period;
  final List<IncomeStatementSummaryBySymbol> summaries;
  final List<IncomeStatementBreakdownBySymbol> breakdownSections;
  final CashFlowSnapshot cashFlowSnapshot;

  IncomeStatementModel({
    required this.period,
    required this.summaries,
    required this.breakdownSections,
    required this.cashFlowSnapshot,
  });

  factory IncomeStatementModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return IncomeStatementModel.empty();
    }

    final rawSummary = json['summary'];
    final summaries =
        rawSummary is List<dynamic>
            ? rawSummary
                .map(
                  (item) => IncomeStatementSummaryBySymbol.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
            : rawSummary is Map<String, dynamic>
            ? [IncomeStatementSummaryBySymbol.fromJson(rawSummary)]
            : <IncomeStatementSummaryBySymbol>[];

    final rawBreakdown = json['breakdown'];
    final breakdownSections =
        rawBreakdown is List<dynamic> &&
                rawBreakdown.isNotEmpty &&
                rawBreakdown.first is Map<String, dynamic> &&
                (rawBreakdown.first as Map<String, dynamic>).containsKey(
                  'breakdown',
                )
            ? rawBreakdown
                .map(
                  (item) => IncomeStatementBreakdownBySymbol.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
            : rawBreakdown is List<dynamic>
            ? [
              IncomeStatementBreakdownBySymbol(
                symbol: summaries.isNotEmpty ? summaries.first.symbol : '',
                breakdown:
                    rawBreakdown
                        .map(
                          (item) => IncomeStatementBreakdown.fromJson(
                            item as Map<String, dynamic>,
                          ),
                        )
                        .toList(),
              ),
            ]
            : <IncomeStatementBreakdownBySymbol>[];

    return IncomeStatementModel(
      period: IncomeStatementPeriod.fromJson(json['period']),
      summaries: summaries,
      breakdownSections: breakdownSections,
      cashFlowSnapshot: CashFlowSnapshot.fromJson(json['cashFlowSnapshot']),
    );
  }

  factory IncomeStatementModel.empty() {
    return IncomeStatementModel(
      period: IncomeStatementPeriod(year: 0, month: 0),
      summaries: const <IncomeStatementSummaryBySymbol>[],
      breakdownSections: const <IncomeStatementBreakdownBySymbol>[],
      cashFlowSnapshot: CashFlowSnapshot.empty(),
    );
  }

  bool get hasSummary => summaries.isNotEmpty;

  Set<String> get currencySymbols {
    final symbols = <String>{};
    symbols.addAll(summaries.map((item) => item.symbol));
    symbols.addAll(breakdownSections.map((item) => item.symbol));
    symbols.addAll(
      cashFlowSnapshot.availabilityAccounts.totals.map((item) => item.symbol),
    );
    symbols.addAll(
      cashFlowSnapshot.costCenters.totals.map((item) => item.symbol),
    );
    symbols.addAll(
      cashFlowSnapshot.availabilityAccounts.accounts.map(
        (item) => item.availabilityAccount.symbol,
      ),
    );
    symbols.addAll(
      cashFlowSnapshot.costCenters.costCenters.map((item) => item.symbol),
    );
    return symbols.where((symbol) => symbol.trim().isNotEmpty).toSet();
  }

  int get currencyCount => currencySymbols.length;

  List<String> get orderedSymbols {
    final summarySymbols = [...summaries]..sort((a, b) {
      final compareIncome = b.summary.totalIncome.compareTo(
        a.summary.totalIncome,
      );
      if (compareIncome != 0) {
        return compareIncome;
      }
      return a.symbol.compareTo(b.symbol);
    });

    final ordered = summarySymbols.map((item) => item.symbol).toList();
    final remaining =
        currencySymbols.where((item) => !ordered.contains(item)).toList()
          ..sort();
    ordered.addAll(remaining);
    return ordered;
  }

  Map<String, IncomeStatementSummary> get summariesBySymbol {
    return {for (final item in summaries) item.symbol: item.summary};
  }

  Map<String, List<IncomeStatementBreakdown>> get breakdownBySymbol {
    return {for (final item in breakdownSections) item.symbol: item.breakdown};
  }

  Map<String, List<AvailabilityAccountEntry>> get availabilityAccountsGrouped {
    final grouped = <String, List<AvailabilityAccountEntry>>{};
    for (final account in cashFlowSnapshot.availabilityAccounts.accounts) {
      grouped.putIfAbsent(account.availabilityAccount.symbol, () => []);
      grouped[account.availabilityAccount.symbol]!.add(account);
    }
    return grouped;
  }

  Map<String, AvailabilityAccountsTotal> get availabilityTotalsBySymbol {
    return {
      for (final item in cashFlowSnapshot.availabilityAccounts.totals)
        item.symbol: item,
    };
  }

  Map<String, List<CostCenterUsage>> get costCentersGrouped {
    final grouped = <String, List<CostCenterUsage>>{};
    for (final costCenter in cashFlowSnapshot.costCenters.costCenters) {
      grouped.putIfAbsent(costCenter.symbol, () => []);
      grouped[costCenter.symbol]!.add(costCenter);
    }
    return grouped;
  }

  Map<String, CostCentersTotal> get costCenterTotalsBySymbol {
    return {
      for (final item in cashFlowSnapshot.costCenters.totals) item.symbol: item,
    };
  }
}
