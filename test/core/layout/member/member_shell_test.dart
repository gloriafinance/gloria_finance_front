import 'package:church_finance_bk/app/locale_store.dart';
import 'package:church_finance_bk/core/layout/member/member_shell.dart';
import 'package:church_finance_bk/core/layout/member/widgets/member_drawer.dart';
import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Church Finance',
      packageName: 'com.jaspesoft.church_finance',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('MemberShell renders and selects correct tab for /dashboard', (tester) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        ShellRoute(
          builder: (context, state, child) => MemberShell(child: child),
          routes: [
            GoRoute(path: '/dashboard', builder: (_, __) => const Text('Home Screen')),
            GoRoute(path: '/member/contribute', builder: (_, __) => const Text('Contribute Screen')),
            GoRoute(path: '/member/commitments', builder: (_, __) => const Text('Commitments Screen')),
            GoRoute(path: '/member/statements', builder: (_, __) => const Text('Statements Screen')),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleStore()),
          ChangeNotifierProvider(create: (_) => AuthSessionStore()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pt', 'BR'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Home Screen is present
    expect(find.text('Home Screen'), findsOneWidget);

    // Verify GNav is present
    final gNavFinder = find.byType(GNav);
    expect(gNavFinder, findsOneWidget);
    
    final gNav = tester.widget<GNav>(gNavFinder);
    expect(gNav.selectedIndex, 0);
    // Verify only 4 tabs (Profile removed)
    expect(gNav.tabs.length, 4);
  });

  testWidgets('MemberShell opens Drawer when menu icon is tapped', (tester) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        ShellRoute(
          builder: (context, state, child) => MemberShell(child: child),
          routes: [
            GoRoute(path: '/dashboard', builder: (_, __) => const Text('Home Screen')),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleStore()),
          ChangeNotifierProvider(create: (_) => AuthSessionStore()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pt', 'BR'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find Menu Icon
    final menuIcon = find.byIcon(Icons.menu);
    expect(menuIcon, findsOneWidget);

    // Tap Menu Icon
    await tester.tap(menuIcon);
    await tester.pumpAndSettle();

    // Verify Drawer is open
    expect(find.byType(MemberDrawer), findsOneWidget);
    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.text('Notificações'), findsOneWidget);
    
    // Scroll to see legal items if needed (ListView)
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    
    expect(find.text('Política de Privacidade'), findsOneWidget);
    expect(find.text('Tratamento de Dados'), findsOneWidget);
    expect(find.text('Termos de Uso'), findsOneWidget);
  });
}
