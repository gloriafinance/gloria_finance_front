import 'package:church_finance_bk/features/erp/accounts_receivable/pages/accounts_receivable/state/accounts_receivable_paginate_state.dart';
import 'package:flutter/material.dart';

import '../../../accounts_receivable_service.dart';
import '../../../models/index.dart';

class AccountsReceivableStore extends ChangeNotifier {
  var service = AccountsReceivableService();
  var state = AccountsReceivablePaginateState.empty();

  void setStatus(String status) {
    final v = AccountsReceivableStatus.values.firstWhere(
      (e) => e.friendlyName == status,
    );
    state = state.copyWith(status: v.toString().split('.').last);
    notifyListeners();
  }

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
    searchAccountsReceivable();
  }

  void clearFilters() {
    state = AccountsReceivablePaginateState.empty();
    notifyListeners();
    searchAccountsReceivable();
  }

  void searchAccountsReceivable() {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    service
        .listAccountsReceivable(state.filter)
        .then((value) {
          state = state.copyWith(paginate: value, makeRequest: false);

          notifyListeners();
        })
        .catchError((e) {
          print("Error searchAccountsReceivable: $e");
          state = state.copyWith(makeRequest: false);
          // Handle error
          notifyListeners();
        });
  }
}
