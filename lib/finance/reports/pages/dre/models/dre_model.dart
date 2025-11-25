// lib/finance/reports/pages/dre/models/dre_model.dart

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value.toString()) ?? 0;
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

/// Modelo de respuesta DRE según la especificación OpenAPI
class DREModel {
  final double grossRevenue;
  final double netRevenue;
  final double directCosts;
  final double grossProfit;
  final double operationalExpenses;
  final double ministryTransfers;
  final double capexInvestments;
  final double operationalResult;
  final double extraordinaryResults;
  final double netResult;
  final int? year;
  final int? month;

  DREModel({
    required this.grossRevenue,
    required this.netRevenue,
    required this.directCosts,
    required this.grossProfit,
    required this.operationalExpenses,
    required this.ministryTransfers,
    required this.capexInvestments,
    required this.operationalResult,
    required this.extraordinaryResults,
    required this.netResult,
    required this.year,
    required this.month,
  });

  factory DREModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DREModel.empty();
    }

    return DREModel(
      grossRevenue: _toDouble(json['grossRevenue']),
      netRevenue: _toDouble(json['netRevenue']),
      directCosts: _toDouble(json['directCosts']),
      grossProfit: _toDouble(json['grossProfit']),
      operationalExpenses: _toDouble(json['operationalExpenses']),
      ministryTransfers: _toDouble(json['ministryTransfers']),
      capexInvestments: _toDouble(json['capexInvestments']),
      operationalResult: _toDouble(json['operationalResult']),
      extraordinaryResults: _toDouble(json['extraordinaryResults']),
      netResult: _toDouble(json['netResult']),
      year: _toInt(json['year']),
      month: _toInt(json['month']),
    );
  }

  factory DREModel.empty() {
    return DREModel(
      grossRevenue: 0,
      netRevenue: 0,
      directCosts: 0,
      grossProfit: 0,
      operationalExpenses: 0,
      ministryTransfers: 0,
      capexInvestments: 0,
      operationalResult: 0,
      extraordinaryResults: 0,
      netResult: 0,
      year: null,
      month: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grossRevenue': grossRevenue,
      'netRevenue': netRevenue,
      'directCosts': directCosts,
      'grossProfit': grossProfit,
      'operationalExpenses': operationalExpenses,
      'ministryTransfers': ministryTransfers,
      'capexInvestments': capexInvestments,
      'operationalResult': operationalResult,
      'extraordinaryResults': extraordinaryResults,
      'netResult': netResult,
      'year': year,
      'month': month,
    };
  }
}
