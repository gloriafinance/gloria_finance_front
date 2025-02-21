import 'package:church_finance_bk/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/core/layout/state/sidebar_state.dart';
import 'package:church_finance_bk/settings/availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/layout/state/navigator_member_state.dart';
import 'core/router.dart';

class StoreManager {
  static final StoreManager _instance = StoreManager._internal();

  factory StoreManager() => _instance;

  StoreManager._internal();

  final sidebarNotifier = SidebarNotifier();
  final authSessionStore = AuthSessionStore();
  final financialConceptStore = FinancialConceptStore();
  final bankStore = BankStore();
  final navigatorMemberNotifier = NavigatorMemberNotifier();
  final availabilityAccountsListStore = AvailabilityAccountsListStore();
  final costCenterListStore = CostCenterListStore();
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SidebarNotifier()),
        ChangeNotifierProvider(create: (_) => AuthSessionStore()),
        ChangeNotifierProvider(
            create: (_) => FinancialConceptStore()..searchFinancialConcepts()),
        ChangeNotifierProvider(create: (_) => BankStore()..searchBanks()),
        ChangeNotifierProvider(create: (_) => NavigatorMemberNotifier()),
        ChangeNotifierProvider(create: (_) => BankStore()..searchBanks()),
        ChangeNotifierProvider(
            create: (_) =>
                AvailabilityAccountsListStore()..searchAvailabilityAccounts()),
        ChangeNotifierProvider(
            create: (_) => CostCenterListStore()..searchCostCenters()),
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
