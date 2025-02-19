import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../services/member_list_service.dart';
import '../state/member_paginate_state.dart';

class MemberPaginateStore extends ChangeNotifier {
  var service = MemberListService();

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

    service.tokenAPI = session.token;

    try {
      final paginate = await service.searchMembers(state.filter);

      state = state.copyWith(makeRequest: false, paginate: paginate);

      notifyListeners();
    } catch (e) {
      print("ERRROR ${e}");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
