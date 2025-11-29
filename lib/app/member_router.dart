import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_router.dart';
import 'store_manager.dart';

/// Puedes tener listas de rutas distintas si quieres
const _memberPublicRoutes = ['/', '/recovery-password'];
const _memberPolicyRoutes = ['/policy-acceptance'];

AuthSessionStore get _memberAuthStore => StoreManager().authSessionStore;

final GoRouter memberRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final currentLocation = state.uri.toString();
    final isLoggedIn = _memberAuthStore.isLoggedIn();
    final needsPolicyAcceptance = _memberAuthStore.needsPolicyAcceptance();

    if (_memberPublicRoutes.contains(currentLocation)) {
      return null;
    }

    if (!isLoggedIn) {
      return '/';
    }

    if (_memberPolicyRoutes.contains(currentLocation)) {
      if (!needsPolicyAcceptance) {
        return '/member/dashboard';
      }
      return null;
    }

    if (needsPolicyAcceptance) {
      return '/policy-acceptance';
    }

    return null;
  },
  routes: [...authRouters()],
);
