import 'package:gloria_finance/l10n/app_localizations.dart';

import '../utils/cash_flow_utils.dart';

enum CashFlowGroupBy { day, week, month }

extension CashFlowGroupByX on CashFlowGroupBy {
  String get apiValue {
    switch (this) {
      case CashFlowGroupBy.day:
        return 'day';
      case CashFlowGroupBy.week:
        return 'week';
      case CashFlowGroupBy.month:
        return 'month';
    }
  }

  String friendlyName(AppLocalizations l10n) {
    switch (this) {
      case CashFlowGroupBy.day:
        return l10n.reports_cash_flow_group_day;
      case CashFlowGroupBy.week:
        return l10n.reports_cash_flow_group_week;
      case CashFlowGroupBy.month:
        return l10n.reports_cash_flow_group_month;
    }
  }

  static CashFlowGroupBy fromApiValue(String? value) {
    switch (value) {
      case 'week':
        return CashFlowGroupBy.week;
      case 'month':
        return CashFlowGroupBy.month;
      case 'day':
      default:
        return CashFlowGroupBy.day;
    }
  }
}

class CashFlowFilterModel {
  final String churchId;
  final DateTime startDate;
  final DateTime endDate;
  final CashFlowGroupBy groupBy;
  final String? symbol;
  final List<String> availabilityAccountIds;
  final String? costCenterId;
  final String? method;
  final bool includeProjection;
  final int projectionBuckets;

  const CashFlowFilterModel({
    required this.churchId,
    required this.startDate,
    required this.endDate,
    required this.groupBy,
    required this.symbol,
    required this.availabilityAccountIds,
    required this.costCenterId,
    required this.method,
    required this.includeProjection,
    required this.projectionBuckets,
  });

  factory CashFlowFilterModel.init() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month, now.day);

    return CashFlowFilterModel(
      churchId: '',
      startDate: start,
      endDate: end,
      groupBy: suggestCashFlowGroupBy(start, end),
      symbol: null,
      availabilityAccountIds: const [],
      costCenterId: null,
      method: null,
      includeProjection: false,
      projectionBuckets: 3,
    );
  }

  CashFlowFilterModel copyWith({
    String? churchId,
    DateTime? startDate,
    DateTime? endDate,
    CashFlowGroupBy? groupBy,
    String? symbol,
    bool clearSymbol = false,
    List<String>? availabilityAccountIds,
    String? costCenterId,
    bool clearCostCenterId = false,
    String? method,
    bool clearMethod = false,
    bool? includeProjection,
    int? projectionBuckets,
  }) {
    return CashFlowFilterModel(
      churchId: churchId ?? this.churchId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      groupBy: groupBy ?? this.groupBy,
      symbol: clearSymbol ? null : symbol ?? this.symbol,
      availabilityAccountIds:
          availabilityAccountIds ??
          List<String>.from(this.availabilityAccountIds),
      costCenterId:
          clearCostCenterId ? null : costCenterId ?? this.costCenterId,
      method: clearMethod ? null : method ?? this.method,
      includeProjection: includeProjection ?? this.includeProjection,
      projectionBuckets: projectionBuckets ?? this.projectionBuckets,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'churchId': churchId,
      'startDate': cashFlowApiDate(startDate),
      'endDate': cashFlowApiDate(endDate),
      'groupBy': groupBy.apiValue,
      if (symbol != null) 'symbol': symbol,
      if (availabilityAccountIds.isNotEmpty)
        'availabilityAccountId': availabilityAccountIds,
      if (costCenterId != null) 'costCenterId': costCenterId,
      if (method != null) 'method': method,
      'includeProjection': includeProjection,
      'projectionBuckets': projectionBuckets,
    };
  }
}
