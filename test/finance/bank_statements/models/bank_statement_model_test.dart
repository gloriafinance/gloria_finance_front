import 'package:church_finance_bk/features/erp/bank_statements/models/bank_statement_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BankStatementModel', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'bankStatementId': 'BSTMT-123',
        'churchId': 'CHURCH-1',
        'bank': {
          'bankName': 'Nubank',
          'bankId': 'bank-nubank',
          'tag': 'NUBANK',
        },
        'availabilityAccount': {
          'accountName': 'Conta principal',
          'availabilityAccountId': 'acc-123',
        },
        'postedAt': '2024-10-05T12:00:00.000Z',
        'amount': 1520.75,
        'description': 'Transferência recebida',
        'direction': 'INCOME',
        'fitId': 'FIT-001',
        'hash': 'HASH-XYZ',
        'month': '10',
        'year': '2024',
        'reconciliationStatus': 'PENDING',
        'financialRecordId': null,
        'reconciledAt': null,
        'createdAt': '2024-10-06T10:00:00.000Z',
        'updatedAt': '2024-10-06T10:30:00.000Z',
        'raw': {'line': 1, 'amount': 1520.75},
      };

      final model = BankStatementModel.fromJson(json);

      expect(model.bankStatementId, equals('BSTMT-123'));
      expect(model.bank.bankName, equals('Nubank'));
      expect(model.bank.tag, equals('NUBANK'));
      expect(model.availabilityAccount.accountName, equals('Conta principal'));
      expect(model.amount, equals(1520.75));
      expect(model.direction, equals(BankStatementDirection.income));
      expect(
        model.reconciliationStatus,
        equals(BankStatementReconciliationStatus.pending),
      );
      expect(model.financialRecordId, isNull);
      expect(model.raw, equals({'line': 1, 'amount': 1520.75}));
      expect(model.isReconciled, isFalse);
    });

    test('toJson serializes values using API format', () {
      final model = BankStatementModel(
        bankStatementId: 'BSTMT-123',
        churchId: 'CHURCH-1',
        bank: const BankInStatementModel(
          bankName: 'Nubank',
          bankId: 'bank-nubank',
          tag: 'NUBANK',
        ),
        availabilityAccount: const AvailabilityAccountModel(
          accountName: 'Conta principal',
          availabilityAccountId: 'acc-123',
        ),
        postedAt: DateTime.utc(2024, 10, 5, 12),
        amount: 100,
        description: 'Pagamento',
        direction: BankStatementDirection.outgo,
        fitId: 'FIT-002',
        hash: 'HASH-ABC',
        month: 9,
        year: 2024,
        reconciliationStatus: BankStatementReconciliationStatus.reconciled,
        financialRecordId: 'REC-001',
        reconciledAt: DateTime.utc(2024, 10, 7, 9),
        createdAt: DateTime.utc(2024, 10, 6, 10),
        updatedAt: DateTime.utc(2024, 10, 6, 10, 30),
        raw: const {'line': 1},
      );

      final json = model.toJson();

      expect(json['direction'], equals('OUTGO'));
      expect(json['reconciliationStatus'], equals('RECONCILED'));
      expect(json['financialRecordId'], equals('REC-001'));
      expect(json['month'], equals('9'));
      expect(json['year'], equals('2024'));
      expect(json['raw'], equals({'line': 1}));
      expect(json['bank']['bankName'], equals('Nubank'));
      expect(
        json['availabilityAccount']['accountName'],
        equals('Conta principal'),
      );
    });
  });
}
