import 'package:gloria_finance/app/locale_store.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_appauth/flutter_appauth.dart';

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

  static const _microsoftClientId = String.fromEnvironment(
    'MICROSOFT_CLIENT_ID',
    defaultValue: '6a536a53-11d6-460b-b3d6-0f8faa2e3b2c',
  );
  static const _microsoftRedirectUri =
      'msauth://com.gloria_finance.app/Ai4V8SL6HflR%2FfJn8GFsyubX7XU%3D';

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

      await _applySession(session);

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

  Future<bool> loginWithGoogle() async {
    formState = formState.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final account = await googleSignIn.signIn();

      if (account == null) {
        formState = formState.copyWith(makeRequest: false);
        notifyListeners();
        return false;
      }

      final auth = await account.authentication;
      final token = auth.idToken ?? auth.accessToken;

      if (token == null || token.isEmpty) {
        Toast.showMessage(
          "Não foi possível autenticar com Google",
          ToastType.warning,
        );
        formState = formState.copyWith(makeRequest: false);
        notifyListeners();
        return false;
      }

      final session = await service.socialLogin(
        provider: "google",
        idToken: token,
      );

      formState = formState.copyWith(makeRequest: false);
      notifyListeners();

      if (session == null) {
        return false;
      }

      await _applySession(session);
      return true;
    } catch (e) {
      print("ERRRRORRRR ${e}");
      Toast.showMessage(
        "Ocorreu um erro interno no sistema, informe ao administrador do sistema",
        ToastType.warning,
      );
      formState = formState.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithMicrosoft() async {
    formState = formState.copyWith(makeRequest: true);
    notifyListeners();

    try {
      if (_microsoftClientId.isEmpty) {
        Toast.showMessage(
          "MICROSOFT_CLIENT_ID no configurado",
          ToastType.warning,
        );
        formState = formState.copyWith(makeRequest: false);
        notifyListeners();
        return false;
      }

      const appAuth = FlutterAppAuth();
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _microsoftClientId,
          _microsoftRedirectUri,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint:
                'https://login.microsoftonline.com/47f49fd8-40cf-40dd-9451-ca97bb62aafd/oauth2/v2.0/authorize',
            tokenEndpoint:
                'https://login.microsoftonline.com/47f49fd8-40cf-40dd-9451-ca97bb62aafd/oauth2/v2.0/token',
          ),
          scopes: const ['openid', 'email', 'profile'],
          promptValues: const ['select_account'],
        ),
      );

      if (result == null || result.idToken == null) {
        formState = formState.copyWith(makeRequest: false);
        notifyListeners();
        return false;
      }

      final session = await service.socialLogin(
        provider: "microsoft",
        idToken: result.idToken!,
      );

      formState = formState.copyWith(makeRequest: false);
      notifyListeners();

      if (session == null) {
        return false;
      }

      await _applySession(session);
      return true;
    } catch (e) {
      print("ERRRRORRRR ${e}");
      Toast.showMessage(
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

  Future<void> _applySession(AuthSessionModel session) async {
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
  }
}
