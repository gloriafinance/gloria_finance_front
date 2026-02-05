import 'package:gloria_finance/features/erp/bank_statements/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BankStatementFilterModel', () {
    test('produces query map without empty values', () {
      final filter = BankStatementFilterModel.initial().copyWith(
        bankId: 'bank-nubank-id',
        status: BankStatementReconciliationStatus.unmatched,
        month: 11,
        year: 2024,
      );

      final params = filter.toQueryParameters();

      expect(params, containsPair('bankId', 'bank-nubank-id'));
      expect(params, containsPair('status', 'UNMATCHED'));
      expect(params, containsPair('month', 11));
      expect(params, containsPair('year', 2024));
      expect(params.containsKey('churchId'), isFalse);
    });

    test('supports date range formatting', () {
      final now = DateTime(2024, 11, 15);
      final filter = BankStatementFilterModel.initial()
          .copyWith(dateFrom: now)
          .copyWith(dateTo: now.add(const Duration(days: 3)));

      final params = filter.toQueryParameters();

      expect(params['dateFrom'], equals('2024-11-15'));
      expect(params['dateTo'], equals('2024-11-18'));
    });
  });
}
