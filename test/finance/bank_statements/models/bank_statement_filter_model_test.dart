import 'package:church_finance_bk/finance/bank_statements/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BankStatementFilterModel', () {
    test('produces query map without empty values', () {
      final filter = BankStatementFilterModel.initial().copyWith(
        bank: 'NUBANK',
        setBank: true,
        status: BankStatementReconciliationStatus.unmatched,
        setStatus: true,
        month: 11,
        setMonth: true,
        year: 2024,
        setYear: true,
      );

      final params = filter.toQueryParameters();

      expect(params, containsPair('bank', 'NUBANK'));
      expect(params, containsPair('status', 'UNMATCHED'));
      expect(params, containsPair('month', 11));
      expect(params, containsPair('year', 2024));
      expect(params.containsKey('churchId'), isFalse);
    });

    test('supports date range formatting and clearing fields', () {
      final now = DateTime(2024, 11, 15);
      final filter = BankStatementFilterModel.initial()
          .copyWith(dateFrom: now, setDateFrom: true)
          .copyWith(dateTo: now.add(const Duration(days: 3)), setDateTo: true)
          .copyWith(bank: null, setBank: true);

      final params = filter.toQueryParameters();

      expect(params['dateFrom'], equals('2024-11-15'));
      expect(params['dateTo'], equals('2024-11-18'));
      expect(params.containsKey('bank'), isFalse);
    });
  });
}
