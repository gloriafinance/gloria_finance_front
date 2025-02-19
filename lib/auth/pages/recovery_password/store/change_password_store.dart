import 'package:church_finance_bk/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../state/change_password_state.dart';

class ChangePasswordStore extends ChangeNotifier {
  ChangePasswordState state = ChangePasswordState.init();
  var service = AuthService();

  setNewPassword(String newPassword) {
    state = state.copyWith(newPassword: newPassword);
    notifyListeners();
  }

  setOldPassword(String oldPassword) {
    state = state.copyWith(oldPassword: oldPassword);
    notifyListeners();
  }

  setEmail(String email) {
    state = state.copyWith(email: email);
    notifyListeners();
  }

  Future<bool> changePassword() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await service.changePassword(state.toJson());
      // state = state.copyWith(makeRequest: false);
      // notifyListeners();

      return true;
    } catch (e) {
      // state = state.copyWith(makeRequest: false);
      // notifyListeners();
      return false;
    }
  }
}
