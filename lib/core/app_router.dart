import 'package:church_finance_bk/auth/pages/login/login_screen.dart';
import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/finance/router.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

var routers = <RouteBase>[
  GoRoute(
    path: '/',
    pageBuilder: (context, state) {
      return transitionCustom(const LoginScreen());
    },
  ),
];

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
      routes: [...routers, ...financialRouter()], initialLocation: '/');
}
