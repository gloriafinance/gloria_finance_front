import 'package:church_finance_bk/settings/availability_accounts/availability_account_service.dart';
import 'package:flutter/material.dart';

import '../state/form_availability_state.dart';

class FormAvailabilityStore extends ChangeNotifier {
  var service = AvailabilityAccountService();
  FormAvailabilityState state = FormAvailabilityState.init();

  void setAccountName(String accountName) {
    state = state.copyWith(accountName: accountName);
    notifyListeners();
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
    notifyListeners();
  }

  void setSymbol(String symbol) {
    state = state.copyWith(symbol: symbol);
    notifyListeners();
  }

  Future<bool> save() async {
    //service.save();
    return true;
  }
}
