double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value.toString()) ?? 0;
}

String _toSymbol(dynamic value) {
  final symbol = value?.toString().trim() ?? '';
  return symbol;
}

class DREBySymbolModel {
  final String symbol;
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

  DREBySymbolModel({
    required this.symbol,
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
  });

  factory DREBySymbolModel.fromJson(Map<String, dynamic> json) {
    return DREBySymbolModel(
      symbol: _toSymbol(json['symbol']),
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
    );
  }

  factory DREBySymbolModel.empty() {
    return DREBySymbolModel(
      symbol: '',
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
    );
  }
}

class DREReportModel {
  final List<DREBySymbolModel> items;

  DREReportModel({required this.items});

  factory DREReportModel.fromJson(List<dynamic>? json) {
    if (json == null) {
      return DREReportModel.empty();
    }

    return DREReportModel(
      items:
          json
              .whereType<Map>()
              .map(
                (item) =>
                    DREBySymbolModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
    );
  }

  factory DREReportModel.empty() {
    return DREReportModel(items: []);
  }

  bool get hasData => items.isNotEmpty;

  List<String> get orderedSymbols {
    final sorted = [...items]..sort((a, b) {
      final revenueCompare = b.grossRevenue.compareTo(a.grossRevenue);
      if (revenueCompare != 0) {
        return revenueCompare;
      }
      return a.symbol.compareTo(b.symbol);
    });
    return sorted.map((item) => item.symbol).toList();
  }

  int get currencyCount => orderedSymbols.length;

  Map<String, DREBySymbolModel> get itemBySymbol {
    final mapped = <String, DREBySymbolModel>{};
    for (final item in items) {
      mapped[item.symbol] = item;
    }
    return mapped;
  }
}
