import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_error.dart';
import 'package:gloria_finance/features/member_experience/profile/service/member_profile_service.dart';

class MemberProfileStore extends ChangeNotifier {
  MemberProfileStore({MemberProfileService? service})
    : _service = service ?? MemberProfileService();

  final MemberProfileService _service;

  MemberProfileModel? profile;
  bool isLoading = false;
  bool isUploadingPhoto = false;
  String? errorMessage;
  String? photoUpdateErrorCode;
  bool _disposed = false;

  Future<void> loadProfile({bool refresh = false}) async {
    if (isLoading) return;
    if (_disposed) return;

    if (!refresh && profile != null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    photoUpdateErrorCode = null;
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
    photoUpdateErrorCode = null;
    if (!_disposed) notifyListeners();

    try {
      final result = await _service.updateProfilePhoto(
        photoBytes: photoBytes,
        fileName: fileName,
        mimeType: mimeType,
      );

      if (_disposed) return false;

      if (profile != null &&
          result.profilePhoto.isNotEmpty &&
          result.profilePhotoUrl.isNotEmpty) {
        profile = profile!.copyWith(
          profilePhoto: result.profilePhoto,
          profilePhotoUrl: result.profilePhotoUrl,
        );
      }

      return result.profilePhotoUrl.isNotEmpty;
    } on MemberProfilePhotoUpdateError catch (e) {
      if (_disposed) return false;
      photoUpdateErrorCode = e.code;
      errorMessage = e.message;
      return false;
    } catch (e) {
      if (_disposed) return false;
      photoUpdateErrorCode = 'UNKNOWN';
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
