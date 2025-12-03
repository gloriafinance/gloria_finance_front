// lib/main_member.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/member_router.dart';
import 'app/my_app.dart';
import 'app/store_manager.dart';

void main() {
  final storeManager = StoreManager();
  runApp(
    MultiProvider(
      providers: [
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
          create: (_) => storeManager.navigatorMemberNotifier,
        ),
        ChangeNotifierProvider(create: (_) => storeManager.localeStore),
      ],
      child: MyApp(router: memberRouter),
    ),
  );
}
