import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import '../models/member_registration_link_model.dart';

class MemberRegistrationLinkService extends AppHttp {
  MemberRegistrationLinkService({super.tokenAPI});

  Future<MemberRegistrationLinkModel> getRegistrationLink() async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      final response = await http.get(
        '${await getUrlApi()}church/member/registration-link',
        options: Options(headers: bearerToken()),
      );

      return MemberRegistrationLinkModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
