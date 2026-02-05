import 'package:gloria_finance/app/store_manager.dart';
import 'package:gloria_finance/features/erp/home/home_screen.dart';
import 'package:gloria_finance/features/erp/router.dart';
import 'package:go_router/go_router.dart';

import '../core/layout/erp/erp_shell.dart';
import '../core/theme/transition_custom.dart';
import '../features/auth/auth_router.dart';
import '../features/auth/pages/login/store/auth_session_store.dart';

/// Routes that don't require authentication
const _publicRoutes = ['/', '/recovery-password'];

/// Routes related to policy acceptance
const _policyRoutes = ['/policy-acceptance'];

/// Get the AuthSessionStore instance from StoreManager
AuthSessionStore get _authStore => StoreManager().authSessionStore;

final GoRouter erpRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _authStore,
  redirect: (context, state) {
    final currentLocation = state.uri.toString();
    final isLoggedIn = _authStore.isLoggedIn();
    final isInitialized = _authStore.isInitialized;
    final needsPolicyAcceptance = _authStore.needsPolicyAcceptance();

    // If not initialized yet, don't redirect (wait)
    if (!isInitialized) return null;

    // Allow public routes without authentication - don't redirect away from them
    if (_publicRoutes.contains(currentLocation)) {
      return null;
    }

    // If not logged in, redirect to login
    if (!isLoggedIn) {
      return '/';
    }

    // If on policy acceptance page
    if (_policyRoutes.contains(currentLocation)) {
      // If policies are already accepted, redirect to dashboard
      if (!needsPolicyAcceptance) {
        return '/dashboard';
      }
      return null;
    }

    // For all other authenticated routes, check if policy acceptance is needed
    if (needsPolicyAcceptance) {
      return '/policy-acceptance';
    }

    return null;
  },
  routes: [
    ...authRouters(),

    ShellRoute(
      builder: (context, state, child) {
        return ErpShell(screen: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) {
            return transitionCustom(HomeScreen());
          },
        ),
        ...erpListRouter(),
      ],
    ),
  ],
);
