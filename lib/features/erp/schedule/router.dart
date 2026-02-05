import 'package:gloria_finance/core/theme/transition_custom.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/pages/schedule_form_screen.dart';
import 'package:gloria_finance/features/erp/schedule/pages/schedule_list_screen.dart';
import 'package:go_router/go_router.dart';

scheduleRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/schedule',
      pageBuilder: (context, state) {
        return transitionCustom(const ScheduleListScreen());
      },
    ),
    GoRoute(
      path: '/schedule/new',
      pageBuilder: (context, state) {
        return transitionCustom(const ScheduleFormScreen());
      },
    ),
    GoRoute(
      path: '/schedule/:id/edit',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        final item = state.extra as ScheduleItemConfig?;
        return transitionCustom(
          ScheduleFormScreen(scheduleItemId: id, initialData: item),
        );
      },
    ),
  ];
}
