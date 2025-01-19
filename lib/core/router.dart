import 'package:church_finance_bk/auth/auth_router.dart';
import 'package:church_finance_bk/finance/router.dart';
import 'package:church_finance_bk/home/home_screen.dart';
import 'package:church_finance_bk/settings/router.dart';
import 'package:go_router/go_router.dart';

import 'theme/transition_custom.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  // redirect: (context, state) {
  //   final sessionController = Provider.of<AuthSessionStore>(context);
  //   final loggedIn = sessionController.isLoggedIn();
  //
  //   print("Usuario autenticado: $loggedIn");
  //
  //   final currentLocation = state.uri.toString();
  //
  //   print("Ubicación actual: $currentLocation");
  //
  //   // Redirigir al login si el usuario no está autenticado
  //   if (!loggedIn && currentLocation != '/') {
  //     return '/';
  //   }
  //
  //   // Redirigir al home si el usuario ya está autenticado
  //   if (loggedIn && currentLocation == '/') {
  //     return '/financial-record';
  //   }
  //
  //   return state.fullPath
  // },
  routes: [
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) {
        return transitionCustom(HomeScreen());
      },
    ),
    ...authRouters(),
    ...financialRouter(),
    ...settingsRouter()
  ],
);
