import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

void main() {
  testWidgets('navigates to support assistant with contextual launch data', (
    tester,
  ) async {
    SupportAssistantLaunchModel? capturedLaunch;

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            body: OpenGloriaAssistanceContextButton(
              question: 'Ayúdame con esta pantalla',
              title: 'Register financial record',
              route: '/financial-record/add',
              module: 'financial_records',
              summary: 'Registro con impacto inmediato en caja.',
              relatedRoutes: ['/financial-concepts'],
            ),
          ),
        ),
        GoRoute(
          path: '/support-assistant',
          builder: (_, state) {
            capturedLaunch = state.extra as SupportAssistantLaunchModel;
            return const Scaffold(body: Text('Support target'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();

    expect(find.text('Support target'), findsOneWidget);
    expect(capturedLaunch, isNotNull);
    expect(capturedLaunch!.question, 'Ayúdame con esta pantalla');
    expect(capturedLaunch!.analysisTarget.title, 'Register financial record');
    expect(
      (capturedLaunch!.analysisTarget.data as Map<String, dynamic>)['route'],
      '/financial-record/add',
    );
  });
}
