import 'dart:io';

import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/financial_records/models/finance_record_filter_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as universal_html;

import 'models/finance_record_list_model.dart';

// Inicializar el plugin de notificaciones
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Variable global para almacenar la última ruta de archivo descargado
String? _lastDownloadedFilePath;

class FinanceRecordService extends AppHttp {
  FinanceRecordService({super.tokenAPI});

  // Inicializar notificaciones
  Future<void> initNotifications() async {
    try {
      print("Inicializando sistema de notificaciones...");

      // Configuración específica para Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración específica para iOS
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      // Configuración general
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Solicitar permiso de notificación en Android 13+
      if (Platform.isAndroid) {
        try {
          await Permission.notification.request();
          print("Permiso de notificación solicitado");
        } catch (e) {
          print("Error al solicitar permiso de notificación: $e");
        }
      }

      // Crear canal de notificaciones (solo Android)
      if (Platform.isAndroid) {
        try {
          const AndroidNotificationChannel channel = AndroidNotificationChannel(
            'download_channel',
            'Descargas',
            description: 'Notificaciones de archivos descargados',
            importance: Importance.max,
            enableVibration: true,
            showBadge: true,
            playSound: true,
          );

          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(channel);

          print("Canal de notificaciones creado");
        } catch (e) {
          print("Error al crear canal de notificaciones: $e");
        }
      }

      // Inicializar plugin con la configuración
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );

      print("Notificaciones inicializadas correctamente");
    } catch (e) {
      print("Error al inicializar notificaciones: $e");
      // No propagar la excepción para evitar interrumpir el flujo de la app
    }
  }

  // Manejador para cuando se hace clic en la notificación
  void _handleNotificationResponse(
      NotificationResponse notificationResponse) async {
    print("Notificación seleccionada: ${notificationResponse.payload}");

    // Obtener la ruta del archivo desde el payload
    final filePath = notificationResponse.payload ?? _lastDownloadedFilePath;

    if (filePath != null) {
      print("Intentando abrir archivo: $filePath");
      try {
        // Verificar que el archivo existe
        if (await File(filePath).exists()) {
          // Primero intentamos compartir el archivo directamente
          // ya que abrir puede ser problemático para archivos Excel en algunas configuraciones
          try {
            print("Compartiendo archivo...");
            await Share.shareXFiles([XFile(filePath)],
                text: 'Registros financieros exportados');
          } catch (e) {
            print("Error al compartir archivo: $e");

            // Si falla el compartir, intentamos abrir el archivo
            try {
              print("Intentando abrir archivo...");
              final result = await OpenFile.open(filePath);
              print(
                  "Resultado de OpenFile: ${result.type} - ${result.message}");
            } catch (e) {
              print("Error al abrir archivo: $e");

              // Como último recurso, mostrar notificación de error
              _showPermissionNotification('No se pudo abrir el archivo',
                  'El archivo está guardado en: $filePath');
            }
          }
        } else {
          print("El archivo no existe: $filePath");
          _showPermissionNotification('Archivo no encontrado',
              'El archivo ya no existe en la ubicación guardada.');
        }
      } catch (e) {
        print("Error general al manejar archivo: $e");
      }
    } else {
      print("No hay una ruta de archivo válida");
    }
  }

  // Función para compartir el archivo
  Future<void> _shareFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        print("Compartiendo archivo: $filePath");
        await Share.shareXFiles([XFile(filePath)],
            text: 'Registros financieros exportados');
      } else {
        print("No se puede compartir: el archivo no existe");
      }
    } catch (e) {
      print("Error al compartir el archivo: $e");
    }
  }

  // Mostrar notificación con archivo adjunto
  Future<void> showFileDownloadNotification(
      String filePath, String fileName) async {
    try {
      // Guardar la ruta del último archivo descargado
      _lastDownloadedFilePath = filePath;
      print("Guardando ruta de archivo para notificación: $filePath");

      // Asegurarse de que las notificaciones estén inicializadas
      await initNotifications();

      // Determinar dónde se guardó el archivo para mostrar un mensaje más descriptivo
      String locationMessage = '';
      if (filePath.contains('/Download/')) {
        locationMessage = 'Se guardó en la carpeta de Descargas: $fileName';
      } else if (filePath.contains('/Android/data/')) {
        locationMessage =
            'Se guardó en el almacenamiento de la aplicación: $fileName';
      } else if (filePath.contains('/data/user/')) {
        locationMessage = 'Se guardó en el almacenamiento interno: $fileName';
      } else {
        locationMessage = 'Archivo guardado: $fileName';
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'download_channel',
        'Descargas',
        channelDescription: 'Notificaciones de archivos descargados',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: false,
        autoCancel: true,
        // El problema está en la configuración del ícono
        // Usar valor default (pequeño ícono de Android)
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      // Mostrar la notificación con el payload que es la ruta del archivo
      await flutterLocalNotificationsPlugin.show(
        DateTime.now()
            .millisecondsSinceEpoch
            .remainder(100000), // ID único para cada notificación
        'Archivo descargado',
        locationMessage,
        notificationDetails,
        payload: filePath,
      );

      print("Notificación mostrada con payload: $filePath");
    } catch (e) {
      print("Error al mostrar notificación: $e");
      // No lanzar excepción para evitar interrumpir el flujo
    }
  }

  Future<bool> sendSaveFinanceRecord(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

    try {
      await http.post(
        '${await getUrlApi()}finance/financial-record',
        data: formData,
        options: Options(
          headers: getHeader(),
        ),
      );

      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return false;
    }
  }

  Future<PaginateResponse<FinanceRecordListModel>> searchFinanceRecords(
      FinanceRecordFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
        ),
      );

      return PaginateResponse.fromJson(params.perPage, response.data,
          (data) => FinanceRecordListModel.fromJson(data));
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<String?> downloadXls(List<int> bytes, String filename) async {
    try {
      if (Platform.isAndroid) {
        // Guardar directamente en la carpeta de descargas pública
        String downloadPath = '/storage/emulated/0/Download';

        // Verificar si la carpeta existe
        Directory directory = Directory(downloadPath);
        if (!await directory.exists()) {
          print('La carpeta de descargas no existe, intentando crearla');
          await directory.create(recursive: true);
        }

        // Ruta completa del archivo
        String filePath = '$downloadPath/$filename';
        print('Guardando archivo en la carpeta de descargas: $filePath');

        // Guardar el archivo
        File file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);

        print('Archivo guardado exitosamente en la carpeta de descargas');
        return filePath;
      } else if (Platform.isIOS) {
        // Implementación para iOS
        try {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$filename';

          final file = File(filePath);
          await file.writeAsBytes(bytes);
          print('Archivo guardado en iOS: $filePath');

          return filePath;
        } catch (e) {
          print('Error al guardar archivo en iOS: $e');
          return null;
        }
      } else {
        print('Plataforma no soportada para descarga directa');
        return null;
      }
    } catch (e) {
      print('Error al guardar archivo: $e');
      return null;
    }
  }

  // Función auxiliar para mostrar notificaciones
  Future<void> _showPermissionNotification(String title, String message) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'download_channel',
        'Descargas',
        channelDescription: 'Notificaciones de archivos descargados',
        importance: Importance.high,
        priority: Priority.high,
        // El problema está en la configuración del ícono
        // Usar valor default (pequeño ícono de Android)
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        message,
        notificationDetails,
      );
    } catch (e) {
      print('Error al mostrar notificación: $e');
      // No lanzar excepción para evitar interrumpir el flujo
    }
  }

  Future<bool> exportFinanceRecords(FinanceRecordFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record/export',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = response.data as List<int>;
      final fileName = 'registros_financieros.xlsx';

      if (kIsWeb) {
        // Implementación Web sin cambios
        try {
          final blob = universal_html.Blob([bytes]);
          final url = universal_html.Url.createObjectUrlFromBlob(blob);
          final anchor = universal_html.AnchorElement(href: url)
            ..setAttribute('download', fileName)
            ..style.display = 'none';

          universal_html.document.body?.children.add(anchor);
          anchor.click();
          universal_html.document.body?.children.remove(anchor);
          universal_html.Url.revokeObjectUrl(url);

          print("Descarga web iniciada para: $fileName");
          return true;
        } catch (e) {
          print("Error en la descarga web: $e");
          return false;
        }
      }

      // Descargar el archivo
      final filePath = await downloadXls(bytes, fileName);

      // Si se descargó el archivo con éxito
      if (filePath != null) {
        print("Archivo descargado exitosamente en: $filePath");

        // Guardar la ruta del archivo descargado
        _lastDownloadedFilePath = filePath;

        // Mostrar una notificación sencilla
        try {
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
          );

          await flutterLocalNotificationsPlugin.show(
            1001,
            'Archivo descargado',
            'Se guardó en la carpeta de Descargas',
            notificationDetails,
            payload: filePath,
          );
        } catch (e) {
          print("Error al mostrar notificación: $e");
        }

        return true;
      } else {
        print("No se pudo guardar el archivo");
        return false;
      }
    } on DioException catch (e) {
      print("Error al descargar el archivo: ${e.message}");
      transformResponse(e.response?.data);
      return false;
    } catch (e) {
      print("Error inesperado: $e");
      return false;
    }
  }
}
