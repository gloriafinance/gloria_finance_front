import 'package:flutter/material.dart';

import '../bank_service.dart';
import '../models/bank_model.dart';
import '../state/bank_state.dart';

class BankStore extends ChangeNotifier {
  var service = BankService();
  var state = BankState.empty();

  getBankName(String bankId) {
    return state.banks.firstWhere((element) => element.bankId == bankId).name;
  }

  BankModel? findByBankId(String bankId) {
    try {
      return state.banks.firstWhere((element) => element.bankId == bankId);
    } catch (e) {
      return null;
    }
  }

  searchBanks() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final banks = await service.searchBank();
      state = state.copyWith(makeRequest: false, banks: banks);

      notifyListeners();
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
