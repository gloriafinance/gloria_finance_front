import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/state/availability_accounts_list_state.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:church_finance_bk/features/erp/accounts_receivable/models/debtor_model.dart';
import 'package:church_finance_bk/features/erp/accounts_receivable/pages/member_commitments/widgets/payment_declaration_form.dart';
import 'package:church_finance_bk/features/erp/models/installment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('PaymentDeclarationForm', () {
    testWidgets('renders form with commitment and installment data', (
      tester,
    ) async {
      final availabilityStore = AvailabilityAccountsListStore();
      availabilityStore.state = AvailabilityAccountsListState(
        makeRequest: false,
        availabilityAccounts: [
          AvailabilityAccountModel(
            churchId: 'church-1',
            availabilityAccountId: 'acc-1',
            accountName: 'Conta Principal',
            balance: 100,
            active: true,
            accountType: 'BANK',
            source: {},
            symbol: 'R\$',
          ),
        ],
      );

      final installment = InstallmentModel(
        amount: 25,
        dueDate: '2025-12-15T00:00:00.000Z',
        installmentId: 'urn:installment:1',
        status: InstallmentsStatus.PENDING.apiValue,
      );

      final commitment = AccountsReceivableModel(
        debtor: DebtorModel(
          debtorType: DebtorType.MEMBER.apiValue,
          debtorDNI: '123',
          name: 'Member',
          phone: '',
          email: '',
          address: '',
        ),
        churchId: 'church-1',
        description: 'Oferta mensal',
        installments: [installment],
        type: AccountsReceivableType.CONTRIBUTION,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [ChangeNotifierProvider.value(value: availabilityStore)],
          child: MaterialApp(
            home: Scaffold(
              body: PaymentDeclarationForm(
                commitment: commitment,
                installment: installment,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the form renders without errors
      expect(tester.takeException(), isNull);

      // Verify key elements are present
      expect(find.byType(PaymentDeclarationForm), findsOneWidget);
    });
  });
}
