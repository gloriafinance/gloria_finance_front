import 'package:flutter/material.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/service/member_profile_service.dart';

class MemberProfileStore extends ChangeNotifier {
  MemberProfileStore();

  final MemberProfileService _service = MemberProfileService();

  MemberProfileModel? profile;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;

  Future<void> loadProfile(String memberId, {bool refresh = false}) async {
    if (isLoading) return;
    if (_disposed) return;

    if (!refresh && profile != null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    if (!_disposed) notifyListeners();

    try {
      final result = await _service.getProfile(memberId);
      if (_disposed) return;
      profile = result;
    } catch (e) {
      if (_disposed) return;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
