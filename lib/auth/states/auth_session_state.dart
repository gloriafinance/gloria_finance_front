import '../auth_session_model.dart';

class AuthSessionState {
  final AuthSessionModel session;
  final bool makeRequest;

  AuthSessionState({
    required this.session,
    required this.makeRequest,
  });

  factory AuthSessionState.empty() {
    return AuthSessionState(
      session: AuthSessionModel.empty(),
      makeRequest: false,
    );
  }

  AuthSessionState copyWith({
    AuthSessionModel? session,
    bool? makeRequest,
  }) {
    return AuthSessionState(
      session: session ?? this.session,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }

  isLogged() {
    return session.token.isNotEmpty;
  }
}
