import 'dart:html' as html;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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

  static bool _localConfigLoaded = false;
  static final Map<String, String> _localValues = <String, String>{};

  static Future<void> ensureWebConfigLoaded() async {
    if (!isLocal || _localConfigLoaded) {
      return;
    }

    final envText = await html.HttpRequest.getString('/.env');
    _localValues.addAll(_parseEnvFile(envText));
    _localConfigLoaded = true;
  }

  static Map<String, String> _parseEnvFile(String content) {
    final result = <String, String>{};
    for (final rawLine in content.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      final index = line.indexOf('=');
      if (index <= 0) {
        continue;
      }

      final key = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();
      result[key] = value;
    }
    return result;
  }

  static String _readValue(String key) {
    if (isLocal) {
      final localValue = _localValues[key];
      if (localValue != null && localValue.isNotEmpty) {
        return localValue;
      }
    }

    return String.fromEnvironment(key);
  }

  static String? _readOptionalValue(String key) {
    final localValue = isLocal ? _localValues[key] : null;
    final value = localValue ?? String.fromEnvironment(key);
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
        'Provide them through /.env for local runs or --dart-define for production.',
      );
    }
  }
}
