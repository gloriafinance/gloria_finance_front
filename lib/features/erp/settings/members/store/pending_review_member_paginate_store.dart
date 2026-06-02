import 'package:flutter/material.dart';

import '../services/pending_review_member_service.dart';
import '../state/member_paginate_state.dart';

class PendingReviewMemberPaginateStore extends ChangeNotifier {
  final PendingReviewMemberService service;
  MemberPaginateState state = MemberPaginateState.empty();

  PendingReviewMemberPaginateStore({PendingReviewMemberService? service})
    : service = service ?? PendingReviewMemberService();

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

  Future<void> searchMemberList() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final paginate = await service.searchPendingMembers(state.filter);
      state = state.copyWith(makeRequest: false, paginate: paginate);
      notifyListeners();
    } catch (_) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
