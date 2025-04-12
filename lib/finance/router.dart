// lib/finance/router.dart

import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/finance/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:church_finance_bk/finance/purchase/pages/purchases/purchase_list_screen.dart';
import 'package:go_router/go_router.dart';

import 'accounts_receivable/pages/accounts_receivable/list_accounts_receivable_scren.dart';
import 'accounts_receivable/pages/register_accounts_receivable/accounts_receivable.dart';
import 'accounts_receivable/pages/view_accounts_receivable/view_accounts_receive_screen.dart';
import 'contributions/pages/app_contribuitions/add_contribution_screen.dart';
import 'contributions/pages/contributions_list/contributions_list_screen.dart';
import 'financial_records/pages/add_financial_records/add_financial_record_screen.dart';
import 'financial_records/pages/financial_records/financial_record_list_screen.dart';
import 'purchase/pages/register_purchase/add_purchase_screen.dart';
import 'reports/pages/income_statement/income_statement_screen.dart';
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
      path: '/purchase/register',
      pageBuilder: (context, state) {
        return transitionCustom(AddPurchaseScreen());
      },
    ),
    GoRoute(
      path: '/purchase',
      pageBuilder: (context, state) {
        return transitionCustom(PurchaseListScreen());
      },
    ),
    GoRoute(
        path: '/report/monthly-tithes',
        pageBuilder: (context, state) {
          return transitionCustom(MonthlyTithesScreen());
        }),
    GoRoute(
        path: '/report/income-statement',
        pageBuilder: (context, state) {
          return transitionCustom(IncomeStatementScreen());
        }),
    GoRoute(
      path: '/accounts-receivables',
      pageBuilder: (context, state) {
        return transitionCustom(ListAccountsReceivableScreen());
      },
    ),
    GoRoute(
      path: '/accounts-receivables/add',
      pageBuilder: (context, state) {
        return transitionCustom(AccountsReceivableRegistrationScreen());
      },
    ),
    // En el router.dart, añade esta ruta
    GoRoute(
      path: '/accounts-receivables/view',
      pageBuilder: (context, state) {
        final account = state.extra as AccountsReceivableModel;
        return transitionCustom(ViewAccountsReceiveScreen(account: account));
      },
    ),
  ];
}
