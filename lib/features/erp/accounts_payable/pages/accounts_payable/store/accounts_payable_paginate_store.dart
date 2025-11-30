import 'package:flutter/material.dart';

import '../../../accounts_payable_service.dart';
import '../state/accounts_payable_paginate_state.dart';

class AccountsPayablePaginateStore extends ChangeNotifier {
  var service = AccountsPayableService();
  var state = AccountsPayablePaginateState.empty();

  void setStartDate(String startDate) {
    state = state.copyWith(startDate: startDate);
    notifyListeners();
  }

  void setEndDate(String endDate) {
    state = state.copyWith(endDate: endDate);
    notifyListeners();
  }

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage);
  }

  void nextPage() {
    state = state.copyWith(page: state.filter.page + 1);
  }

  void prevPage() {
    if (state.filter.page > 1) {
      state = state.copyWith(page: state.filter.page - 1);
    }
  }

  void apply() {
    notifyListeners();
    searchAccountsPayable();
  }

  void clearFilters() {
    state = AccountsPayablePaginateState.empty();
    notifyListeners();
    searchAccountsPayable();
  }

  void searchAccountsPayable() {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    service.listAccountsPayable(state.filter).then((value) {
      state = state.copyWith(paginate: value, makeRequest: false);

      notifyListeners();
    }).catchError((e) {
      print("ERRO: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    });
  }
}
