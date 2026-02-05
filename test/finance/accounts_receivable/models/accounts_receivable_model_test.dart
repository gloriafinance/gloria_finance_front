import 'package:gloria_finance/features/erp/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/models/debtor_model.dart';
import 'package:gloria_finance/features/erp/models/installment_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountsReceivableModel', () {
    test('parses account type from backend payload', () {
      final model = AccountsReceivableModel.fromJson({
        'accountReceivableId': 'ar-001',
        'churchId': 'church-01',
        'description': 'Curso de música',
        'status': 'PENDING',
        'type': 'SERVICE',
        'amountPaid': 0,
        'amountPending': 120,
        'amountTotal': 120,
        'createdAt': '2024-11-01T00:00:00.000Z',
        'updatedAt': '2024-11-02T00:00:00.000Z',
        'debtor': {
          'debtorType': 'MEMBER',
          'debtorDNI': '12345678900',
          'name': 'Maria Silva',
          'phone': '5511999999999',
          'email': 'maria@example.com',
          'address': 'Rua das Flores, 100',
        },
        'installments': [
          {'sequence': 1, 'amount': 120, 'dueDate': '2024-11-20'},
        ],
      });

      expect(model.type, AccountsReceivableType.SERVICE);
      expect(model.type?.friendlyName, 'Serviço');
    });

    test('includes selected account type when serializing payload', () {
      final model = AccountsReceivableModel(
        debtor: DebtorModel(
          debtorType: DebtorType.MEMBER.apiValue,
          debtorDNI: '11122233344',
          name: 'Joao Pereira',
          phone: '5511988888888',
          email: 'joao@example.com',
          address: 'Av. Central, 200',
        ),
        churchId: 'church-02',
        description: 'Locacao de auditorio',
        installments: [InstallmentModel(amount: 300, dueDate: '15/12/2024')],
        type: AccountsReceivableType.LEGAL,
      );

      final payload = model.toJson();
      expect(payload['type'], 'LEGAL');
    });
  });
}
