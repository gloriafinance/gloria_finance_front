import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/members/services/member_deletion_service.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_detail_store.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_paginate_store.dart';

class _FakeMemberDeletionService extends MemberDeletionService {
  _FakeMemberDeletionService({this.error});

  final Object? error;
  final deletedMemberIds = <String>[];

  @override
  Future<void> deleteMember(String memberId) async {
    deletedMemberIds.add(memberId);
    if (error != null) throw error!;
  }
}

void main() {
  group('member deletion stores', () {
    test(
      'detail store clears deleting state after a successful deletion',
      () async {
        final deletionService = _FakeMemberDeletionService();
        final store = MemberDetailStore(
          memberId: 'member-1',
          deletionService: deletionService,
        );

        final deleted = await store.delete();

        expect(deleted, isTrue);
        expect(store.state.deleting, isFalse);
        expect(deletionService.deletedMemberIds, ['member-1']);
      },
    );

    test(
      'paginate store preserves the list and exposes deletion errors',
      () async {
        final deletionService = _FakeMemberDeletionService(
          error: StateError('forbidden'),
        );
        final store = MemberPaginateStore()..deletionService = deletionService;

        final deleted = await store.deleteMember('member-1');

        expect(deleted, isFalse);
        expect(store.state.deleting, isFalse);
        expect(store.state.deletingMemberId, isNull);
        expect(store.state.deleteError, contains('forbidden'));
      },
    );
  });
}
