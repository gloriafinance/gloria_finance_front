import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static bool get isLocal => !kReleaseMode;

  static bool _dotenvLoaded = false;

  static Future<void> ensureWebConfigLoaded() async {
    if (!isLocal || _dotenvLoaded) {
      return;
    }

    await dotenv.load(fileName: '.env');
    _dotenvLoaded = true;
  }

  static String _readValue(String key) {
    if (isLocal) {
      final localValue = dotenv.env[key];
      if (localValue != null && localValue.isNotEmpty) {
        return localValue;
      }
    }

    return String.fromEnvironment(key);
  }

  static String? _readOptionalValue(String key) {
    final localValue = dotenv.env[key];
    final value = isLocal
        ? (localValue ?? String.fromEnvironment(key))
        : String.fromEnvironment(key);
    return value.isEmpty ? null : value;
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _readValue('FIREBASE_WEB_API_KEY'),
    authDomain: _readValue('FIREBASE_WEB_AUTH_DOMAIN'),
    projectId: _readValue('FIREBASE_WEB_PROJECT_ID'),
    storageBucket: _readValue('FIREBASE_WEB_STORAGE_BUCKET'),
    messagingSenderId: _readValue('FIREBASE_WEB_MESSAGING_SENDER_ID'),
    appId: _readValue('FIREBASE_WEB_APP_ID'),
    measurementId: _readOptionalValue('FIREBASE_WEB_MEASUREMENT_ID'),
  );

  static void validateWeb() {
    final missing = <String>[
      if (web.apiKey.isEmpty) 'FIREBASE_WEB_API_KEY',
      if (web.authDomain?.isEmpty ?? true) 'FIREBASE_WEB_AUTH_DOMAIN',
      if (web.projectId.isEmpty) 'FIREBASE_WEB_PROJECT_ID',
      if (web.storageBucket?.isEmpty ?? true) 'FIREBASE_WEB_STORAGE_BUCKET',
      if (web.messagingSenderId.isEmpty) 'FIREBASE_WEB_MESSAGING_SENDER_ID',
      if (web.appId.isEmpty) 'FIREBASE_WEB_APP_ID',
    ];

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing Firebase web configuration: ${missing.join(', ')}. '
        'Provide them through .env for local runs or --dart-define for production.',
      );
    }
  }
}
