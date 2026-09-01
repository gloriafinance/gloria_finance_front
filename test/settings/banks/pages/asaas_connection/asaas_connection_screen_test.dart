import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/asaas_connection/asaas_connection_screen.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

void main() {
  Widget app() {
    return MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: SingleChildScrollView(child: AsaasConnectionScreen()),
      ),
    );
  }

  testWidgets(
    'shows a direct API Key form without environment or primary-account controls',
    (tester) async {
      await tester.pumpWidget(app());

      expect(find.text('Conectar conta Asaas'), findsOneWidget);
      expect(find.text('Informe sua API Key do Asaas'), findsOneWidget);
      expect(find.text('Ambiente'), findsNothing);
      expect(find.textContaining('como principal'), findsNothing);
      expect(find.byType(Checkbox), findsNothing);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image ==
                  const AssetImage('images/integrations/asaas_wordmark.png'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('does not overflow on desktop, tablet, or mobile', (
    tester,
  ) async {
    for (final size in [
      const Size(1440, 900),
      const Size(720, 900),
      const Size(390, 844),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'viewport: $size');
    }

    await tester.binding.setSurfaceSize(null);
  });
}
