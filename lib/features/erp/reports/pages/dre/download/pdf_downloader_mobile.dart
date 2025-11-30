// lib/finance/reports/pages/dre/download/pdf_downloader_mobile.dart

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'pdf_downloader_base.dart';

class DREPdfDownloaderImpl implements DREPdfDownloader {
  @override
  Future<bool> savePdf(List<int> bytes, String fileName) async {
    try {
      if (Platform.isAndroid) {
        final downloadPath = Directory('/storage/emulated/0/Download');

        if (!await downloadPath.exists()) {
          await downloadPath.create(recursive: true);
        }

        final file = File('${downloadPath.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        return true;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      return true;
    } catch (e) {
      print('Error al guardar el PDF localmente: $e');
      return false;
    }
  }
}
