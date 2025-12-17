import 'package:church_finance_bk/app/locale_store.dart';
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

  AuthSessionState state = AuthSessionState(session: AuthSessionModel.empty());

  final LocaleStore? localeStore;

  AuthSessionStore({this.localeStore}) {
    _initialize();
  }

  Future<void> _initialize() async {
    var session = await AuthPersistence().restore();
    state = state.copyWith(session: session);

    if (localeStore != null && session.lang.isNotEmpty) {
      final parts = session.lang.split('-');
      if (parts.length == 2) {
        localeStore!.setLocale(Locale(parts[0], parts[1]));
      } else if (parts.isNotEmpty) {
        localeStore!.setLocale(Locale(parts[0]));
      }
    }

    notifyListeners();
  }

  Future<bool> login() async {
    formState = formState.copyWith(makeRequest: true);
    notifyListeners();

    try {
      var session = await service.makeLogin(formState.toJson());

      formState = formState.copyWith(makeRequest: false);
      notifyListeners();

      if (session == null) {
        return false;
      }
      print(session);
      state = state.copyWith(session: session, makeRequest: false);

      print("AUTH_DEBUG: Session lang is ${session.lang}");
      print("AUTH_DEBUG: LocaleStore is null? ${localeStore == null}");

      if (localeStore != null && session.lang.isNotEmpty) {
        final parts = session.lang.split('-');
        print("AUTH_DEBUG: Parsing lang parts: $parts");

        if (parts.length == 2) {
          print("AUTH_DEBUG: Setting locale to ${parts[0]}_${parts[1]}");
          localeStore!.setLocale(Locale(parts[0], parts[1]));
        } else if (parts.isNotEmpty) {
          print("AUTH_DEBUG: Setting locale to ${parts[0]}");
          localeStore!.setLocale(Locale(parts[0]));
        }
      }

      await AuthPersistence().save(session);

      notifyListeners();

      return true;
    } catch (e) {
      print("ERRRRORRRR ${e}");
      Toast.showMessage(
        // Mensaje genérico; será traducido en la UI cuando se disponga
        "Ocorreu um erro interno no sistema, informe ao administrador do sistema",
        ToastType.warning,
      );
      formState = formState.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    await AuthPersistence().clear();
    state = state.copyWith(session: null);

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

  /// Check if the user needs to accept policies
  bool needsPolicyAcceptance() {
    return isLoggedIn() && state.session.needsPolicyAcceptance();
  }

  /// Update the session with new data and persist it
  Future<void> updateSession(AuthSessionModel session) async {
    state = state.copyWith(session: session);
    await AuthPersistence().save(session);
    notifyListeners();
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

  isPastor() {
    return state.session.isPastor();
  }
}
