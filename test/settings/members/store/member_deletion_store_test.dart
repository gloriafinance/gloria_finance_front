import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/core/paginate/paginate_response.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/erp/settings/members/services/member_deletion_service.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_filter_model.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_status.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_detail_store.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_paginate_store.dart';
import 'package:gloria_finance/features/erp/settings/members/services/member_list_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

MemberModel _member({required String memberId, required String name}) {
  return MemberModel(
    memberId: memberId,
    name: name,
    email: '$memberId@example.com',
    phone: '5511999999999',
    dni: '00000000000',
    conversionDate: '01/01/2024',
    baptismDate: null,
    birthdate: '01/01/1990',
    isMinister: false,
    isTreasurer: false,
    status: MemberStatus.approved,
    address: '',
  );
}

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

class _FakeMemberListService extends MemberListService {
  _FakeMemberListService();

  final requestedPages = <int>[];

  @override
  Future<PaginateResponse<MemberModel>> searchMembers(
    MemberFilterModel params,
  ) async {
    requestedPages.add(params.page);

    if (params.page == 1) {
      return PaginateResponse<MemberModel>(
        nextPag: false,
        count: 1,
        results: [_member(memberId: 'member-1', name: 'Member 1')],
        perPage: params.perPage,
      );
    }

    return PaginateResponse<MemberModel>(
      nextPag: false,
      count: 1,
      results: const [],
      perPage: params.perPage,
    );
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
      'detail store keeps the loaded member visible on delete failure',
      () async {
        final deletionService = _FakeMemberDeletionService(
          error: StateError('forbidden'),
        );
        final initialMember = _member(memberId: 'member-1', name: 'Member 1');
        final store = MemberDetailStore(
          memberId: 'member-1',
          initialMember: initialMember,
          deletionService: deletionService,
        );

        final deleted = await store.delete();

        expect(deleted, isFalse);
        expect(store.state.deleting, isFalse);
        expect(store.state.member, same(initialMember));
        expect(store.state.error, isNull);
        expect(store.state.deleteError, contains('forbidden'));
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

    test(
      'paginate store rewinds to the previous page when deletion empties an out-of-range page',
      () async {
        SharedPreferences.setMockInitialValues({
          'session': jsonEncode(
            AuthSessionModel(
              token: 'token',
              refreshToken: 'refresh',
              name: 'User',
              email: 'user@example.com',
              createdAt: '2024-01-01T00:00:00.000Z',
              isActive: true,
              userId: 'user-1',
              churchId: 'church-1',
              roles: const ['ADMIN'],
            ).toJson(),
          ),
        });

        final listService = _FakeMemberListService();
        final deletionService = _FakeMemberDeletionService();
        final store =
            MemberPaginateStore()
              ..service = listService
              ..deletionService = deletionService;

        store.state = store.state.copyWith(
          page: 2,
          perPage: 20,
          churchId: 'church-1',
        );

        final deleted = await store.deleteMember('member-1');

        expect(deleted, isTrue);
        expect(listService.requestedPages, [2, 1]);
        expect(store.state.filter.page, 1);
        expect(store.state.paginate.results, hasLength(1));
      },
    );
  });
}
