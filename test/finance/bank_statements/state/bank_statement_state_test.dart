import 'package:church_finance_bk/features/erp/bank_statements/state/bank_statement_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BankStatementListState', () {
    test('tracks action flags correctly', () {
      final state = BankStatementListState.initial();

      final updated = state.copyWith(
        retrying: {'id-1': true},
        linking: {'id-2': true},
      );

      expect(updated.isRetrying('id-1'), isTrue);
      expect(updated.isLinking('id-2'), isTrue);
      expect(updated.isRetrying('id-3'), isFalse);
      expect(updated.isLinking('id-3'), isFalse);
    });

    test('initial state has empty collections', () {
      final state = BankStatementListState.initial();

      expect(state.statements, isEmpty);
      expect(state.loading, isFalse);
      expect(state.retrying, isEmpty);
      expect(state.linking, isEmpty);
    });
  });
}
