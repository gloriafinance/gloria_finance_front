import 'package:flutter/material.dart';

import '../../../availability_account_service.dart';
import '../state/availability_accounts_list_state.dart';

class AvailabilityAccountsListStore extends ChangeNotifier {
  var state = AvailabilityAccountsListState.empty();
  var service = AvailabilityAccountService();

  searchAvailabilityAccounts() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final availabilityAccounts = await service.searchAvailabilityAccounts();
      state = state.copyWith(
          makeRequest: false, availabilityAccounts: availabilityAccounts);

      notifyListeners();
    } catch (e) {
      state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
