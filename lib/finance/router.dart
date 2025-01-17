import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/finance/pages/add_financial_records/add_financial_record_screen.dart';
import 'package:church_finance_bk/finance/pages/contributions/contributions_screen.dart';
import 'package:go_router/go_router.dart';

import 'pages/app_contribuitions/add_contribution_screen.dart';
import 'pages/financial_records/financial_record_screen.dart';
import 'pages/purchase/add_purchase_screen.dart';

financialRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/financial-record',
      pageBuilder: (context, state) {
        return transitionCustom(FinancialRecordScreen());
      },
    ),
    GoRoute(
      path: '/financial-record/add',
      pageBuilder: (context, state) {
        return transitionCustom(AddFinancialRecordScreen());
      },
    ),
    GoRoute(
      path: '/contributions',
      pageBuilder: (context, state) {
        return transitionCustom(ContributionsScreen());
      },
    ),
    GoRoute(
      path: '/contributions/add',
      pageBuilder: (context, state) {
        return transitionCustom(AddContributionScreen());
      },
    ),
    GoRoute(
      path: '/purchase-record',
      pageBuilder: (context, state) {
        return transitionCustom(AddPurchaseScreen());
      },
    ),
  ];
}
