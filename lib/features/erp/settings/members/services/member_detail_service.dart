import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import '../models/member_model.dart';

class MemberDetailService extends AppHttp {
  MemberDetailService({super.tokenAPI});

  Future<MemberModel> getMember(String memberId) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      final response = await http.get(
        '${await getUrlApi()}church/member/$memberId',
        options: Options(headers: bearerToken()),
      );

      return MemberModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
