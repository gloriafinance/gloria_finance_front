import 'package:church_finance_bk/finance/trends/models/trend_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TrendResponse.fromJson handles string values for period', () {
    final json = {
      "period": {"year": "2025", "month": "11"},
      "trend": {
        "revenue": {"current": 2290.55, "previous": 2829.42},
        "opex": {"current": 0, "previous": 2099.72},
        "transfers": {"current": 0, "previous": 0},
        "capex": {"current": 0, "previous": 0},
        "netIncome": {"current": 2419.55, "previous": 353.3000000000003},
      },
    };

    final response = TrendResponse.fromJson(json);

    expect(response.period.year, 2025);
    expect(response.period.month, 11);
    expect(response.trend.revenue.current, 2290.55);
  });
}
