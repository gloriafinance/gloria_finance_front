import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'report_download_notification_service.dart';

import 'report_downloader_base.dart';

class ReportDownloaderImpl implements ReportDownloader {
  @override
  Future<ReportDownloadResult> saveFile(
    List<int> bytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      if (Platform.isAndroid) {
        final downloadDirectory = Directory('/storage/emulated/0/Download');

        if (!await downloadDirectory.exists()) {
          await downloadDirectory.create(recursive: true);
        }

        final file = File('${downloadDirectory.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        await _notifyDownload(file.path, fileName);
        return ReportDownloadResult(success: true, filePath: file.path);
      }

      if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        await _notifyDownload(file.path, fileName);
        return ReportDownloadResult(success: true, filePath: file.path);
      }
    } catch (e) {
      print('Error al guardar archivo de reporte: $e');
      return const ReportDownloadResult(success: false);
    }

    return const ReportDownloadResult(success: false);
  }

  Future<void> _notifyDownload(String filePath, String fileName) async {
    try {
      await ReportDownloadNotificationService.instance.notifyDownloadSuccess(
        filePath,
        fileName,
      );
    } catch (e) {
      print('Error al notificar descarga de reporte: $e');
    }
  }
}
