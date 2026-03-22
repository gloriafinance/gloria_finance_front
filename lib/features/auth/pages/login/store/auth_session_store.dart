import 'dart:io';

import 'package:gloria_finance/app/locale_store.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum SocialLoginErrorType {
  canceled,
  interrupted,
  deviceIssue,
  unavailable,
  configuration,
}

class AuthSessionStore extends ChangeNotifier {
  var service = AuthService();
  FormLoginState formState = FormLoginState.init();

  AuthSessionState state = AuthSessionState(session: AuthSessionModel.empty());
  SocialLoginErrorType? _socialLoginError;

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
      print("ERRRRORRRR $e");
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
    _startSocialLoginRequest();

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final account = await googleSignIn.signIn();

      if (account == null) {
        _socialLoginError = SocialLoginErrorType.canceled;
        _finishSocialLoginRequest();
        return false;
      }

      final auth = await account.authentication;
      final token = auth.idToken ?? auth.accessToken;

      if (token == null || token.isEmpty) {
        _socialLoginError = SocialLoginErrorType.unavailable;
        _finishSocialLoginRequest();
        return false;
      }

      final session = await service.socialLogin(
        provider: "google",
        idToken: token,
      );

      _finishSocialLoginRequest();

      if (session == null) {
        return false;
      }

      await _applySession(session);
      return true;
    } on PlatformException catch (e) {
      print("ERRRRORRRR $e");
      _socialLoginError = _mapGoogleSignInError(e);
      _finishSocialLoginRequest();
      return false;
    } catch (e) {
      print("ERRRRORRRR $e");
      _socialLoginError = _mapSocialLoginError(e);
      _finishSocialLoginRequest();
      return false;
    }
  }

  Future<bool> loginWithMicrosoft() async {
    _startSocialLoginRequest();

    try {
      if (_microsoftClientId.isEmpty) {
        _socialLoginError = SocialLoginErrorType.configuration;
        _finishSocialLoginRequest();
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

      if (result.idToken == null || result.idToken!.isEmpty) {
        _socialLoginError = SocialLoginErrorType.unavailable;
        _finishSocialLoginRequest();
        return false;
      }

      final session = await service.socialLogin(
        provider: "microsoft",
        idToken: result.idToken!,
      );

      _finishSocialLoginRequest();

      if (session == null) {
        return false;
      }

      await _applySession(session);
      return true;
    } on FlutterAppAuthUserCancelledException catch (e) {
      print("ERRRRORRRR $e");
      _socialLoginError = SocialLoginErrorType.canceled;
      _finishSocialLoginRequest();
      return false;
    } on FlutterAppAuthPlatformException catch (e) {
      print("ERRRRORRRR $e");
      _socialLoginError = _mapMicrosoftLoginError(e);
      _finishSocialLoginRequest();
      return false;
    } catch (e) {
      print("ERRRRORRRR $e");
      _socialLoginError = _mapSocialLoginError(e);
      _finishSocialLoginRequest();
      return false;
    }
  }

  SocialLoginErrorType? consumeSocialLoginError() {
    final error = _socialLoginError;
    _socialLoginError = null;
    return error;
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

  void _startSocialLoginRequest() {
    _socialLoginError = null;
    formState = formState.copyWith(makeRequest: true);
    notifyListeners();
  }

  void _finishSocialLoginRequest() {
    formState = formState.copyWith(makeRequest: false);
    notifyListeners();
  }

  SocialLoginErrorType _mapGoogleSignInError(PlatformException error) {
    switch (error.code) {
      case GoogleSignIn.kSignInCanceledError:
        return SocialLoginErrorType.canceled;
      case GoogleSignInAccount.kFailedToRecoverAuthError:
      case GoogleSignInAccount.kUserRecoverableAuthError:
        return SocialLoginErrorType.interrupted;
      case GoogleSignIn.kNetworkError:
        return SocialLoginErrorType.deviceIssue;
      case GoogleSignIn.kSignInRequiredError:
        return SocialLoginErrorType.unavailable;
      case GoogleSignIn.kSignInFailedError:
        if (_looksLikeConfigurationIssue(
          '${error.message ?? ''} ${error.details ?? ''}',
        )) {
          return SocialLoginErrorType.configuration;
        }
        return SocialLoginErrorType.unavailable;
      default:
        if (_looksLikeConnectivityIssue(
          '${error.message ?? ''} ${error.details ?? ''}',
        )) {
          return SocialLoginErrorType.deviceIssue;
        }

        if (_looksLikeConfigurationIssue(
          '${error.message ?? ''} ${error.details ?? ''}',
        )) {
          return SocialLoginErrorType.configuration;
        }

        return SocialLoginErrorType.configuration;
    }
  }

  SocialLoginErrorType _mapMicrosoftLoginError(
    FlutterAppAuthPlatformException error,
  ) {
    final details = error.platformErrorDetails;
    final joinedDetails = [
      error.code,
      error.message,
      details.error,
      details.errorDescription,
      details.errorDebugDescription,
      details.rootCauseDebugDescription,
      details.code,
      details.type,
    ].whereType<String>().join(' ');

    if (_looksLikeCancellation(joinedDetails)) {
      return SocialLoginErrorType.canceled;
    }

    if (_looksLikeConnectivityIssue(joinedDetails)) {
      return SocialLoginErrorType.deviceIssue;
    }

    if (_looksLikeConfigurationIssue(joinedDetails)) {
      return SocialLoginErrorType.configuration;
    }

    return SocialLoginErrorType.unavailable;
  }

  SocialLoginErrorType _mapSocialLoginError(Object error) {
    if (error is SocketException) {
      return SocialLoginErrorType.deviceIssue;
    }

    if (error is PlatformException) {
      final joinedDetails = [
        error.code,
        error.message,
        error.details?.toString(),
      ].whereType<String>().join(' ');

      if (_looksLikeCancellation(joinedDetails)) {
        return SocialLoginErrorType.canceled;
      }

      if (_looksLikeConnectivityIssue(joinedDetails)) {
        return SocialLoginErrorType.deviceIssue;
      }

      if (_looksLikeConfigurationIssue(joinedDetails)) {
        return SocialLoginErrorType.configuration;
      }
    }

    return SocialLoginErrorType.deviceIssue;
  }

  bool _looksLikeConnectivityIssue(String rawText) {
    final text = rawText.toLowerCase();
    const keywords = [
      'network',
      'internet',
      'connection',
      'timeout',
      'socket',
      'unreachable',
      'offline',
      'host',
      'dns',
      'temporarily unavailable',
      'service unavailable',
    ];

    return keywords.any(text.contains);
  }

  bool _looksLikeConfigurationIssue(String rawText) {
    final text = rawText.toLowerCase();
    const keywords = [
      'invalid_client',
      'invalid_request',
      'unauthorized_client',
      'redirect',
      'configuration',
      'configuração',
      'configured',
      'misconfigured',
      'client id',
    ];

    return keywords.any(text.contains);
  }

  bool _looksLikeCancellation(String rawText) {
    final text = rawText.toLowerCase();
    const keywords = ['cancel', 'canceled', 'cancelled', 'user_cancelled'];
    return keywords.any(text.contains);
  }
}
