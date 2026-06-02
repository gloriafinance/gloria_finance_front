import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/app_http.dart';
import '../models/member_registration_models.dart';

class MemberRegistrationService extends AppHttp {
  MemberRegistrationService();

  Future<PublicChurchInfo> getChurchInfo(String token) async {
    try {
      final response = await http.get(
        '${await getUrlApi()}public/member-registration/$token',
      );
      return PublicChurchInfo.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<MemberRegistrationResponse> submitRegistration({
    required String token,
    required Map<String, dynamic> fields,
    required Uint8List photoBytes,
    required String photoName,
    required String photoMimeType,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...fields,
        'profilePhoto': MultipartFile.fromBytes(
          photoBytes,
          filename: photoName,
          contentType: DioMediaType.parse(photoMimeType),
        ),
      });

      final response = await http.post(
        '${await getUrlApi()}public/member-registration/$token',
        data: formData,
      );
      return MemberRegistrationResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
