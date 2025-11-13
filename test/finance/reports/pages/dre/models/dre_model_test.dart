// test/finance/reports/pages/dre/models/dre_model_test.dart

import 'package:church_finance_bk/finance/reports/pages/dre/models/dre_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DREModel', () {
    test('fromJson parses all fields correctly according to API spec', () {
      final json = {
        'receitaBruta': 3117.05,
        'receitaLiquida': 3117.05,
        'custosDiretos': 0.0,
        'resultadoBruto': 3117.05,
        'despesasOperacionais': 101.5,
        'resultadoOperacional': 3015.55,
        'resultadosExtraordinarios': 0.0,
        'resultadoLiquido': 3015.55,
      };

      final model = DREModel.fromJson(json);

      expect(model.receitaBruta, equals(3117.05));
      expect(model.receitaLiquida, equals(3117.05));
      expect(model.custosDiretos, equals(0.0));
      expect(model.resultadoBruto, equals(3117.05));
      expect(model.despesasOperacionais, equals(101.5));
      expect(model.resultadoOperacional, equals(3015.55));
      expect(model.resultadosExtraordinarios, equals(0.0));
      expect(model.resultadoLiquido, equals(3015.55));
    });

    test('fromJson handles null values', () {
      final model = DREModel.fromJson(null);

      expect(model.receitaBruta, equals(0.0));
      expect(model.receitaLiquida, equals(0.0));
      expect(model.custosDiretos, equals(0.0));
      expect(model.resultadoBruto, equals(0.0));
      expect(model.despesasOperacionais, equals(0.0));
      expect(model.resultadoOperacional, equals(0.0));
      expect(model.resultadosExtraordinarios, equals(0.0));
      expect(model.resultadoLiquido, equals(0.0));
    });

    test('empty factory creates model with zero values', () {
      final model = DREModel.empty();

      expect(model.receitaBruta, equals(0.0));
      expect(model.receitaLiquida, equals(0.0));
      expect(model.custosDiretos, equals(0.0));
      expect(model.resultadoBruto, equals(0.0));
      expect(model.despesasOperacionais, equals(0.0));
      expect(model.resultadoOperacional, equals(0.0));
      expect(model.resultadosExtraordinarios, equals(0.0));
      expect(model.resultadoLiquido, equals(0.0));
    });

    test('toJson serializes all fields correctly', () {
      final model = DREModel(
        receitaBruta: 5000.0,
        receitaLiquida: 4500.0,
        custosDiretos: 1000.0,
        resultadoBruto: 3500.0,
        despesasOperacionais: 500.0,
        resultadoOperacional: 3000.0,
        resultadosExtraordinarios: 200.0,
        resultadoLiquido: 3200.0,
      );

      final json = model.toJson();

      expect(json['receitaBruta'], equals(5000.0));
      expect(json['receitaLiquida'], equals(4500.0));
      expect(json['custosDiretos'], equals(1000.0));
      expect(json['resultadoBruto'], equals(3500.0));
      expect(json['despesasOperacionais'], equals(500.0));
      expect(json['resultadoOperacional'], equals(3000.0));
      expect(json['resultadosExtraordinarios'], equals(200.0));
      expect(json['resultadoLiquido'], equals(3200.0));
    });

    test('handles string values that can be converted to double', () {
      final json = {
        'receitaBruta': '1500.50',
        'receitaLiquida': '1500.50',
        'custosDiretos': '100',
        'resultadoBruto': '1400.50',
        'despesasOperacionais': '200.25',
        'resultadoOperacional': '1200.25',
        'resultadosExtraordinarios': '50',
        'resultadoLiquido': '1250.25',
      };

      final model = DREModel.fromJson(json);

      expect(model.receitaBruta, equals(1500.50));
      expect(model.receitaLiquida, equals(1500.50));
      expect(model.custosDiretos, equals(100.0));
      expect(model.resultadoBruto, equals(1400.50));
      expect(model.despesasOperacionais, equals(200.25));
      expect(model.resultadoOperacional, equals(1200.25));
      expect(model.resultadosExtraordinarios, equals(50.0));
      expect(model.resultadoLiquido, equals(1250.25));
    });
  });
}
