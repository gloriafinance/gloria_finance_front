import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class AuthService extends AppHttp {
  Future<AuthSessionModel?> makeLogin(String email, String password) async {
    try {
      final response = await http.post("${await getUrlApi()}admin/user/login",
          data: {'email': email, 'password': password});

      return AuthSessionModel.fromJson(response.data);
    } on DioException catch (e) {
      print("ERR ${e.response?.data}");
      transformResponse(e.response?.data);
      return null;
    }
  }
}
