import 'package:church_finance_bk/finance/accounts_receivable/accounts_receivable_service.dart';
import 'package:church_finance_bk/finance/accounts_receivable/models/index.dart';
import 'package:church_finance_bk/finance/accounts_receivable/pages/member_commitments/store/member_commitments_store.dart';
import 'package:church_finance_bk/finance/accounts_receivable/pages/member_commitments/store/payment_declaration_store.dart';
import 'package:church_finance_bk/finance/models/installment_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class _FakeAccountsReceivableService extends AccountsReceivableService {
  PaginateResponse<AccountsReceivableModel>? response;
  MemberCommitmentFilter? lastFilter;
  int calls = 0;

  @override
  Future<PaginateResponse<AccountsReceivableModel>> listMemberCommitments(
    MemberCommitmentFilter filter,
  ) async {
    calls++;
    lastFilter = filter;
    return response!;
  }
}

class _CapturingService extends AccountsReceivableService {
  PaymentDeclarationModel? captured;
  bool throwValidation = false;

  @override
  Future<void> declareMemberPayment(PaymentDeclarationModel declaration) async {
    if (throwValidation) {
      throw DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'amount': ['Valor inválido'],
          },
        ),
        type: DioExceptionType.badResponse,
      );
    }

    captured = declaration;
  }
}

AccountsReceivableModel _sampleCommitment({String status = 'PENDING'}) {
  return AccountsReceivableModel(
    debtor: DebtorModel(
      debtorType: DebtorType.MEMBER.apiValue,
      debtorDNI: '12345678900',
      name: 'Maria',
      phone: '',
      email: '',
      address: 'Rua A',
    ),
    churchId: 'church-1',
    description: 'Curso de música',
    installments: [
      InstallmentModel(
        amount: 120,
        dueDate: '2024-11-20',
        installmentId: 'ins-1',
        sequence: 1,
        status: 'PENDING',
      ),
    ],
    amountPending: 120,
    amountTotal: 120,
    amountPaid: 0,
    accountReceivableId: 'ar-1',
    status: status,
    type: AccountsReceivableType.CONTRIBUTION,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MemberCommitmentsStore', () {
    test('fetchCommitments loads data and tracks filter', () async {
      final fakeService = _FakeAccountsReceivableService();
      fakeService.response = PaginateResponse(
        perPage: 10,
        count: 1,
        results: [_sampleCommitment()],
      );

      final store = MemberCommitmentsStore(
        debtorDNI: '12345678900',
        service: fakeService,
      );

      await store.fetchCommitments();

      expect(store.state.paginate.results.length, 1);
      expect(fakeService.calls, 1);
      expect(fakeService.lastFilter?.debtorDNI, '12345678900');
      expect(fakeService.lastFilter?.status, isNull);
    });

    test('setStatusFilter persists selection and triggers fetch', () async {
      final fakeService = _FakeAccountsReceivableService();
      fakeService.response = PaginateResponse(
        perPage: 10,
        count: 0,
        results: [],
      );

      final store = MemberCommitmentsStore(
        debtorDNI: '999',
        service: fakeService,
      );

      store.setStatusFilter(AccountsReceivableStatus.PAID);

      expect(store.state.filter.status, AccountsReceivableStatus.PAID);
      expect(fakeService.calls, 1);
      expect(fakeService.lastFilter?.status, AccountsReceivableStatus.PAID);
    });
  });

  group('PaymentDeclarationStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('submit sends payload when data is valid', () async {
      final service = _CapturingService();
      final store = PaymentDeclarationStore(service: service, showToast: false);

      store.setAvailabilityAccount('acc-1');
      store.setAmount(150);

      final commitment = _sampleCommitment();
      final installment = commitment.installments.first;

      final result = await store.submit(commitment, installment);

      expect(result, isTrue);
      expect(service.captured, isNotNull);
      expect(service.captured?.availabilityAccountId, 'acc-1');
      expect(service.captured?.installmentId, installment.installmentId);
      expect(service.captured?.accountReceivableId, commitment.accountReceivableId);
      expect(service.captured?.amount, 150);
    });

    test('handles validation errors from backend', () async {
      final service = _CapturingService()..throwValidation = true;
      final store = PaymentDeclarationStore(service: service, showToast: false);

      store.setAvailabilityAccount('acc-1');
      store.setAmount(50);

      final commitment = _sampleCommitment();
      final installment = commitment.installments.first;

      final result = await store.submit(commitment, installment);

      expect(result, isFalse);
      expect(store.state.validationErrors['amount'], 'Valor inválido');
      expect(store.state.errorMessage, contains('Valor inválido'));
    });
  });
}
