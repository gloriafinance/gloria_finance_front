import 'package:flutter/material.dart';

import '../monthly_tithes_service.dart';
import '../state/monthly_tithes_list_state.dart';

class MonthlyTithesListStore extends ChangeNotifier {
  var service = MonthlyTithesService();
  MonthlyTithesListState state = MonthlyTithesListState.empty();

  void setChurchId(String churchId) {
    state = state.copyWith(churchId: churchId);
    notifyListeners();
  }

  void setMonth(int month) {
    state = state.copyWith(month: month);
    notifyListeners();
  }

  void setYear(int year) {
    state = state.copyWith(year: year);
    //notifyListeners();
  }

  void clearFilters() {
    state = MonthlyTithesListState.empty();
    notifyListeners();
    searchMonthlyTithes();
  }

  void searchMonthlyTithes() {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      service.searchMonthlyTithes(state.filter).then((value) {
        state = state.copyWith(data: value, makeRequest: false);
        notifyListeners();
      });
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
