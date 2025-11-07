import 'package:church_finance_bk/finance/bank_statements/models/index.dart';
import 'package:church_finance_bk/finance/bank_statements/state/bank_statement_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BankStatementState', () {
    test('tracks action flags and last import correctly', () {
      final state = BankStatementState.initial();

      final updated = state.copyWith(
        retrying: {'id-1': true},
        linking: {'id-2': true},
        lastImport: const ImportBankStatementResponse(
          bank: 'NUBANK',
          month: 11,
          year: 2024,
          churchId: 'CHURCH-1',
          queuedAt: DateTime.utc(2024, 11, 18),
        ),
        lastImportHasValue: true,
      );

      expect(updated.isRetrying('id-1'), isTrue);
      expect(updated.isLinking('id-2'), isTrue);
      expect(updated.lastImport?.bank, equals('NUBANK'));

      final cleared = updated.copyWith(
        lastImport: null,
        lastImportHasValue: true,
      );

      expect(cleared.lastImport, isNull);
    });
  });
}
