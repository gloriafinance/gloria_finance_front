import 'package:gloria_finance/core/utils/formatter.dart';

import 'cash_flow_filter_model.dart';

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

enum CashFlowProjectionStatus { available, degraded, unavailable }

extension CashFlowProjectionStatusX on CashFlowProjectionStatus {
  static CashFlowProjectionStatus fromApiValue(String? value) {
    switch (value) {
      case 'degraded':
        return CashFlowProjectionStatus.degraded;
      case 'unavailable':
        return CashFlowProjectionStatus.unavailable;
      case 'available':
      default:
        return CashFlowProjectionStatus.available;
    }
  }
}

class CashFlowSummaryModel {
  final double openingBalance;
  final double entries;
  final double exits;
  final double net;
  final double closingBalance;

  const CashFlowSummaryModel({
    required this.openingBalance,
    required this.entries,
    required this.exits,
    required this.net,
    required this.closingBalance,
  });

  factory CashFlowSummaryModel.fromJson(Map<String, dynamic>? json) {
    return CashFlowSummaryModel(
      openingBalance: parseAmount(json?['openingBalance']),
      entries: parseAmount(json?['entries']),
      exits: parseAmount(json?['exits']),
      net: parseAmount(json?['net']),
      closingBalance: parseAmount(json?['closingBalance']),
    );
  }

  factory CashFlowSummaryModel.empty() {
    return const CashFlowSummaryModel(
      openingBalance: 0,
      entries: 0,
      exits: 0,
      net: 0,
      closingBalance: 0,
    );
  }
}

class CashFlowSeriesRowModel {
  final DateTime period;
  final double entries;
  final double exits;
  final double net;
  final double runningBalance;

  const CashFlowSeriesRowModel({
    required this.period,
    required this.entries,
    required this.exits,
    required this.net,
    required this.runningBalance,
  });

  factory CashFlowSeriesRowModel.fromJson(Map<String, dynamic> json) {
    return CashFlowSeriesRowModel(
      period: _parseDate(json['period']) ?? DateTime.now(),
      entries: parseAmount(json['entries']),
      exits: parseAmount(json['exits']),
      net: parseAmount(json['net']),
      runningBalance: parseAmount(json['runningBalance']),
    );
  }
}

class CashFlowProjectionBucketModel {
  final DateTime period;
  final double projectedEntries;
  final double projectedExits;
  final double projectedNet;
  final double projectedBalance;

  const CashFlowProjectionBucketModel({
    required this.period,
    required this.projectedEntries,
    required this.projectedExits,
    required this.projectedNet,
    required this.projectedBalance,
  });

  factory CashFlowProjectionBucketModel.fromJson(Map<String, dynamic> json) {
    return CashFlowProjectionBucketModel(
      period: _parseDate(json['period']) ?? DateTime.now(),
      projectedEntries: parseAmount(json['projectedEntries']),
      projectedExits: parseAmount(json['projectedExits']),
      projectedNet: parseAmount(json['projectedNet']),
      projectedBalance: parseAmount(json['projectedBalance']),
    );
  }
}

class CashFlowProjectionModel {
  final String label;
  final CashFlowProjectionStatus status;
  final String? message;
  final List<CashFlowProjectionBucketModel> buckets;

  const CashFlowProjectionModel({
    required this.label,
    required this.status,
    required this.message,
    required this.buckets,
  });

