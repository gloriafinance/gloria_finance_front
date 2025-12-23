import 'package:church_finance_bk/app/locale_store.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';

import '../../../../../app/member_router.dart'; // To access memberRouter
import '../../../../member_experience/notifications/notification_api.dart';
import '../../../../member_experience/notifications/push_notification_manager.dart';
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
  final PushNotificationManager? pushNotificationManager;

  AuthSessionStore({this.localeStore, this.pushNotificationManager}) {
    _initialize();
  }

  bool isInitialized = false;

  Future<void> _initialize() async {
    var session = await AuthPersistence().restore();
    state = state.copyWith(session: session);

    if (localeStore != null && session.lang.isNotEmpty) {
      final hasSaved = await localeStore!.hasSavedLocale();
      if (!hasSaved) {
        final parts = session.lang.split('-');
        if (parts.length == 2) {
          localeStore!.setLocale(Locale(parts[0], parts[1]));
        } else if (parts.isNotEmpty) {
          localeStore!.setLocale(Locale(parts[0]));
        }
      }
    }

    // Attempt to init push notifications if session is valid
    if (isLoggedIn() && pushNotificationManager != null) {
      _initPushNotifications();
    }

    isInitialized = true;
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

      state = state.copyWith(session: session, makeRequest: false);

      if (localeStore != null && session.lang.isNotEmpty) {
        final parts = session.lang.split('-');

        if (parts.length == 2) {
          localeStore!.setLocale(Locale(parts[0], parts[1]));
        } else if (parts.isNotEmpty) {
          localeStore!.setLocale(Locale(parts[0]));
        }
      }

      await AuthPersistence().save(session);

      if (pushNotificationManager != null) {
        _initPushNotifications();
      }

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

  void _initPushNotifications() {
    pushNotificationManager?.init(
      onDeepLink: (deepLink) {
        print("PUSH: Navigating to $deepLink");
        try {
          // Use the global memberRouter
          memberRouter.go(deepLink);
        } catch (e) {
          print("PUSH: Navigation error: $e");
        }
      },
      onToken: (token, deviceId, platform) async {
        print("PUSH: Registering token: $token ($platform - $deviceId)");
        await NotificationApi(
          tokenAPI: state.session.token,
        ).registerToken(token: token, deviceId: deviceId, platform: platform);
      },
    );
  }
}
