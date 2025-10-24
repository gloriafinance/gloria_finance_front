import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_model.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountsPayableModel.fromJson', () {
    test('parses document and payment information from backend payload', () {
      final model = AccountsPayableModel.fromJson({
        'accountPayableId': 'ap-001',
        'supplierId': 'supplier-99',
        'description': 'Serviço de manutenção',
        'status': 'PARTIAL_PAYMENT',
        'installments': [
          {
            'sequence': 1,
            'amount': 1250.75,
            'dueDate': '2024-11-10',
          },
          {
            'sequence': 2,
            'amount': 1250.75,
            'dueDate': '2024-12-10',
          }
        ],
        'document': {
          'type': 'INVOICE',
          'number': 'NF-102030',
          'issueDate': '2024-10-01',
        },
        'payment': {
          'mode': 'MANUAL_INSTALLMENTS',
          'manual': {
            'totalAmount': 2501.5,
            'installments': [
              {
                'sequence': 1,
                'amount': 1250.75,
                'dueDate': '2024-11-10',
              }
            ],
          },
        },
        'taxMetadata': {
          'status': 'TAXED',
          'taxExempt': false,
          'observation': 'Retenção municipal',
          'cstCode': '01',
          'cfop': '5933',
        },
        'taxes': [
          {
            'taxType': 'ISS',
            'percentage': 5,
            'amount': 62.53,
            'status': 'TAXED',
          }
        ],
      });

      expect(model.document, isNotNull);
      expect(model.document!.type, AccountsPayableDocumentType.invoice);
      expect(model.document!.issueDateFormatted, '01/10/2024');

      expect(model.payment, isNotNull);
      expect(model.payment!.mode, AccountsPayablePaymentMode.manual);
      expect(model.payment!.manual, isNotNull);
      expect(model.payment!.manual!.installments, hasLength(1));
      expect(model.payment!.manual!.totalAmount, 2501.5);

      expect(model.statusEnum, AccountsPayableStatus.PARTIAL);
      expect(model.statusLabel, 'Pagamento parcial');
      expect(model.installments.first.sequence, 1);

      expect(model.taxMetadata, isNotNull);
      expect(model.taxMetadata!.status, AccountsPayableTaxStatus.taxed);
      expect(model.taxMetadata!.taxExempt, isFalse);
      expect(model.taxMetadata!.observation, 'Retenção municipal');
      expect(model.taxMetadata!.cstCode, '01');
      expect(model.taxMetadata!.cfop, '5933');

      expect(model.taxes, hasLength(1));
      expect(model.taxes.first.taxType, 'ISS');
      expect(model.taxes.first.amount, closeTo(62.53, 0.0001));
    });
  });
}
