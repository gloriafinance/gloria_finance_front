import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';

import 'auth_session_model.dart';

class AuthService extends AppHttp {
  Future<AuthSessionModel?> makeLogin(Map<String, dynamic> jsonForm) async {
    try {
      final response = await http.post(
        "${await getUrlApi()}user/login",
        data: jsonForm,
      );

      if (response.data is! Map) {
        return null;
      }

      return AuthSessionModel.fromJson(response.data);
    } on DioException catch (e) {
      print(
        "ERR status=${e.response?.statusCode} data=${e.response?.data} type=${e.type} message=${e.message} error=${e.error}",
      );
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

  Future<AuthSessionModel?> socialLogin({
    required String provider,
    required String idToken,
  }) async {
    try {
      print("************************ ${await getUrlApi()}user/social-login");
      final response = await http.post(
        "${await getUrlApi()}user/social-login",
        data: {"provider": provider, "idToken": idToken},
      );

      if (response.data is! Map) {
        return null;
      }

      return AuthSessionModel.fromJson(response.data);
    } on DioException catch (e) {
      print(
        "ERR status=${e.response?.statusCode} data=${e.response?.data} type=${e.type} message=${e.message} error=${e.error}",
      );
      transformResponse(e.response?.data);
      return null;
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
