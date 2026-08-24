import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/core/uploads/raw_photo_upload.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_error.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_photo_update_result.dart';
import 'package:image_picker/image_picker.dart';

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
    required XFile photo,
    required String mimeType,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final uploadUrl = '${await getUrlApi()}member/profile/photo';
      final data =
          kIsWeb
              ? await uploadRawPhotoOnWeb(
                photo: photo,
                url: Uri.parse(uploadUrl),
                method: 'PATCH',
                mimeType: mimeType,
                headers: bearerToken(),
              )
              : (await http.patch(
                uploadUrl,
                data: photo.openRead(),
                options: Options(contentType: mimeType, headers: bearerToken()),
              )).data;
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
