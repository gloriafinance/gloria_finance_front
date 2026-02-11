import 'package:gloria_finance/features/auth/auth_service.dart';
import 'package:flutter/material.dart';

import 'change_password_state.dart';

class ChangePasswordStore extends ChangeNotifier {
  final AuthService _authService;

  ChangePasswordStore({AuthService? authService})
    : _authService = authService ?? AuthService();

  ChangePasswordState _state = ChangePasswordState.initial();

  ChangePasswordState get state => _state;

  void setCurrentPassword(String value) {
    _state = _state.copyWith(currentPassword: value);
    notifyListeners();
  }

  void setNewPassword(String value) {
    _state = _state.copyWith(newPassword: value);
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _state = _state.copyWith(confirmPassword: value);
    notifyListeners();
  }

  void toggleCurrentPasswordVisibility() {
    _state = _state.copyWith(
      isCurrentPasswordVisible: !_state.isCurrentPasswordVisible,
    );
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _state = _state.copyWith(
      isNewPasswordVisible: !_state.isNewPasswordVisible,
    );
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _state = _state.copyWith(
      isConfirmPasswordVisible: !_state.isConfirmPasswordVisible,
    );
    notifyListeners();
  }

  bool get hasMinLength => _state.newPassword.length >= 8;
  bool get hasUppercase => _state.newPassword.contains(RegExp(r'[A-Z]'));
  bool get hasNumber => _state.newPassword.contains(RegExp(r'[0-9]'));
  bool get passwordsMatch =>
      _state.newPassword.isNotEmpty &&
      _state.newPassword == _state.confirmPassword;

  bool get isValid =>
      hasMinLength &&
      hasUppercase &&
      hasNumber &&
      passwordsMatch &&
      _state.currentPassword.isNotEmpty;

  Future<void> changePassword() async {
    if (!isValid) return;

    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final payload = {
        "oldPassword": _state.currentPassword,
        "newPassword": _state.newPassword,
      };

      await _authService.changePassword(payload);

      _state = _state.copyWith(isLoading: false, isSuccess: true);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'member_change_password_error_current',
      );
      notifyListeners();
    }
  }
}
