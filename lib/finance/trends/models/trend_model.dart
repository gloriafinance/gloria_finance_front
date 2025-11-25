class TrendValue {
  final double current;
  final double previous;

  TrendValue({required this.current, required this.previous});

  factory TrendValue.fromJson(Map<String, dynamic> json) {
    return TrendValue(
      current: double.parse(json['current'].toString()),
      previous: double.parse(json['previous'].toString()),
    );
  }
}

class TrendPeriod {
  final int year;
  final int month;

  TrendPeriod({required this.year, required this.month});

  factory TrendPeriod.fromJson(Map<String, dynamic> json) {
    return TrendPeriod(
      year: int.parse(json['year'].toString()),
      month: int.parse(json['month'].toString()),
    );
  }
}

class TrendData {
  final TrendValue revenue;
  final TrendValue opex;
  final TrendValue transfers;
  final TrendValue capex;
  final TrendValue netIncome;

  TrendData({
    required this.revenue,
    required this.opex,
    required this.transfers,
    required this.capex,
    required this.netIncome,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      revenue: TrendValue.fromJson(json['revenue']),
      opex: TrendValue.fromJson(json['opex']),
      transfers: TrendValue.fromJson(json['transfers']),
      capex: TrendValue.fromJson(json['capex']),
      netIncome: TrendValue.fromJson(json['netIncome']),
    );
  }
}

class TrendResponse {
  final TrendPeriod period;
  final TrendData trend;

  TrendResponse({required this.period, required this.trend});

  factory TrendResponse.fromJson(Map<String, dynamic> json) {
    return TrendResponse(
      period: TrendPeriod.fromJson(json['period']),
      trend: TrendData.fromJson(json['trend']),
    );
  }
}
