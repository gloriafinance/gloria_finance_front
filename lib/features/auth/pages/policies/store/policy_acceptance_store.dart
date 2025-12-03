import 'package:flutter/material.dart';

import '../../../models/policy_acceptance_model.dart';
import '../../../models/policy_config.dart';
import '../service/policy_service.dart';

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
        _errorMessage = 'auth_policies_submit_error_null';
        notifyListeners();
        return null;
      }

      notifyListeners();
      return result;
    } catch (e) {
      print("Error submitting policy acceptance: $e");
      _isSubmitting = false;
      _errorMessage = 'auth_policies_submit_error_generic';
      notifyListeners();
      return null;
    }
  }
}
