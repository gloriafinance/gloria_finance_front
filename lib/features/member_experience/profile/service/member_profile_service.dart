import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:dio/dio.dart';

class MemberProfileService extends AppHttp {
  MemberProfileService({super.tokenAPI});

  Future<MemberProfileModel> getProfile(String memberId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}church/member/$memberId',
        options: Options(headers: bearerToken()),
      );

      return MemberProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
