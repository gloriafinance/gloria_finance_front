import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

typedef DeepLinkHandler = void Function(String deepLink);
typedef TokenHandler =
    Future<void> Function(String token, String deviceId, String platform);

class PushNotificationManager {
  bool _initialized = false;

  Future<void> init({
    required DeepLinkHandler onDeepLink,
    required TokenHandler onToken,
  }) async {
    if (kIsWeb) return;
    if (_initialized) return;
    _initialized = true;

    // Android 13+: request permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Prepare device info
    String deviceId = 'unknown';
    String platform = 'unknown';

    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      platform = 'android';
      try {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id; // stable ID
      } catch (e) {
        // fallback
        deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      }
    } else if (Platform.isIOS) {
      platform = 'ios';
      try {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
      } catch (e) {
        // fallback
      }
    }

    // Current token
    // On iOS Simulator (and without APNs config), getToken will throw/fail.
    // User requested to skip this check on iOS for now.
    if (!Platform.isIOS) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await onToken(token, deviceId, platform);
      }
    }

    // Token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await onToken(newToken, deviceId, platform);
    });

    // Foreground: Log for MVP
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Foreground Notification Received:");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("Data: ${message.data}");
    });

    // Background Tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final deepLink = message.data['deepLink'];
      if (deepLink != null && deepLink is String && deepLink.isNotEmpty) {
        onDeepLink(deepLink);
      }
    });

    // Terminated Tap
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      final deepLink = initial.data['deepLink'];
      if (deepLink != null && deepLink is String && deepLink.isNotEmpty) {
        onDeepLink(deepLink);
      }
    }
  }
}
