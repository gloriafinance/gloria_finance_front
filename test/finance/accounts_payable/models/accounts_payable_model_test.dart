import 'package:church_finance_bk/features/erp/accounts_payable/models/accounts_payable_model.dart';
import 'package:church_finance_bk/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountsPayableModel.fromJson', () {
    test(
      'parses document and installment information from backend payload',
      () {
        final model = AccountsPayableModel.fromJson({
          'accountPayableId': 'ap-001',
          'supplierId': 'supplier-99',
          'description': 'Serviço de manutenção',
          'status': 'PARTIAL',
          'installments': [
            {'sequence': 1, 'amount': 1250.75, 'dueDate': '2024-11-10'},
            {'sequence': 2, 'amount': 1250.75, 'dueDate': '2024-12-10'},
          ],
          'amountTotal': 2501.5,
          'amountPaid': 1250.75,
          'amountPending': 1250.75,
          'taxDocument': {
            'type': 'INVOICE',
            'number': 'NF-102030',
            'date': '2024-10-01',
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
            },
          ],
        });

        expect(model.document, isNotNull);
        expect(model.document!.type, AccountsPayableDocumentType.invoice);
        expect(model.document!.issueDateFormatted, '01/10/2024');

        expect(model.statusEnum, AccountsPayableStatus.PARTIAL);
        expect(model.statusLabel, 'Pagamento parcial');
        expect(model.installments.first.sequence, 1);
        expect(model.taxAmountTotal, 0.0);
        expect(model.amountTotal, closeTo(2501.5, 0.0001));
        expect(model.amountPending, closeTo(1250.75, 0.0001));
        expect(model.amountPaid, closeTo(1250.75, 0.0001));

        expect(model.taxMetadata, isNotNull);
        expect(model.taxMetadata!.status, AccountsPayableTaxStatus.taxed);
        expect(model.taxMetadata!.taxExempt, isFalse);
        expect(model.taxMetadata!.observation, 'Retenção municipal');
        expect(model.taxMetadata!.cstCode, '01');
        expect(model.taxMetadata!.cfop, '5933');

        expect(model.taxes, hasLength(1));
        expect(model.taxes.first.taxType, 'ISS');
        expect(model.taxes.first.amount, closeTo(62.53, 0.0001));
      },
    );

    test('supports nested supplier payload from church_finance_api', () {
      final model = AccountsPayableModel.fromJson({
        'accountPayableId':
            'urn:accountPayable:6a4aa8e3-5179-4813-9e34-610a67c776ae',
        'amountPaid': 0,
        'amountPending': 222,
        'amountTotal': 222,
        'taxAmountTotal': 0,
        'churchId': 'd6a20217-36a7-4520-99b3-f9a212191687',
        'createdAt': '2025-11-03T14:51:17.335Z',
        'createdBy': 'Super Adminsitratodor',
        'description': 'Test',
        'installments': [
          {
            'amount': 222,
            'dueDate': '2025-11-30T00:00:00.000Z',
            'installmentId':
                'urn:installment:b6776404-89e8-424f-aa23-4744448d2982',
            'status': 'PENDING',
          },
        ],
        'status': 'PENDING',
        'supplier': {
          'supplierId': 'urn:supplier:987654321',
          'supplierType': 'SUPPLIER',
          'supplierDNI': '987654321',
          'name': 'Proveedor Ejemplo',
          'phone': '555-1234',
        },
        'taxDocument': {
          'type': 'RECEIPT',
          'number': '34635',
          'date': '2025-11-03T00:00:00.000Z',
        },
        'taxMetadata': {'status': 'NOT_APPLICABLE', 'taxExempt': true},
        'updatedAt': '2025-11-03T14:51:17.335Z',
      });

      expect(
        model.accountPayableId,
        'urn:accountPayable:6a4aa8e3-5179-4813-9e34-610a67c776ae',
      );
      expect(model.supplierId, 'urn:supplier:987654321');
      expect(model.supplierName, 'Proveedor Ejemplo');
      expect(model.description, 'Test');
      expect(model.installments, hasLength(1));
      expect(model.installments.first.amount, 222);
      expect(model.installments.first.dueDate, '2025-11-30T00:00:00.000Z');
      expect(model.statusEnum, AccountsPayableStatus.PENDING);
      expect(model.isPaid, isFalse);
      expect(model.amountPending, 222);
      expect(model.amountTotal, 222);
      expect(model.taxAmountTotal, 0.0);
      expect(model.supplier, isNotNull);
      expect(model.supplier!.dni, '987654321');
      expect(model.supplier!.type, 'SUPPLIER');
    });
  });
}
