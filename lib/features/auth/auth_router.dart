import 'package:gloria_finance/core/theme/transition_custom.dart';
import 'package:go_router/go_router.dart';

import 'pages/login/login_screen.dart';
import 'pages/policies/policy_acceptance_screen.dart';
import 'pages/recovery_password/recovery_password_screen.dart';

authRouters() {
  return [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return transitionCustom(const LoginScreen());
      },
    ),
    GoRoute(
      path: '/recovery-password',
      pageBuilder: (context, state) {
        return transitionCustom(const RecoveryPasswordScreen());
      },
    ),
    GoRoute(
      path: '/policy-acceptance',
      pageBuilder: (context, state) {
        return transitionCustom(const PolicyAcceptanceScreen());
      },
    ),
  ];
}
