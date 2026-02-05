// test/finance/reports/pages/dre/models/dre_filter_model_test.dart

import 'package:gloria_finance/features/erp/reports/pages/dre/models/dre_filter_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DREFilterModel', () {
    test('init creates model with current date values', () {
      final now = DateTime.now();
      final model = DREFilterModel.init();

      expect(model.churchId, equals(''));
      expect(model.year, equals(now.year));
      expect(model.month, equals(now.month));
    });

    test('copyWith updates specified fields', () {
      final model = DREFilterModel(
        churchId: 'church-001',
        year: 2024,
        month: 5,
      );

      final updated = model.copyWith(year: 2025, month: 6);

      expect(updated.churchId, equals('church-001'));
      expect(updated.year, equals(2025));
      expect(updated.month, equals(6));
    });

    test('copyWith without parameters returns same values', () {
      final model = DREFilterModel(
        churchId: 'church-002',
        year: 2023,
        month: 12,
      );

      final updated = model.copyWith();

      expect(updated.churchId, equals('church-002'));
      expect(updated.year, equals(2023));
      expect(updated.month, equals(12));
    });

    test('toJson includes month when it has a valid value', () {
      final model = DREFilterModel(
        churchId: 'church-003',
        year: 2024,
        month: 8,
      );

      final json = model.toJson();

      expect(json['churchId'], equals('church-003'));
      expect(json['year'], equals(2024));
      expect(json['month'], equals(8));
    });

    test('toJson excludes month when it is null', () {
      final model = DREFilterModel(
        churchId: 'church-004',
        year: 2024,
        month: null,
      );

      final json = model.toJson();

      expect(json['churchId'], equals('church-004'));
      expect(json['year'], equals(2024));
      expect(json.containsKey('month'), isFalse);
    });

    test('toJson excludes month when it is zero', () {
      final model = DREFilterModel(
        churchId: 'church-005',
        year: 2024,
        month: 0,
      );

      final json = model.toJson();

      expect(json['churchId'], equals('church-005'));
      expect(json['year'], equals(2024));
      expect(json.containsKey('month'), isFalse);
    });
  });
}
