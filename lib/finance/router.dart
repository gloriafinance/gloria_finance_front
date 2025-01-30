import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:go_router/go_router.dart';

import 'contributions/pages/app_contribuitions/add_contribution_screen.dart';
import 'contributions/pages/contributions_list/contributions_list_screen.dart';
import 'financial_records/pages/add_financial_records/add_financial_record_screen.dart';
import 'financial_records/pages/financial_records/financial_record_list_screen.dart';
import 'reports/pages/monthly_tithes/monthly_tithes_screen.dart';

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
      path: '/contributions_list',
      pageBuilder: (context, state) {
        return transitionCustom(ContributionsListScreen());
      },
    ),
    GoRoute(
      path: '/contributions_list/add',
      pageBuilder: (context, state) {
        return transitionCustom(AddContributionScreen());
      },
    ),
    GoRoute(
        path: '/report/monthly-tithes',
        pageBuilder: (context, state) {
          return transitionCustom(MonthlyTithesScreen());
        }),
  ];
}
