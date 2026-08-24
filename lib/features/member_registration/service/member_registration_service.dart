import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/app_http.dart';
import '../../../core/uploads/raw_photo_upload.dart';
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
    required XFile photo,
    required String photoMimeType,
  }) async {
    try {
      final uploadUrl =
          '${await getUrlApi()}public/member-registration/$token/photo';
      final uploadPayload =
          kIsWeb
              ? await uploadRawPhotoOnWeb(
                photo: photo,
                url: Uri.parse(uploadUrl),
                method: 'POST',
                mimeType: photoMimeType,
              )
              : Map<String, dynamic>.from(
                (await http.post(
                      uploadUrl,
                      data: photo.openRead(),
                      options: Options(contentType: photoMimeType),
                    )).data
                    as Map,
              );
      final receipt = uploadPayload['profilePhotoUploadReceipt'] as String?;
      if (receipt == null || receipt.isEmpty) {
        throw StateError('Missing profile photo upload receipt.');
      }

      final response = await http.post(
        '${await getUrlApi()}public/member-registration/$token',
        data: {...fields, 'profilePhotoUploadReceipt': receipt},
      );
      return MemberRegistrationResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
