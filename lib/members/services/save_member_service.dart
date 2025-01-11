import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class SaveMemberService extends AppHttp {
  SaveMemberService({super.tokenAPI});

  Future<void> saveMember(Map<String, dynamic> jsonForm) async {
    try {
      await http.post(
        '${await getUrlApi()}church/member',
        data: jsonForm,
        options: Options(
          headers: getHeader(),
        ),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
