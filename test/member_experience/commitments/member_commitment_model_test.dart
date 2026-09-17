import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:gloria_finance/features/member_experience/commitments/service/member_commitment_service.dart';
import 'package:gloria_finance/features/member_experience/commitments/store/member_commitment_pix_payment_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MemberCommitmentInstallment buildInstallment(
    String id,
    String status, {
    DateTime? dueDate,
  }) {
    return MemberCommitmentInstallment(
      installmentId: id,
      amount: 10,
      amountPaid: null,
      amountPending: null,
      dueDate: dueDate ?? DateTime(2025, 1, int.parse(id)),
      paymentDate: null,
      status: status,
    );
  }

  group('MemberCommitmentModel.nextInstallment', () {
    test('skips installments that are under review', () {
      final commitment = MemberCommitmentModel(
        accountReceivableId: 'ar_1',
        description: 'Commitment',
        amountTotal: 30,
        amountPaid: 0,
        amountPending: 30,
        status: MemberCommitmentStatus.pending,
        installments: [
          buildInstallment('1', 'IN_REVIEW'),
          buildInstallment('2', 'PENDING'),
          buildInstallment('3', 'PENDING'),
        ],
        availabilityAccountId: null,
      );

      expect(commitment.nextInstallment?.installmentId, '2');
    });

    test('returns null when every installment is paid or under review', () {
      final commitment = MemberCommitmentModel(
        accountReceivableId: 'ar_2',
        description: 'Commitment',
        amountTotal: 20,
        amountPaid: 20,
        amountPending: 0,
        status: MemberCommitmentStatus.pending,
        installments: [
          buildInstallment('1', 'PAID'),
          buildInstallment('2', 'IN_REVIEW'),
        ],
        availabilityAccountId: null,
      );

      expect(commitment.nextInstallment, isNull);
    });
  });

  group('MemberCommitmentInstallment.canBePaid', () {
    test('is false when installment is under review', () {
      final installment = buildInstallment('1', 'IN_REVIEW');
      expect(installment.canBePaid, isFalse);
    });

    test('is true when installment is pending payment', () {
      final installment = buildInstallment('2', 'PENDING');
      expect(installment.canBePaid, isTrue);
    });
  });

  group('MemberCommitmentPixPayment', () {
    test(
      'parses authoritative cent values, optional pix and unknown status',
      () {
        final payment = MemberCommitmentPixPayment.fromJson({
          'paymentId': 'pay_1',
          'status': 'BANKING_REVIEW',
          'principalAmountInCents': 15000,
          'transactionFeeInCents': 0,
          'platformFeeInCents': 125,
          'chargeAmountInCents': 15000,
          'pix': {
            'copyPaste': 'pix-code',
            'encodedImage': 'base64-image',
            'expirationDate': '2026-09-17T12:00:00Z',
          },
        });

        expect(payment.paymentId, 'pay_1');
        expect(payment.status, 'BANKING_REVIEW');
        expect(payment.principalAmountInCents, 15000);
        expect(payment.transactionFeeInCents, 0);
        expect(payment.platformFeeInCents, 125);
        expect(payment.chargeAmountInCents, 15000);
        expect(payment.principalAmount, 150);
        expect(payment.transactionFee, 0);
        expect(payment.chargeAmount, 150);
        expect(payment.copyPaste, 'pix-code');
        expect(payment.encodedImage, 'base64-image');
        expect(payment.expirationDate, isNotNull);
      },
    );
  });

  test('PIX store sends installment id and remaining amount', () async {
    final installment = MemberCommitmentInstallment(
      installmentId: 'installment_1',
      amount: 150,
      amountPaid: 25,
      amountPending: 125,
      dueDate: DateTime(2026, 9, 17),
      status: 'PENDING',
    );
    final service = _FakeCommitmentService();
    final store = MemberCommitmentPixPaymentStore(
      installment,
      service: service,
    );

    expect(await store.createPayment(), isTrue);
    expect(service.installmentId, 'installment_1');
    expect(service.amount, 125);
    expect(store.status, MemberCommitmentPixPaymentUiStatus.waiting);
  });
}

class _FakeCommitmentService extends MemberCommitmentService {
  String? installmentId;
  double? amount;

  @override
  Future<MemberCommitmentPixPayment> createPixPayment({
    required String installmentId,
    required double amount,
  }) async {
    this.installmentId = installmentId;
    this.amount = amount;
    return const MemberCommitmentPixPayment(
      paymentId: 'pay_1',
      status: 'CREATED',
      principalAmountInCents: 12500,
      transactionFeeInCents: 0,
      platformFeeInCents: 0,
      chargeAmountInCents: 12500,
      copyPaste: 'pix-code',
    );
  }
}
