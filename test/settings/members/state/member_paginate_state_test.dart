import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/members/state/member_paginate_state.dart';

void main() {
  group('MemberPaginateState', () {
    test('clears the deleting member id explicitly', () {
      final deletingState = MemberPaginateState.empty().copyWith(
        deleting: true,
        deletingMemberId: 'member-1',
      );

      final completedState = deletingState.copyWith(
        deleting: false,
        clearDeletingMemberId: true,
      );

      expect(completedState.deleting, isFalse);
      expect(completedState.deletingMemberId, isNull);
    });
  });
}
