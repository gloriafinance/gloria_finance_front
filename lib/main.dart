import 'package:church_finance_bk/auth/stores/auth_session_store.dart';
import 'package:church_finance_bk/finance/stores/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/layout/state/navigator_member_state.dart';
import 'core/router.dart';
import 'finance/stores/financial_concept_store.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthSessionStore()),
        ChangeNotifierProvider(
            create: (_) => FinancialConceptStore()..searchFinancialConcepts()),
        ChangeNotifierProvider(create: (_) => BankStore()..searchBanks()),
        ChangeNotifierProvider(create: (_) => NavigatorMemberNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'), // Soporta portugués
      ],
      locale: Locale('pt', 'BR'), // Esto fuerza el uso del idioma portugués
    );
  }
}
