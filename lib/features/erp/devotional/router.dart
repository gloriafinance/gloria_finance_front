import 'package:go_router/go_router.dart';
import 'package:gloria_finance/core/theme/transition_custom.dart';

import 'pages/devotional_review_screen.dart';
import 'pages/devotional_screen.dart';

devotionalRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/devotional',
      pageBuilder: (context, state) {
        return transitionCustom(const DevotionalScreen());
      },
    ),
    GoRoute(
      path: '/devotional/review/:id',
      pageBuilder: (context, state) {
        final devotionalId = state.pathParameters['id']!;
        return transitionCustom(
          DevotionalReviewScreen(devotionalId: devotionalId),
        );
      },
    ),
  ];
}
