import 'package:flutter/material.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/availability_account_service.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';

import '../state/availability_account_edit_state.dart';

class AvailabilityAccountEditStore extends ChangeNotifier {
  final AvailabilityAccountService service = AvailabilityAccountService();
  AvailabilityAccountEditState state;

  AvailabilityAccountEditStore({required AvailabilityAccountModel account})
    : state = AvailabilityAccountEditState.fromModel(account);

  void setAccountName(String accountName) {
    state = state.copyWith(accountName: accountName.trim());
    notifyListeners();
  }

  void setActive(bool active) {
    state = state.copyWith(active: active);
    notifyListeners();
  }

  Future<bool> send() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await service.updateAvailabilityAccount(
        availabilityAccountId: state.availabilityAccountId,
        payload: {'accountName': state.accountName, 'active': state.active},
      );
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
