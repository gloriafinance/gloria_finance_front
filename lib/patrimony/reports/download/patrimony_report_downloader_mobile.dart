import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'patrimony_report_downloader_base.dart';

class PatrimonyReportDownloaderImpl implements PatrimonyReportDownloader {
  @override
  Future<bool> saveFile(List<int> bytes, String fileName, String mimeType) async {
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
      print('Erro ao salvar arquivo de relatório: $e');
      return false;
    }
  }
}
