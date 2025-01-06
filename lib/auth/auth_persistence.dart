import 'dart:convert';

import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPersistence {
  save(AuthSessionModel session) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('session', jsonEncode(session.toJson()));
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('session');
  }

  Future<AuthSessionModel> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.getString('session');

    if (session != null) {
      return AuthSessionModel.fromJson(jsonDecode(session));
    }

    return AuthSessionModel.empty();
  }
}
