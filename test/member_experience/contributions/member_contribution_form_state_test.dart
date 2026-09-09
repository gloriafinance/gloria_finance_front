import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:gloria_finance/features/member_experience/contributions/state/member_contribution_form_state.dart';

void main() {
  group('MemberContributionFormState', () {
    test('manual contribution is valid without a destination', () {
      final state = MemberContributionFormState(
        amount: 60,
        paidAt: DateTime(2026, 9, 9),
        receiptLocalPath: 'receipt.jpg',
      );

      expect(state.selectedDestinationId, isNull);
      expect(state.isValid, isTrue);
    });

    test('offering still requires a financial concept', () {
      final state = MemberContributionFormState(
        selectedType: MemberContributionType.offering,
        amount: 60,
        paidAt: DateTime(2026, 9, 9),
        receiptLocalPath: 'receipt.jpg',
      );

      expect(state.isValid, isFalse);
    });
  });

  group('MemberContributionRequest', () {
    test('does not serialize destination when it is not provided', () {
      final request = MemberContributionRequest(
        type: MemberContributionType.tithe,
        amount: 60,
        channel: MemberPaymentChannel.externalWithReceipt,
        paidAt: DateTime(2026, 9, 9),
      );

      expect(request.toJson().containsKey('destinationId'), isFalse);
    });
  });
}
