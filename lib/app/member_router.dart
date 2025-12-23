import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:go_router/go_router.dart';

import '../core/layout/member/member_shell.dart';
import '../core/theme/transition_custom.dart';
import '../features/auth/auth_router.dart';
import '../features/member_experience/home/home_screen.dart';
import '../features/member_experience/router.dart';
import 'store_manager.dart';

/// Puedes tener listas de rutas distintas si quieres
const _memberPublicRoutes = ['/', '/recovery-password'];
const _memberPolicyRoutes = ['/policy-acceptance'];

AuthSessionStore get _memberAuthStore => StoreManager().authSessionStore;

final GoRouter memberRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _memberAuthStore,
  redirect: (context, state) {
    final currentLocation = state.uri.toString();
    final isLoggedIn = _memberAuthStore.isLoggedIn();
    final isInitialized = _memberAuthStore.isInitialized;
    final needsPolicyAcceptance = _memberAuthStore.needsPolicyAcceptance();

    // If not initialized yet, don't redirect (wait)
    if (!isInitialized) return null;

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
  routes: [
    ...authRouters(),
    ShellRoute(
      builder: (context, state, child) {
        return MemberShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) {
            return transitionCustom(HomeScreen());
          },
        ),
        ...memberExperienceRouter(),
      ],
    ),
  ],
);
