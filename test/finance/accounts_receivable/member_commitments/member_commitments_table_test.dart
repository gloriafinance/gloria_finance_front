import 'package:gloria_finance/core/paginate/paginate_response.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/accounts_receivable_service.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/models/index.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/pages/member_commitments/state/member_commitments_state.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/pages/member_commitments/store/member_commitments_store.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/pages/member_commitments/widgets/member_commitments_table.dart';
import 'package:gloria_finance/features/erp/models/installment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _NoopAccountsReceivableService extends AccountsReceivableService {}

AccountsReceivableModel _commitmentWithInstallments() {
  return AccountsReceivableModel(
    debtor: DebtorModel(
      debtorType: DebtorType.MEMBER.apiValue,
      debtorDNI: '708.608.222-81',
      name: 'Angel Vicente',
      phone: '',
      email: '',
      address: '',
    ),
    churchId: 'd6a20217-36a7-4520-99b3-f9a212191687',
    description: 'Oferta mensal pro terreno',
    installments: [
      InstallmentModel(
        amount: 5,
        dueDate: '2025-12-15T00:00:00.000Z',
        installmentId: 'urn:installment:feb50200-4692-4cae-984a-2e8220e6a613',
        status: 'PENDING',
      ),
      InstallmentModel(
        amount: 5,
        dueDate: '2026-01-15T00:00:00.000Z',
        installmentId: 'urn:installment:4c68d008-b6a7-49de-9c22-e8a73ee2b57f',
        status: 'PAID',
      ),
      InstallmentModel(
        amount: 5,
        dueDate: '2026-02-15T00:00:00.000Z',
        installmentId: 'urn:installment:extra-in-review',
        status: 'IN_REVIEW',
      ),
    ],
    amountPending: 10,
    amountTotal: 10,
    amountPaid: 0,
    accountReceivableId:
        'urn:accountReceivable:2e504ce8-66bb-4fda-80c2-dee781dbd16e',
    status: 'PENDING',
    type: AccountsReceivableType.CONTRIBUTION,
  );
}

void main() {
  testWidgets('renders each installment as a table row', (tester) async {
    final store = MemberCommitmentsStore(
      service: _NoopAccountsReceivableService(),
    );

    store.state = MemberCommitmentsState(
      paginate: PaginateResponse(
        perPage: 10,
        count: 1,
        results: [_commitmentWithInstallments()],
      ),
      filter: const MemberCommitmentFilter(),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MemberCommitmentsStore>.value(value: store),
        ],
        child: const MaterialApp(
          home: Scaffold(body: MemberCommitmentsTable()),
        ),
      ),
    );

    expect(find.text('Oferta mensal pro terreno'), findsNWidgets(3));
    expect(find.text('R\$ 5,00'), findsNWidgets(3));
    expect(find.text('15/12/2025'), findsOneWidget);
    expect(find.text('15/01/2026'), findsOneWidget);
    expect(find.text('15/02/2026'), findsOneWidget);
    expect(find.text('Pendente'), findsOneWidget);
    expect(find.text('Pago'), findsOneWidget);
    expect(find.text('Em revisão'), findsOneWidget);
  });
}
