import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CorePreference {
  static final CorePreference _instance = CorePreference._internal();

  factory CorePreference() => _instance;

  CorePreference._internal();

  Future<void> run() async {
    await _configPreference();
  }

  Future<void> _configPreference() async {
    await _loadEnvFile();
  }

  Future<void> _loadEnvFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const env = String.fromEnvironment("ENV");

    if (Platform.isAndroid || Platform.isIOS) {
      await dotenv.load(fileName: "env.prod");
    } else {
      if (env == "staging" || env == "") {
        await dotenv.load(fileName: "env.dev");
      } else {
        await dotenv.load(fileName: "env.prod");
      }
    }

    dotenv.env.forEach((key, value) async {
      await prefs.setString(key, value);
    });
  }

  bool isDev() {
    return !kReleaseMode;
  }

  Future<String> getKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);

    if (value == null) {
      await _configPreference();
      return getKey(key);
    }

    return value;
  }
}

class Preferences {
  static final CorePreference _corePreference = CorePreference();

  static Future<String> get API_SERVER async =>
      await _corePreference.getKey('API_SERVER');

  static Future<String> get ENV async =>
      await _corePreference.getKey('ENVIRONMENT');
}
