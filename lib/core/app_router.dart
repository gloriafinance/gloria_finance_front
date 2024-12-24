import 'package:church_finance_bk/DashboardScreen.dart';
import 'package:church_finance_bk/auth/providers/auth_provider.dart';
import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

var routers = <RouteBase>[
  GoRoute(
    path: '/',
    pageBuilder: (context, state) {
      //return transitionCustom(const LoginScreen());
      return transitionCustom(const DashboardScreen());
    },
  ),
];

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  var session = ref.watch(sessionProvider);

  print("session************: ${session.isSessionStarted()}");

  print("memberRoute: $routers");

  return GoRouter(routes: routers, initialLocation: '/');
}
