import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_error.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_result.dart';
import 'package:flutter/foundation.dart';

class MemberProfileService extends AppHttp {
  MemberProfileService({super.tokenAPI});

  Future<MemberProfileModel> getProfile() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}member/profile',
        options: Options(headers: bearerToken()),
      );

      return MemberProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<MemberProfilePhotoUpdateResult> updateProfilePhoto({
    required Uint8List photoBytes,
    required String fileName,
    required String mimeType,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final formData = FormData.fromMap({
        'profilePhoto': MultipartFile.fromBytes(
          photoBytes,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await http.patch(
        '${await getUrlApi()}member/profile/photo',
        data: formData,
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return MemberProfilePhotoUpdateResult.fromJson(data);
      }

      throw StateError('Unexpected response while updating the profile photo.');
    } on DioException catch (e) {
      throw _parsePhotoUpdateError(e.response?.data);
    }
  }

  MemberProfilePhotoUpdateError _parsePhotoUpdateError(dynamic data) {
    if (data is Map) {
      final payload = Map<String, dynamic>.from(data);
      final code = payload['code']?.toString() ?? 'UNKNOWN';
      final message = payload['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return MemberProfilePhotoUpdateError(code: code, message: message);
      }

      for (final entry in payload.entries) {
        final value = entry.value;
        if (value is Map && value['message'] != null) {
          return MemberProfilePhotoUpdateError(
            code: entry.key.toString(),
            message: value['message'].toString(),
          );
        }
      }
    }

    return const MemberProfilePhotoUpdateError(
      code: 'UNKNOWN',
      message: 'We could not update your photo. Please try again.',
    );
  }
}
