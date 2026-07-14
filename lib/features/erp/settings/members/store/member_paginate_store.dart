import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../services/member_deletion_service.dart';
import '../services/member_list_service.dart';
import '../state/member_paginate_state.dart';

class MemberPaginateStore extends ChangeNotifier {
  var service = MemberListService();
  var deletionService = MemberDeletionService();

  MemberPaginateState state = MemberPaginateState.empty();

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage);
    notifyListeners();
    searchMemberList();
  }

  void nextPage() {
    state = state.copyWith(page: state.filter.page + 1);
    notifyListeners();

    searchMemberList();
  }

  void prevPage() {
    if (state.filter.page > 1) {
      state = state.copyWith(page: state.filter.page - 1);
      notifyListeners();

      searchMemberList();
    }
  }

  void apply() {
    notifyListeners();
    searchMemberList();
  }

  Future<void> searchMemberList() async {
    final session = await AuthPersistence().restore();

    state = state.copyWith(makeRequest: true, churchId: session.churchId);
    notifyListeners();

    try {
      final paginate = await service.searchMembers(state.filter);

      state = state.copyWith(makeRequest: false, paginate: paginate);

      notifyListeners();
    } catch (_) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }

  Future<bool> deleteMember(String memberId) async {
    if (state.deleting) return false;

    state = state.copyWith(
      deleting: true,
      deletingMemberId: memberId,
      clearDeleteError: true,
    );
    notifyListeners();

    try {
      await deletionService.deleteMember(memberId);
      state = state.copyWith(deleting: false, clearDeletingMemberId: true);
      notifyListeners();
      await searchMemberList();
      if (state.filter.page > 1 && state.paginate.results.isEmpty) {
        state = state.copyWith(page: state.filter.page - 1);
        notifyListeners();
        await searchMemberList();
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        deleting: false,
        clearDeletingMemberId: true,
        deleteError: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }
}
