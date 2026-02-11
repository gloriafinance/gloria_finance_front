// test/finance/reports/pages/dre/models/dre_model_test.dart

import 'package:gloria_finance/features/erp/reports/pages/dre/models/dre_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DREBySymbolModel', () {
    test('fromJson parses all fields correctly according to API spec', () {
      final json = {
        'grossRevenue': 3117.05,
        'netRevenue': 3117.05,
        'directCosts': 0.0,
        'grossProfit': 3117.05,
        'operationalExpenses': 101.5,
        'ministryTransfers': 500.0,
        'capexInvestments': 200.0,
        'operationalResult': 3015.55,
        'extraordinaryResults': 0.0,
        'netResult': 3015.55,
        'year': 2024,
        'month': 7,
        'symbol': 'R\$',
      };

      final model = DREBySymbolModel.fromJson(json);

      expect(model.grossRevenue, equals(3117.05));
      expect(model.netRevenue, equals(3117.05));
      expect(model.directCosts, equals(0.0));
      expect(model.grossProfit, equals(3117.05));
      expect(model.operationalExpenses, equals(101.5));
      expect(model.ministryTransfers, equals(500.0));
      expect(model.capexInvestments, equals(200.0));
      expect(model.operationalResult, equals(3015.55));
      expect(model.extraordinaryResults, equals(0.0));
      expect(model.netResult, equals(3015.55));
    });

    test('fromJson handles null values', () {
      final model = DREBySymbolModel.fromJson({});

      expect(model.grossRevenue, equals(0.0));
      expect(model.netRevenue, equals(0.0));
      expect(model.directCosts, equals(0.0));
      expect(model.grossProfit, equals(0.0));
      expect(model.operationalExpenses, equals(0.0));
      expect(model.operationalResult, equals(0.0));
      expect(model.extraordinaryResults, equals(0.0));
      expect(model.netResult, equals(0.0));
    });

    test('empty factory creates model with zero values', () {
      final model = DREBySymbolModel.empty();

      expect(model.grossRevenue, equals(0.0));
      expect(model.netRevenue, equals(0.0));
      expect(model.directCosts, equals(0.0));
      expect(model.grossProfit, equals(0.0));
      expect(model.operationalExpenses, equals(0.0));
      expect(model.operationalResult, equals(0.0));
      expect(model.extraordinaryResults, equals(0.0));
      expect(model.netResult, equals(0.0));
    });

    test('handles string values that can be converted to double', () {
      final json = {
        'grossRevenue': '1500.50',
        'netRevenue': '1500.50',
        'directCosts': '100',
        'grossProfit': '1400.50',
        'operationalExpenses': '200.25',
        'ministryTransfers': '75',
        'capexInvestments': '125',
        'operationalResult': '1200.25',
        'extraordinaryResults': '50',
        'netResult': '1250.25',
        'symbol': 'R\$',
      };

      final model = DREBySymbolModel.fromJson(json);

      expect(model.grossRevenue, equals(1500.50));
      expect(model.netRevenue, equals(1500.50));
      expect(model.directCosts, equals(100.0));
      expect(model.grossProfit, equals(1400.50));
      expect(model.operationalExpenses, equals(200.25));
      expect(model.ministryTransfers, equals(75.0));
      expect(model.capexInvestments, equals(125.0));
      expect(model.operationalResult, equals(1200.25));
      expect(model.extraordinaryResults, equals(50.0));
      expect(model.netResult, equals(1250.25));
    });
  });
}
