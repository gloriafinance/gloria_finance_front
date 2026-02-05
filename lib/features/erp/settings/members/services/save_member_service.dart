import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

class SaveMemberService extends AppHttp {
  SaveMemberService({super.tokenAPI});

  Future<void> saveMember(Map<String, dynamic> jsonForm) async {
    final session = await AuthPersistence().restore();

    tokenAPI = session.token;
    jsonForm['churchId'] = session.churchId;

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
