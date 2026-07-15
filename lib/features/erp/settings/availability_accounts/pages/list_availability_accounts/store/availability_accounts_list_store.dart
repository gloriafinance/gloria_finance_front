import 'package:flutter/material.dart';

import '../../../models/availability_account_model.dart';
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
        makeRequest: false,
        availabilityAccounts: availabilityAccounts,
      );

      notifyListeners();
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }

  AvailabilityAccountModel? findByAvailabilityAccountId(
    String availabilityAccountId,
  ) {
    for (final account in state.availabilityAccounts) {
      if (account.availabilityAccountId == availabilityAccountId) {
        return account;
      }
    }

    return null;
  }

  Future<bool> deleteAvailabilityAccount(String availabilityAccountId) async {
    state = state.copyWith(deleting: true);
    notifyListeners();

    try {
      await service.deleteAvailabilityAccount(availabilityAccountId);
      await searchAvailabilityAccounts();
      state = state.copyWith(deleting: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(deleting: false);
      notifyListeners();
      return false;
    }
  }
}
