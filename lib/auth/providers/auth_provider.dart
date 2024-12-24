import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Session extends _$Session {
  @override
  AuthSessionModel build() {
    AuthSessionModel.init();
    var sessionActive = AuthStore().restore();
    if (sessionActive != null) {
      return sessionActive;
    }

    return AuthSessionModel.init();
  }

  void setSession(AuthSessionModel session) {
    print("session: $session");
    state = session;
  }

  String getToken() {
    return state.token;
  }
}
