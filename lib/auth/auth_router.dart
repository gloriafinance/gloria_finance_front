import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:go_router/go_router.dart';

import 'pages/login/login_screen.dart';

authRouters() {
  return [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return transitionCustom(const LoginScreen());
      },
    ),
  ];
}
