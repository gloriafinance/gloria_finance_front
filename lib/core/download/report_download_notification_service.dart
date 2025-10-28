import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ReportDownloadNotificationService {
  ReportDownloadNotificationService._();

  static final ReportDownloadNotificationService instance =
      ReportDownloadNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  String? _lastDownloadedFilePath;
  bool _initialized = false;

  Future<void> notifyDownloadSuccess(String filePath, String fileName) async {
    _lastDownloadedFilePath = filePath;
    await _ensureInitialized();

    final message = _resolveLocationMessage(filePath, fileName);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'download_channel',
          'Descargas',
          channelDescription: 'Notificaciones de archivos descargados',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: false,
          autoCancel: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Archivo descargado',
      message,
      notificationDetails,
      payload: filePath,
    );
  }

  Future<void> showInfoNotification(String title, String message) async {
    await _ensureInitialized();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'download_channel',
          'Descargas',
          channelDescription: 'Notificaciones de archivos descargados',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      message,
      notificationDetails,
    );
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    if (Platform.isAndroid) {
      await Permission.notification.request();

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'download_channel',
        'Descargas',
        description: 'Notificaciones de archivos descargados',
        importance: Importance.max,
        enableVibration: true,
        showBadge: true,
        playSound: true,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    _initialized = true;
  }

  void _handleNotificationResponse(NotificationResponse notificationResponse) {
    final filePath = notificationResponse.payload ?? _lastDownloadedFilePath;
    if (filePath == null) {
      return;
    }

    _openOrShareFile(filePath);
  }

  Future<void> _openOrShareFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        await showInfoNotification(
          'Archivo no encontrado',
          'El archivo ya no existe en la ubicación guardada.',
        );
        return;
      }

      try {
        await Share.shareXFiles([XFile(filePath)], text: 'Reporte exportado');
      } catch (shareError) {
        try {
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            await showInfoNotification(
              'No se pudo abrir el archivo',
              'El archivo está guardado en: $filePath',
            );
          }
        } catch (openError) {
          await showInfoNotification(
            'No se pudo abrir el archivo',
            'El archivo está guardado en: $filePath',
          );
        }
      }
    } catch (e) {
      await showInfoNotification(
        'No se pudo abrir el archivo',
        'El archivo está guardado en: $filePath',
      );
    }
  }

  String _resolveLocationMessage(String filePath, String fileName) {
    if (filePath.contains('/Download/')) {
      return 'Se guardó en la carpeta de Descargas: $fileName';
    }
    if (filePath.contains('/Android/data/')) {
      return 'Se guardó en el almacenamiento de la aplicación: $fileName';
    }
    if (filePath.contains('/data/user/')) {
      return 'Se guardó en el almacenamiento interno: $fileName';
    }
    return 'Archivo guardado: $fileName';
  }
}
