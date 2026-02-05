import 'package:gloria_finance/features/erp/settings/availability_accounts/availability_account_service.dart';
import 'package:flutter/material.dart';

import '../state/form_availability_state.dart';

class FormAvailabilityStore extends ChangeNotifier {
  var service = AvailabilityAccountService();
  FormAvailabilityState state = FormAvailabilityState.init();

  void setAccountName(String accountName) {
    state = state.copyWith(accountName: accountName);
    //notifyListeners();
  }

  void setAccountType(String accountType) {
    state = state.copyWith(accountType: accountType);
    notifyListeners();
  }

  void setSource(dynamic source) {
    state = state.copyWith(source: source);
    notifyListeners();
  }

  void setBalance(double balance) {
    state = state.copyWith(balance: balance);
    //notifyListeners();
  }

  void setActive(bool active) {
    state = state.copyWith(active: active);
    notifyListeners();
  }

  void setSymbol(String symbol) {
    state = state.copyWith(symbol: symbol);
    notifyListeners();
  }

  Future<bool> send() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();
    try {
      await service.saveAvailabilityAccount(state.toJson());
      state = state.copyWith(makeRequest: false);
      notifyListeners();

      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
