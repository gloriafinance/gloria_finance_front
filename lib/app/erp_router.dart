// lib/core/erp_router.dart

import 'package:church_finance_bk/app/store_manager.dart';
import 'package:church_finance_bk/features/erp//home/home_screen.dart';
import 'package:church_finance_bk/features/erp//router.dart';
import 'package:go_router/go_router.dart';

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
  redirect: (context, state) {
    final currentLocation = state.uri.toString();
    final isLoggedIn = _authStore.isLoggedIn();
    final needsPolicyAcceptance = _authStore.needsPolicyAcceptance();

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
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) {
        return transitionCustom(HomeScreen());
      },
    ),
    ...authRouters(),
    ...erpListRouter(),
  ],
);
