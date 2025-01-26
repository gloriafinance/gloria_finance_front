import '../auth_session_model.dart';

class AuthSessionState {
  final AuthSessionModel session;

  AuthSessionState({
    required this.session,
  });

  factory AuthSessionState.empty() {
    return AuthSessionState(
      session: AuthSessionModel.empty(),
    );
  }

  AuthSessionState copyWith({
    AuthSessionModel? session,
    bool? makeRequest,
  }) {
    return AuthSessionState(
      session: session ?? this.session,
    );
  }

  isLogged() {
    return session.token.isNotEmpty;
  }
}
