// lib/main_erp.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/erp_router.dart';
import 'app/my_app.dart';
import 'app/store_manager.dart';
import 'core/app_http.dart';

void main() {
  final storeManager = StoreManager();
  AppHttp.onUnauthorized = () {
    storeManager.authSessionStore.logout();
  };
  AppHttp.onSessionRefreshed = (session) async {
    await storeManager.authSessionStore.updateSession(session);
  };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => storeManager.sidebarNotifier),
        ChangeNotifierProvider(create: (_) => storeManager.authSessionStore),
        ChangeNotifierProvider(
          create:
              (_) =>
                  storeManager.financialConceptStore..searchFinancialConcepts(),
        ),
        ChangeNotifierProvider(
          create: (_) => storeManager.bankStore..searchBanks(),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  storeManager.availabilityAccountsListStore
                    ..searchAvailabilityAccounts(),
        ),
        ChangeNotifierProvider(
          create: (_) => storeManager.costCenterListStore..searchCostCenters(),
        ),
        ChangeNotifierProvider(
          create: (_) => storeManager.memberAllStore..searchAllMember(),
        ),
        ChangeNotifierProvider(
          create: (_) => storeManager.trendStore..fetchTrends(),
        ),
        ChangeNotifierProvider(create: (_) => storeManager.localeStore),
      ],
      child: MyApp(router: erpRouter),
    ),
  );
}
