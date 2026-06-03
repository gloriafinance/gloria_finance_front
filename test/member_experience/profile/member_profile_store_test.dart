import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_status.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_error.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_result.dart';
import 'package:gloria_finance/features/member_experience/profile/service/member_profile_service.dart';
import 'package:gloria_finance/features/member_experience/profile/store/member_profile_store.dart';

class _StubMemberProfileService extends MemberProfileService {
  MemberProfileModel? profile;
  MemberProfilePhotoUpdateResult? updateResult;
  MemberProfilePhotoUpdateError? updateError;

  bool updateCalled = false;

  _StubMemberProfileService();

  @override
  Future<MemberProfileModel> getProfile() async {
    return profile!;
  }

  @override
  Future<MemberProfilePhotoUpdateResult> updateProfilePhoto({
    required Uint8List photoBytes,
    required String fileName,
    required String mimeType,
  }) async {
    updateCalled = true;
    if (updateError != null) {
      throw updateError!;
    }
    return updateResult!;
  }
}

MemberProfileModel _buildProfile({
  String profilePhoto = '2025/5/old-photo.jpg',
  String profilePhotoUrl = 'https://cdn.example.com/old-photo.jpg',
}) {
  return MemberProfileModel(
    memberId: 'member-1',
    name: 'Ana',
    email: 'ana@example.com',
    phone: '5511999999999',
    dni: '123',
    profilePhoto: profilePhoto,
    profilePhotoUrl: profilePhotoUrl,
    createdAt: '2024-01-01',
    conversionDate: '2024-01-02',
    baptismDate: '2024-01-03',
    birthdate: '1990-01-01',
    church: MemberProfileChurchModel(churchId: 'church-1', name: 'Church'),
    status: MemberStatus.approved,
  );
}

void main() {
  group('MemberProfileStore', () {
    test('updates the local profile photo after a successful upload', () async {
      final service = _StubMemberProfileService()
        ..profile = _buildProfile()
        ..updateResult = const MemberProfilePhotoUpdateResult(
          profilePhoto: '2026/6/new-photo.jpg',
          profilePhotoUrl: 'https://cdn.example.com/new-photo.jpg',
        );

      final store = MemberProfileStore(service: service);
      store.profile = _buildProfile();

      final success = await store.updateProfilePhoto(
        photoBytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'photo.jpg',
        mimeType: 'image/jpeg',
      );

      expect(success, isTrue);
      expect(service.updateCalled, isTrue);
      expect(store.profile?.profilePhoto, '2026/6/new-photo.jpg');
      expect(
        store.profile?.profilePhotoUrl,
        'https://cdn.example.com/new-photo.jpg',
      );
    });

    test('captures the backend code when the upload fails', () async {
      final service = _StubMemberProfileService()
        ..profile = _buildProfile()
        ..updateError = const MemberProfilePhotoUpdateError(
          code: 'PROFILE_PHOTO_TOO_LARGE',
          message: 'Profile photo must be at most 3 MB',
        );

      final store = MemberProfileStore(service: service);
      store.profile = _buildProfile();

      final success = await store.updateProfilePhoto(
        photoBytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'photo.jpg',
        mimeType: 'image/jpeg',
      );

      expect(success, isFalse);
      expect(store.photoUpdateErrorCode, 'PROFILE_PHOTO_TOO_LARGE');
      expect(store.errorMessage, 'Profile photo must be at most 3 MB');
    });
  });
}
