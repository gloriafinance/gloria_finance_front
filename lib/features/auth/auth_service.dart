import 'package:gloria_finance/core/app_http.dart';
import 'package:dio/dio.dart';

import 'auth_session_model.dart';

class AuthService extends AppHttp {
  Future<AuthSessionModel?> makeLogin(Map<String, dynamic> jsonForm) async {
    try {
      final response = await http.post(
        "${await getUrlApi()}user/login",
        data: jsonForm,
      );

      return AuthSessionModel.fromJson(response.data);
    } on DioException catch (e) {
      print("ERR ${e.response?.data}");
      transformResponse(e.response?.data);
      return null;
    }
  }

  Future<bool> recoveryPassword(String email) async {
    try {
      await http.post(
        "${await getUrlApi()}user/recovery-password",
        data: {"email": email},
      );
      return true;
    } on DioException catch (e) {
      print("ERR ${e.response?.data}");
      transformResponse(e.response?.data);
      return false;
    }
  }

  Future<void> changePassword(Map<String, dynamic> jsonForm) async {
    try {
      await http.post(
        "${await getUrlApi()}user/change-password",
        data: jsonForm,
      );
    } on DioException catch (e) {
      print("ERR ${e.response?.data}");
      transformResponse(e.response?.data);
    }
  }
}
