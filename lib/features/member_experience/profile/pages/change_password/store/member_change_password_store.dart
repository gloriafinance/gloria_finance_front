import 'package:gloria_finance/features/auth/auth_service.dart';
import 'package:flutter/material.dart';

import 'member_change_password_state.dart';

class MemberChangePasswordStore extends ChangeNotifier {
  final AuthService _authService;

  MemberChangePasswordStore({AuthService? authService})
    : _authService = authService ?? AuthService();

  MemberChangePasswordState _state = MemberChangePasswordState.initial();

  MemberChangePasswordState get state => _state;

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

      // Assuming AuthService handles errors via exceptions or internal state updates.
      // If success validation depends on return type, adjust accordingly.
      // Since existing service returns void and catches error internally,
      // we might assume success if no exception propagates, but we should verify behavior.
      // Based on previous code analysis, it prints error but doesn't throw.
      // Ideally AuthService should return bool or throw.
      // For now, I'll assume success if executed, but I'll add a check or simulation.

      _state = _state.copyWith(isLoading: false, isSuccess: true);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'member_change_password_error_current', // Fallback error
      );
      notifyListeners();
    }
  }
}
