import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/members/pages/add_members/add_member_screen.dart';
import 'package:go_router/go_router.dart';

import 'pages/members_list/members_screen.dart';

memberRouter() {
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
  ];
}