  factory CashFlowProjectionModel.fromJson(Map<String, dynamic>? json) {
    return CashFlowProjectionModel(
      label:
          stringOrNull(json?['label']) ??
          'Proyección base (estimación por media móvil 3M)',
      status: CashFlowProjectionStatusX.fromApiValue(
        json?['status']?.toString(),
      ),
      message: stringOrNull(json?['message']),
      buckets:
          (json?['buckets'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map(
                (item) => CashFlowProjectionBucketModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
    );
  }

  factory CashFlowProjectionModel.empty() {
    return const CashFlowProjectionModel(
      label: 'Proyección base (estimación por media móvil 3M)',
      status: CashFlowProjectionStatus.unavailable,
      message: null,
      buckets: [],
    );
  }

  bool get hasBuckets => buckets.isNotEmpty;
}

class CashFlowAppliedFiltersModel {
  final DateTime startDate;
  final DateTime endDate;
  final CashFlowGroupBy groupBy;
  final String? symbol;
  final List<String> availabilityAccountIds;
  final String? costCenterId;
  final String? method;
  final bool includeProjection;
  final int projectionBuckets;

  const CashFlowAppliedFiltersModel({
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

  factory CashFlowAppliedFiltersModel.fromJson(Map<String, dynamic>? json) {
    final now = DateTime.now();
    final startDate = _parseDate(json?['startDate']) ?? now;
    final endDate = _parseDate(json?['endDate']) ?? now;

    return CashFlowAppliedFiltersModel(
      startDate: startDate,
      endDate: endDate,
      groupBy: CashFlowGroupByX.fromApiValue(json?['groupBy']?.toString()),
      symbol: stringOrNull(json?['symbol']),
      availabilityAccountIds:
          (json?['availabilityAccountIds'] as List<dynamic>? ?? const [])
              .map((item) => item.toString())
              .toList(),
      costCenterId: stringOrNull(json?['costCenterId']),
      method: stringOrNull(json?['method']),
      includeProjection: parseNullableBool(json?['includeProjection']) ?? false,
      projectionBuckets:
          int.tryParse(json?['projectionBuckets']?.toString() ?? '') ?? 0,
    );
  }

  factory CashFlowAppliedFiltersModel.empty() {
    final filter = CashFlowFilterModel.init();
    return CashFlowAppliedFiltersModel(
      startDate: filter.startDate,
      endDate: filter.endDate,
      groupBy: filter.groupBy,
      symbol: filter.symbol,
      availabilityAccountIds: filter.availabilityAccountIds,
      costCenterId: filter.costCenterId,
      method: filter.method,
      includeProjection: filter.includeProjection,
      projectionBuckets: filter.projectionBuckets,
    );
  }
}

class CashFlowReportModel {
  final String reportName;
  final DateTime? generatedAt;
  final CashFlowAppliedFiltersModel filters;
  final CashFlowSummaryModel summary;
  final List<CashFlowSeriesRowModel> series;
  final CashFlowProjectionModel projection;
  final List<String> messages;

  const CashFlowReportModel({
    required this.reportName,
    required this.generatedAt,
    required this.filters,
    required this.summary,
    required this.series,
    required this.projection,
    required this.messages,
  });

  factory CashFlowReportModel.fromJson(Map<String, dynamic> json) {
    return CashFlowReportModel(
      reportName: stringOrNull(json['reportName']) ?? 'Flujo de Caja (Directo)',
      generatedAt: _parseDate(json['generatedAt']),
      filters: CashFlowAppliedFiltersModel.fromJson(mapOrNull(json['filters'])),
      summary: CashFlowSummaryModel.fromJson(mapOrNull(json['summary'])),
      series:
          (json['series'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map(
                (item) => CashFlowSeriesRowModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
      projection: CashFlowProjectionModel.fromJson(
        mapOrNull(json['projection']),
      ),
      messages:
          (json['messages'] as List<dynamic>? ?? const [])
              .map((item) => item.toString())
              .toList(),
    );
  }

  factory CashFlowReportModel.empty() {
    return CashFlowReportModel(
      reportName: '',
      generatedAt: null,
      filters: CashFlowAppliedFiltersModel.empty(),
      summary: CashFlowSummaryModel.empty(),
      series: const [],
      projection: CashFlowProjectionModel.empty(),
      messages: const [],
    );
  }

  bool get hasSeries => series.isNotEmpty;
}

class CashFlowBucketDetailModel {
  final String financialRecordId;
  final DateTime date;
  final String? description;
  final double amount;
  final String type;
  final String flowType;
  final String status;
  final String? method;
  final String? accountId;
  final String? accountName;
  final String? accountType;
  final String? categoryId;
  final String? categoryName;
  final String? categoryType;
  final String? statementCategory;
  final String? costCenterId;
  final String? costCenterName;
  final String? voucher;

  const CashFlowBucketDetailModel({
    required this.financialRecordId,
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
    required this.flowType,
    required this.status,
    required this.method,
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.categoryId,
    required this.categoryName,
    required this.categoryType,
    required this.statementCategory,
    required this.costCenterId,
    required this.costCenterName,
    required this.voucher,
  });

  factory CashFlowBucketDetailModel.fromJson(Map<String, dynamic> json) {
    return CashFlowBucketDetailModel(
      financialRecordId: stringOrNull(json['financialRecordId']) ?? '',
      date: _parseDate(json['date']) ?? DateTime.now(),
      description: stringOrNull(json['description']),
      amount: parseAmount(json['amount']),
      type: stringOrNull(json['type']) ?? '',
      flowType: stringOrNull(json['flowType']) ?? '',
      status: stringOrNull(json['status']) ?? '',
      method: stringOrNull(json['method']),
      accountId: stringOrNull(json['accountId']),
      accountName: stringOrNull(json['accountName']),
      accountType: stringOrNull(json['accountType']),
      categoryId: stringOrNull(json['categoryId']),
      categoryName: stringOrNull(json['categoryName']),
      categoryType: stringOrNull(json['categoryType']),
      statementCategory: stringOrNull(json['statementCategory']),
      costCenterId: stringOrNull(json['costCenterId']),
      costCenterName: stringOrNull(json['costCenterName']),
      voucher: stringOrNull(json['voucher']),
    );
  }
}

class CashFlowBucketDetailsModel {
  final DateTime startDate;
  final DateTime endDate;
  final CashFlowGroupBy groupBy;
  final List<CashFlowBucketDetailModel> details;

  const CashFlowBucketDetailsModel({
    required this.startDate,
    required this.endDate,
    required this.groupBy,
    required this.details,
  });

  factory CashFlowBucketDetailsModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return CashFlowBucketDetailsModel(
      startDate: _parseDate(json['startDate']) ?? now,
      endDate: _parseDate(json['endDate']) ?? now,
      groupBy: CashFlowGroupByX.fromApiValue(json['groupBy']?.toString()),
      details:
          (json['details'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map(
                (item) => CashFlowBucketDetailModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
    );
  }

  factory CashFlowBucketDetailsModel.empty() {
    final now = DateTime.now();
    return CashFlowBucketDetailsModel(
      startDate: now,
      endDate: now,
      groupBy: CashFlowGroupBy.day,
      details: const [],
    );
  }
}
