import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/service/member_profile_service.dart';

class MemberProfileStore extends ChangeNotifier {
  MemberProfileStore();

  final MemberProfileService _service = MemberProfileService();

  MemberProfileModel? profile;
  bool isLoading = false;
  bool isUploadingPhoto = false;
  String? errorMessage;
  bool _disposed = false;

  Future<void> loadProfile({bool refresh = false}) async {
    if (isLoading) return;
    if (_disposed) return;

    if (!refresh && profile != null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    if (!_disposed) notifyListeners();

    try {
      final result = await _service.getProfile();
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

  Future<bool> updateProfilePhoto({
    required Uint8List photoBytes,
    required String fileName,
    required String mimeType,
  }) async {
    if (isUploadingPhoto || _disposed) return false;

    isUploadingPhoto = true;
    errorMessage = null;
    if (!_disposed) notifyListeners();

    try {
      final profilePhoto = await _service.updateProfilePhoto(
        photoBytes: photoBytes,
        fileName: fileName,
        mimeType: mimeType,
      );

      if (_disposed) return false;

      if (profile != null && profilePhoto.isNotEmpty) {
        profile = profile!.copyWith(profilePhoto: profilePhoto);
      }

      return profilePhoto.isNotEmpty;
    } on DioException {
      return false;
    } catch (e) {
      if (_disposed) return false;
      errorMessage = e.toString();
      return false;
    } finally {
      isUploadingPhoto = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
