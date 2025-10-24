import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_tax.dart';
import 'package:church_finance_bk/finance/accounts_payable/pages/register_accounts_payable/state/form_accounts_payable_state.dart';
import 'package:church_finance_bk/finance/models/installment_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormAccountsPayableState.toJson', () {
    test('builds payload for single payment', () {
      final state = FormAccountsPayableState.init().copyWith(
        supplierId: 'supplier-1',
        supplierName: 'Fornecedor 1',
        description: 'Conta de energia',
        paymentMode: AccountsPayablePaymentMode.single,
        totalAmount: 1200.50,
        singleDueDate: '15/09/2024',
      );

      final payload = state.toJson();

      expect(payload['supplierId'], 'supplier-1');
      expect(payload['description'], 'Conta de energia');
      expect(payload['amountTotal'], 1200.50);

      final installments = payload['installments'] as List<dynamic>;
      expect(installments, hasLength(1));
      expect(installments.first['amount'], 1200.50);
      expect(installments.first['dueDate'], '2024-09-15');

      final taxMetadata = payload['taxMetadata'] as Map<String, dynamic>;
      expect(taxMetadata['status'], 'NOT_APPLICABLE');
      expect(taxMetadata['taxExempt'], isTrue);
    });

    test('builds payload for manual installments', () {
      final state = FormAccountsPayableState.init().copyWith(
        supplierId: 'supplier-2',
        description: 'Serviços eventuais',
        paymentMode: AccountsPayablePaymentMode.manual,
        installments: [
          InstallmentModel(amount: 300, dueDate: '01/10/2024'),
          InstallmentModel(amount: 450.75, dueDate: '01/11/2024'),
        ],
      );

      final payload = state.toJson();
      final installments = payload['installments'] as List<dynamic>;

      expect(payload['amountTotal'], closeTo(750.75, 0.0001));
      expect(installments, hasLength(2));
      expect(installments.first['amount'], 300);
      expect(installments.first['dueDate'], '2024-10-01');
    });

    test('builds payload for automatic installments', () {
      final state = FormAccountsPayableState.init().copyWith(
        supplierId: 'supplier-3',
        description: 'Compra de equipamentos',
        paymentMode: AccountsPayablePaymentMode.automatic,
        automaticInstallments: 3,
        automaticFirstDueDate: '10/01/2025',
        automaticInstallmentAmount: 500,
        installments: [
          InstallmentModel(amount: 500, dueDate: '10/01/2025'),
          InstallmentModel(amount: 500, dueDate: '10/02/2025'),
          InstallmentModel(amount: 500, dueDate: '10/03/2025'),
        ],
      );

      final payload = state.toJson();
      final installments = payload['installments'] as List<dynamic>;

      expect(payload['amountTotal'], 1500);
      expect(installments, hasLength(3));
      expect(installments.first['dueDate'], '2025-01-10');
      expect(installments.last['dueDate'], '2025-03-10');
    });

    test('includes document metadata when requested', () {
      final state = FormAccountsPayableState.init().copyWith(
        supplierId: 'supplier-4',
        description: 'Manutenção elétrica',
        paymentMode: AccountsPayablePaymentMode.single,
        totalAmount: 2500,
        singleDueDate: '20/09/2024',
        includeDocument: true,
        documentType: AccountsPayableDocumentType.invoice,
        documentNumber: 'NF-9988',
        documentIssueDate: '15/09/2024',
      );

      final payload = state.toJson();
      expect(payload['document'], isNotNull);

      final document = payload['document'] as Map<String, dynamic>;
      expect(document['type'], 'INVOICE');
      expect(document['number'], 'NF-9988');
      expect(document['issueDate'], '2024-09-15');
    });

    test('includes tax metadata and lines when nota is not exempt', () {
      final state = FormAccountsPayableState.init().copyWith(
        supplierId: 'supplier-5',
        description: 'Serviço tributado',
        paymentMode: AccountsPayablePaymentMode.manual,
        installments: [
          InstallmentModel(amount: 1000, dueDate: '01/12/2024'),
        ],
        taxStatus: AccountsPayableTaxStatus.taxed,
        taxExempt: false,
        taxes: const [
          AccountsPayableTaxLine(
            taxType: 'ISS',
            percentage: 5,
            amount: 50,
            status: AccountsPayableTaxStatus.taxed,
          ),
        ],
        taxObservation: 'Retenção municipal',
        taxCstCode: '01',
        taxCfop: '5933',
      );

      final payload = state.toJson();

      final taxMetadata = payload['taxMetadata'] as Map<String, dynamic>;
      expect(taxMetadata['status'], 'TAXED');
      expect(taxMetadata['taxExempt'], isFalse);
      expect(taxMetadata['observation'], 'Retenção municipal');
      expect(taxMetadata['cstCode'], '01');
      expect(taxMetadata['cfop'], '5933');

      final taxes = payload['taxes'] as List<dynamic>;
      expect(taxes, hasLength(1));
      expect(taxes.first['taxType'], 'ISS');
      expect(taxes.first['percentage'], 5);
      expect(taxes.first['amount'], 50);
      expect(taxes.first['status'], 'TAXED');
    });
  });
}
