// lib/main_member.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/member_router.dart';
import 'app/my_app.dart';
import 'app/store_manager.dart';
import 'core/app_http.dart';
import 'features/member_experience/notifications/push_notification_manager.dart';

// 1) Background handler (top-level function)
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // opcional: log / analytics / etc.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2) Firebase init
  await Firebase.initializeApp();

  // 3) Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

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
        Provider(create: (_) => PushNotificationManager()),
      ],
      child: MyApp(router: memberRouter),
    ),
  );
}
