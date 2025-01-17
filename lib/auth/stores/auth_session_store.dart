import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';

import '../auth_persistence.dart';
import '../auth_service.dart';
import '../auth_session_model.dart';
import '../states/auth_session_state.dart';

class AuthSessionStore extends ChangeNotifier {
  AuthSessionState state = AuthSessionState(
    session: AuthSessionModel.empty(),
    makeRequest: false,
  );
  var service = AuthService();

  AuthSessionStore() {
    _initialize();
  }

  Future<void> _initialize() async {
    var session = await AuthPersistence().restore();
    state = state.copyWith(
      session: session,
    );

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      var session = await service.makeLogin(email, password);

      if (session == null) {
        state = state.copyWith(makeRequest: false);
        notifyListeners();
        return false;
      }

      state = state.copyWith(
        session: session,
        makeRequest: false,
      );

      await AuthPersistence().save(session);

      notifyListeners();

      return true;
    } catch (e) {
      Toast.showMessage(
          "Ocorreu um erro interno no sistema, informe ao administrador do sistema",
          ToastType.warning);
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    await AuthPersistence().clear();
    state = state.copyWith(
      session: null,
    );

    notifyListeners();
  }

  bool isLoggedIn() {
    return state.session.token.isNotEmpty;
  }

  List<Profile> profiles() {
    return state.session.profiles;
  }

  isAdmin() {
    return state.session.isAdmin();
  }

  isMember() {
    return state.session.isMember();
  }

  isTreasurer() {
    return state.session.isTreasurer();
  }
}
