import 'package:church_finance_bk/auth/models/policy_acceptance_model.dart';
import 'package:church_finance_bk/auth/models/policy_config.dart';
import 'package:church_finance_bk/auth/pages/policies/service/policy_service.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';

class PolicyAcceptanceStore extends ChangeNotifier {
  bool _privacyPolicyAccepted = false;
  bool _sensitiveDataPolicyAccepted = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get privacyPolicyAccepted => _privacyPolicyAccepted;
  bool get sensitiveDataPolicyAccepted => _sensitiveDataPolicyAccepted;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  /// Check if both policies are accepted (checkboxes checked)
  bool get canSubmit =>
      _privacyPolicyAccepted && _sensitiveDataPolicyAccepted && !_isSubmitting;

  void setPrivacyPolicyAccepted(bool value) {
    _privacyPolicyAccepted = value;
    notifyListeners();
  }

  void setSensitiveDataPolicyAccepted(bool value) {
    _sensitiveDataPolicyAccepted = value;
    notifyListeners();
  }

  void reset() {
    _privacyPolicyAccepted = false;
    _sensitiveDataPolicyAccepted = false;
    _isSubmitting = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Submit policy acceptance to backend
  Future<PolicyAcceptanceModel?> submitAcceptance(String token) async {
    if (!canSubmit) return null;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final service = PolicyService(tokenAPI: token);
      final result = await service.acceptPolicies(
        privacyPolicyVersion: PolicyConfig.privacyPolicyVersion,
        sensitiveDataPolicyVersion: PolicyConfig.sensitiveDataPolicyVersion,
      );

      _isSubmitting = false;

      if (result == null) {
        _errorMessage = 'Não foi possível registrar o aceite. Tente novamente.';
        notifyListeners();
        return null;
      }

      notifyListeners();
      return result;
    } catch (e) {
      print("Error submitting policy acceptance: $e");
      _isSubmitting = false;
      _errorMessage =
          'Ocorreu um erro ao registrar o aceite. Tente novamente.';
      Toast.showMessage(_errorMessage!, ToastType.warning);
      notifyListeners();
      return null;
    }
  }
}
