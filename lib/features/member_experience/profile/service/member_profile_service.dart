import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
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

  Future<String> updateProfilePhoto({
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
        final profilePhoto = data['profilePhoto']?.toString() ?? '';
        if (profilePhoto.isNotEmpty) {
          return profilePhoto;
        }
        throw StateError(
          'The profilePhoto field is missing from the response.',
        );
      }

      throw StateError('Unexpected response while updating the profile photo.');
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
