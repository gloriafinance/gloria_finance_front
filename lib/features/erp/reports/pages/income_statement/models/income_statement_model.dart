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
      netIncome: 0,
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
        symbol: 'R\$',
      );
    }

    return AvailabilityAccountInfo(
      availabilityAccountId: json['availabilityAccountId'] ?? '',
      accountName: json['accountName'] ?? '',
      symbol: json['symbol'] ?? 'R\$',
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

class AvailabilityAccountsSnapshot {
  final List<AvailabilityAccountEntry> accounts;
  final double total;
  final double income;
  final double expenses;

  AvailabilityAccountsSnapshot({
    required this.accounts,
    required this.total,
    required this.income,
    required this.expenses,
  });

  factory AvailabilityAccountsSnapshot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AvailabilityAccountsSnapshot.empty();
    }

    return AvailabilityAccountsSnapshot(
      accounts:
          (json['accounts'] as List<dynamic>? ?? [])
              .map(
                (account) => AvailabilityAccountEntry.fromJson(
                  account as Map<String, dynamic>,
                ),
              )
              .toList(),
      total: _toDouble(json['total']),
      income: _toDouble(json['income']),
      expenses: _toDouble(json['expenses']),
    );
  }

  factory AvailabilityAccountsSnapshot.empty() {
    return AvailabilityAccountsSnapshot(
      accounts: [],
      total: 0,
      income: 0,
      expenses: 0,
    );
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

  CostCenterUsage({
    required this.id,
    required this.month,
    required this.year,
    required this.total,
    required this.costCenter,
    required this.churchId,
    required this.lastMove,
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
    );
  }
}

class CostCentersSnapshot {
  final List<CostCenterUsage> costCenters;
  final double total;

  CostCentersSnapshot({required this.costCenters, required this.total});

  factory CostCentersSnapshot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CostCentersSnapshot.empty();
    }

    return CostCentersSnapshot(
      costCenters:
          (json['costCenters'] as List<dynamic>? ?? [])
              .map(
                (costCenter) => CostCenterUsage.fromJson(
                  costCenter as Map<String, dynamic>,
                ),
              )
              .toList(),
      total: _toDouble(json['total']),
    );
  }

  factory CostCentersSnapshot.empty() {
    return CostCentersSnapshot(costCenters: [], total: 0);
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
  final List<IncomeStatementBreakdown> breakdown;
  final IncomeStatementSummary summary;
  final CashFlowSnapshot cashFlowSnapshot;

  IncomeStatementModel({
    required this.period,
    required this.breakdown,
    required this.summary,
    required this.cashFlowSnapshot,
  });

  factory IncomeStatementModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return IncomeStatementModel.empty();
    }

    return IncomeStatementModel(
      period: IncomeStatementPeriod.fromJson(json['period']),
      breakdown:
          (json['breakdown'] as List<dynamic>? ?? [])
              .map(
                (item) => IncomeStatementBreakdown.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      summary: IncomeStatementSummary.fromJson(json['summary']),
      cashFlowSnapshot: CashFlowSnapshot.fromJson(json['cashFlowSnapshot']),
    );
  }

  factory IncomeStatementModel.empty() {
    return IncomeStatementModel(
      period: IncomeStatementPeriod(year: 0, month: 0),
      breakdown: const <IncomeStatementBreakdown>[],
      summary: IncomeStatementSummary.empty(),
      cashFlowSnapshot: CashFlowSnapshot.empty(),
    );
  }
}
