import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class SaveMemberService extends AppHttp {
  SaveMemberService({super.tokenAPI});

  Future<void> saveMember(Map<String, dynamic> jsonForm) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}church/member',
        data: jsonForm,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
