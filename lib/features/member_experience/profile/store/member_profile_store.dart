import 'package:flutter/material.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/service/member_profile_service.dart';

class MemberProfileStore extends ChangeNotifier {
  MemberProfileStore._internal();
  static final MemberProfileStore _instance = MemberProfileStore._internal();
  factory MemberProfileStore() => _instance;

  final MemberProfileService _service = MemberProfileService();

  MemberProfileModel? profile;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadProfile(String memberId, {bool refresh = false}) async {
    if (isLoading) return;
    
    // Cache check: return immediately if profile exists and we are not refreshing
    if (!refresh && profile != null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _service.getProfile(memberId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
