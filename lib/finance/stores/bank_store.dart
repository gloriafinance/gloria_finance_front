import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../services/finance_service.dart';
import '../states/bank_state.dart';

class BankStore extends ChangeNotifier {
  var service = FinanceService();
  var state = BankState.empty();

  searchBanks() async {
    final session = await AuthPersistence().restore();

    service.tokenAPI = session.token;
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final banks = await service.searchBank(session.churchId);
      state = state.copyWith(makeRequest: false, banks: banks);

      notifyListeners();
    } catch (e) {
      state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
