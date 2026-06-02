import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/member_registration/pages/member_registration_screen.dart';
import 'package:gloria_finance/features/member_registration/store/member_registration_store.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/layout/member/member_shell.dart';
import '../core/theme/transition_custom.dart';
import '../features/auth/auth_router.dart';
import '../features/member_experience/home/home_screen.dart';
import '../features/member_experience/router.dart';
import 'store_manager.dart';

/// Puedes tener listas de rutas distintas si quieres
const _memberPublicRoutes = ['/', '/recovery-password'];
const _memberPublicPrefixes = ['/member-registration/'];
const _memberPolicyRoutes = ['/policy-acceptance'];

AuthSessionStore get _memberAuthStore => StoreManager().authSessionStore;

bool _isMemberPublicRoute(String location) {
  if (_memberPublicRoutes.contains(location)) return true;
  for (final prefix in _memberPublicPrefixes) {
    if (location.startsWith(prefix)) return true;
  }
  return false;
}

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

    if (_isMemberPublicRoute(currentLocation)) {
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

    GoRoute(
      path: '/member-registration/:token',
      pageBuilder: (context, state) {
        final token = state.pathParameters['token']!;
        return transitionCustom(
          ChangeNotifierProvider(
            create: (_) => MemberRegistrationStore(),
            child: MemberRegistrationScreen(token: token),
          ),
        );
      },
    ),

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
