import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/bank_list_screen.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_connection_hero.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_how_it_works_dialog.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/bank_table.dart';
import 'package:gloria_finance/features/erp/settings/banks/state/bank_state.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late BankStore bankStore;
  late AuthSessionStore authSessionStore;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bankStore =
        BankStore()..state = BankState(makeRequest: true, banks: const []);
    authSessionStore = AuthSessionStore();
  });

  Widget app(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BankStore>.value(value: bankStore),
        ChangeNotifierProvider<AuthSessionStore>.value(value: authSessionStore),
      ],
      child: MaterialApp(
        locale: const Locale('pt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  testWidgets('keeps the bank table and traditional add-account action', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const BankListScreen(showAsaasConnection: true)),
    );

    expect(find.text('Bancos e contas'), findsOneWidget);
    expect(
      find.text(
        'Gerencie as contas bancárias e conecte o Asaas para automatizar seu financeiro.',
      ),
      findsNothing,
    );
    expect(find.text('Suas contas conectadas'), findsNothing);
    expect(
      find.text('Lista de contas bancárias e integrações ativas.'),
      findsNothing,
    );
    expect(find.byType(AsaasConnectionHero), findsOneWidget);
    expect(find.byType(BankTable), findsOneWidget);
    expect(find.textContaining('CONECTAR ASAAS'), findsNothing);
    expect(find.text('Adicionar conta'), findsOneWidget);
  });

  testWidgets('shows the dialog and omits connection CTAs without a callback', (
    tester,
  ) async {
    await tester.pumpWidget(app(_heroWithDialog()));

    expect(find.textContaining('CONECTAR ASAAS'), findsNothing);

    await tester.tap(find.text('SAIBA COMO FUNCIONA'));
    await tester.pumpAndSettle();

    expect(find.byType(AsaasHowItWorksDialog), findsOneWidget);
    expect(find.text('Como funciona a integração com o Asaas'), findsOneWidget);
    expect(find.textContaining('CONECTAR MINHA CONTA'), findsNothing);

    await tester.ensureVisible(find.text('FECHAR'));
    await tester.tap(find.text('FECHAR'));
    await tester.pumpAndSettle();

    expect(find.byType(AsaasHowItWorksDialog), findsNothing);
  });

  testWidgets('hides the Asaas hero when the session is not eligible', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const BankListScreen(showAsaasConnection: false)),
    );

    expect(find.byType(AsaasConnectionHero), findsNothing);
    expect(find.byType(BankTable), findsOneWidget);
    expect(find.text('Adicionar conta'), findsOneWidget);
    expect(find.text('Suas contas conectadas'), findsNothing);
    expect(
      find.text('Lista de contas bancárias e integrações ativas.'),
      findsNothing,
    );
  });

  testWidgets('uses one injected callback for both connection CTAs', (
    tester,
  ) async {
    var connectionRequests = 0;

    await tester.pumpWidget(
      app(_heroWithDialog(onConnectAsaas: () => connectionRequests += 1)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONECTAR ASAAS AGORA'));
    expect(connectionRequests, 1);

    await tester.tap(find.text('SAIBA COMO FUNCIONA'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('CONECTAR MINHA CONTA ASAAS'));
    await tester.tap(find.text('CONECTAR MINHA CONTA ASAAS'));
    await tester.pumpAndSettle();

    expect(connectionRequests, 2);
    expect(find.byType(AsaasHowItWorksDialog), findsNothing);
  });

  testWidgets('uses the supplied asset without overflow at responsive widths', (
    tester,
  ) async {
    for (final size in [
      const Size(1440, 900),
      const Size(720, 900),
      const Size(390, 844),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(app(_heroWithDialog()));
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.image,
        const AssetImage('images/integrations/asaas_connection_hero.png'),
      );
      expect(image.fit, BoxFit.contain);
      expect(tester.takeException(), isNull);
    }

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('redesigned dialog has three steps without responsive overflow', (
    tester,
  ) async {
    for (final size in [
      const Size(1440, 900),
      const Size(720, 900),
      const Size(390, 844),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(app(_heroWithDialog()));
      await tester.ensureVisible(find.text('SAIBA COMO FUNCIONA'));
      await tester.tap(find.text('SAIBA COMO FUNCIONA'));
      await tester.pumpAndSettle();

      expect(find.text('Membro contribui ou oferta'), findsOneWidget);
      expect(find.text('Conciliação automática'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport: $size');

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
    }

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('uses the dedicated mobile dialog composition', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(app(_heroWithDialog(onConnectAsaas: () {})));

    await tester.tap(find.text('SAIBA COMO FUNCIONA'));
    await tester.pumpAndSettle();

    final title = tester.widget<Text>(
      find.text('Como funciona a integração com o Asaas'),
    );
    expect(title.style?.fontSize, 24);
    expect(find.byIcon(Icons.lock_outline), findsNothing);

    await tester.ensureVisible(find.text('CONECTAR MINHA CONTA ASAAS'));
    final connectRect = tester.getRect(
      find.ancestor(
        of: find.text('CONECTAR MINHA CONTA ASAAS'),
        matching: find.byType(ElevatedButton),
      ),
    );
    final closeRect = tester.getRect(
      find.ancestor(
        of: find.text('FECHAR'),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(connectRect.top, lessThan(closeRect.top));
    expect((connectRect.width - closeRect.width).abs(), lessThan(2));
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(null);
  });
}

Widget _heroWithDialog({VoidCallback? onConnectAsaas}) {
  return Builder(
    builder:
        (context) => AsaasConnectionHero(
          onConnectAsaas: onConnectAsaas,
          onShowHowItWorks:
              () => showDialog<void>(
                context: context,
                builder:
                    (_) =>
                        AsaasHowItWorksDialog(onConnectAsaas: onConnectAsaas),
              ),
        ),
  );
}
