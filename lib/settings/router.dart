import 'package:church_finance_bk/core/theme/transition_custom.dart';

import 'package:go_router/go_router.dart';


import 'availability_accounts/pages/availability_accounts/availability_accounts_screen.dart';
import 'availability_accounts/pages/list_availability_accounts/availability_accounts_list_screen.dart';
import 'members/pages/add_members/add_member_screen.dart';
import 'members/pages/members_list/members_screen.dart';

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
  ];
}
