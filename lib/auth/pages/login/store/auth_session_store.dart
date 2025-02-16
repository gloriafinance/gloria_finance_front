import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';

import '../../../auth_persistence.dart';
import '../../../auth_service.dart';
import '../../../auth_session_model.dart';
import '../state/auth_session_state.dart';
import '../state/form_login_state.dart';

class AuthSessionStore extends ChangeNotifier {
  var service = AuthService();
  FormLoginState formState = FormLoginState.init();

  AuthSessionState state = AuthSessionState(
    session: AuthSessionModel.empty(),
  );

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

  Future<bool> login() async {
    formState = formState.copyWith(makeRequest: true);
    notifyListeners();

    try {
      var session = await service.makeLogin(formState.toJson());

      if (session == null) {
        formState = formState.copyWith(makeRequest: false);
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
      formState = formState.copyWith(makeRequest: false);
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

  void setEmail(String email) {
    formState = formState.copyWith(email: email);
    notifyListeners();
  }

  void setPassword(String password) {
    formState = formState.copyWith(password: password);
    notifyListeners();
  }

  void setMakeRequest(bool makeRequest) {
    formState = formState.copyWith(makeRequest: makeRequest);
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
