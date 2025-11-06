import 'package:church_finance_bk/finance/accounts_receivable/models/accounts_receivable_payment_mode.dart';
import 'package:church_finance_bk/finance/accounts_receivable/models/index.dart';
import 'package:church_finance_bk/finance/models/installment_model.dart';
import 'package:church_finance_bk/finance/accounts_receivable/pages/register_accounts_receivable/state/form_accounts_receivable_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormAccountsReceivableState.toJson', () {
    test('builds single payment payload matching backend contract', () {
      final state = FormAccountsReceivableState.init().copyWith(
        debtorType: DebtorType.MEMBER,
        type: AccountsReceivableType.LOAN,
        debtorDNI: 'member123',
        debtorName: 'Juan Pérez',
        debtorPhone: '+5511965990791',
        debtorEmail: 'programador.angel@gmail.com',
        description: 'Outro Emprestimo',
        financialConceptId: '2b2a16cc-b6a2-4d3f-bfc1-d1b661e00726',
        paymentMode: AccountsReceivablePaymentMode.single,
        totalAmount: 500,
        singleDueDate: '01/06/2023',
      );

      final payload = state.toJson();

      expect(payload, {
        'debtor': {
          'debtorType': 'MEMBER',
          'debtorDNI': 'member123',
          'name': 'Juan Pérez',
          'email': 'programador.angel@gmail.com',
          'phone': '+5511965990791',
        },
        'description': 'Outro Emprestimo',
        'financialConceptId': '2b2a16cc-b6a2-4d3f-bfc1-d1b661e00726',
        'installments': [
          {'amount': 500, 'dueDate': '2023-06-01'},
        ],
        'type': 'LOAN',
      });
    });

    test('uses generated installments for automatic schedules', () {
      final installments = [
        InstallmentModel(amount: 500, dueDate: '01/06/2023', sequence: 1),
        InstallmentModel(amount: 500, dueDate: '01/07/2023', sequence: 2),
      ];

      final state = FormAccountsReceivableState.init().copyWith(
        debtorType: DebtorType.EXTERNAL,
        type: AccountsReceivableType.LOAN,
        debtorDNI: 'debtor-01',
        debtorName: 'Empresa XYZ',
        debtorPhone: '+55 11 9999-9999',
        debtorEmail: 'contato@empresa.com',
        description: 'Contrato de empréstimo',
        financialConceptId: 'concept-01',
        paymentMode: AccountsReceivablePaymentMode.automatic,
        installments: installments,
      );

      final payload = state.toJson();

      expect(payload['installments'], [
        {'amount': 500, 'dueDate': '2023-06-01'},
        {'amount': 500, 'dueDate': '2023-07-01'},
      ]);
      expect(payload['debtor'], {
        'debtorType': 'EXTERNAL',
        'debtorDNI': 'debtor-01',
        'name': 'Empresa XYZ',
        'email': 'contato@empresa.com',
        'phone': '+55 11 9999-9999',
      });
      expect(payload['type'], 'LOAN');
      expect(payload['description'], 'Contrato de empréstimo');
      expect(payload['financialConceptId'], 'concept-01');
    });
  });
}
