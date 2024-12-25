import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Future<AuthSessionModel> build() async {
    return await AuthStore().restore();
  }

  Future<void> setSession(AuthSessionModel session) async {
    state = AsyncValue.loading();
    await AuthStore().save(session);

    state = AsyncValue.data(session);
  }

  String? getToken() {
    // Verificar si el estado actual es exitoso antes de acceder al token
    return state.value?.token;
  }
}
