import 'package:church_finance_bk/core/theme/transition_custom.dart';

import 'package:go_router/go_router.dart';


import 'availability_accounts/pages/availability_accounts/availability_accounts_screen.dart';
import 'availability_accounts/pages/list_availability_accounts/availability_accounts_list_screen.dart';
import 'members/pages/add_members/add_member_screen.dart';
import 'members/pages/members_list/members_screen.dart';
import 'financial_concept/models/financial_concept_model.dart';
import 'financial_concept/pages/financial_concept_list/financial_concept_list_screen.dart';
import 'financial_concept/pages/form_financial_concept/financial_concept_form_screen.dart';

settingsRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/members',
      pageBuilder: (context, state) {
        return transitionCustom(MembersScreen());
      },
    ),
    GoRoute(
      path: '/member/add',
      pageBuilder: (context, state) {
        return transitionCustom(AddMemberScreen());
      },
    ),
    GoRoute(
      path: '/availability-accounts',
      pageBuilder: (context, state) {
        return transitionCustom(AvailabilityAccountsListScreen());
      },
    ),
    GoRoute(
      path: '/availability-accounts/add',
      pageBuilder: (context, state) {
        return transitionCustom(AvailabilityAccountsScreen());
      },
    ),
    GoRoute(
      path: '/financial-concepts',
      pageBuilder: (context, state) {
        return transitionCustom(const FinancialConceptListScreen());
      },
    ),
    GoRoute(
      path: '/financial-concepts/add',
      pageBuilder: (context, state) {
        return transitionCustom(const FinancialConceptFormScreen());
      },
    ),
    GoRoute(
      path: '/financial-concepts/edit/:financialConceptId',
      pageBuilder: (context, state) {
        final concept = state.extra is FinancialConceptModel
            ? state.extra as FinancialConceptModel
            : null;
        return transitionCustom(
          FinancialConceptFormScreen(concept: concept),
        );
      },
    ),
  ];
}
