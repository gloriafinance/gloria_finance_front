import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static const String webApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
  );
  static const String webAuthDomain = String.fromEnvironment(
    'FIREBASE_WEB_AUTH_DOMAIN',
  );
  static const String webProjectId = String.fromEnvironment(
    'FIREBASE_WEB_PROJECT_ID',
  );
  static const String webStorageBucket = String.fromEnvironment(
    'FIREBASE_WEB_STORAGE_BUCKET',
  );
  static const String webMessagingSenderId = String.fromEnvironment(
    'FIREBASE_WEB_MESSAGING_SENDER_ID',
  );
  static const String webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
  static const String webMeasurementId = String.fromEnvironment(
    'FIREBASE_WEB_MEASUREMENT_ID',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: webApiKey,
    authDomain: webAuthDomain,
    projectId: webProjectId,
    storageBucket: webStorageBucket,
    messagingSenderId: webMessagingSenderId,
    appId: webAppId,
    measurementId: webMeasurementId,
  );

  static void validateWeb() {
    final missing = <String>[
      if (webApiKey.isEmpty) 'FIREBASE_WEB_API_KEY',
      if (webAuthDomain.isEmpty) 'FIREBASE_WEB_AUTH_DOMAIN',
      if (webProjectId.isEmpty) 'FIREBASE_WEB_PROJECT_ID',
      if (webStorageBucket.isEmpty) 'FIREBASE_WEB_STORAGE_BUCKET',
      if (webMessagingSenderId.isEmpty) 'FIREBASE_WEB_MESSAGING_SENDER_ID',
      if (webAppId.isEmpty) 'FIREBASE_WEB_APP_ID',
    ];

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing Firebase web configuration: ${missing.join(', ')}. '
        'Provide them with --dart-define before running the app.',
      );
    }
  }
}
