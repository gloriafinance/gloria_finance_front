import 'package:church_finance_bk/features/member_experience/commitments/models/member_commitment_model.dart';
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
}
