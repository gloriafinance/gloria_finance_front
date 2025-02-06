import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

import '../../../purchase_services.dart';
import '../state/purchase_paginate_state.dart';

class PurchasePaginateStore extends ChangeNotifier {
  var service = PurchaseService();

  PurchasePaginateState state = PurchasePaginateState.empty();

  void setStartDate(String startDate) {
    state = state.copyWith(startDate: convertDateFormatToDDMMYYYY(startDate));
    notifyListeners();
  }

  void setEndDate(String endDate) {
    state = state.copyWith(endDate: convertDateFormatToDDMMYYYY(endDate));
    notifyListeners();
  }

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage);
    notifyListeners();
    searchPurchases();
  }

  void nextPage() {
    state = state.copyWith(page: state.filter.page + 1);
    notifyListeners();
    searchPurchases();
  }

  void prevPage() {
    if (state.filter.page > 1) {
      state = state.copyWith(page: state.filter.page - 1);
      notifyListeners();
      searchPurchases();
    }
  }

  void apply() {
    notifyListeners();
    searchPurchases();
  }

  void clearFilters() {
    state = PurchasePaginateState.empty();
    notifyListeners();
    searchPurchases();
  }

  Future<void> searchPurchases() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final paginate = await service.searchPurchases(state.filter);
      
      state = state.copyWith(
        paginate: paginate,
        makeRequest: false,
      );
      notifyListeners();
    } catch (e) {
      print("ERRROR ${e}");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
