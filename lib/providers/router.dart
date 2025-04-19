import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:go_router/go_router.dart';

import 'pages/register_supplier/register_supplier_screen.dart';

providerRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/suppliers/register',
      pageBuilder: (context, state) {
        return transitionCustom(RegisterSupplierScreen());
      },
    ),
  ];
}
