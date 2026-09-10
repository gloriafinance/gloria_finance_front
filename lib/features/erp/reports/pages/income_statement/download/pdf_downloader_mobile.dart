import 'dart:io';

import 'package:gloria_finance/core/download/report_storage_directory.dart';

import 'pdf_downloader_base.dart';

class IncomeStatementPdfDownloaderImpl
    implements IncomeStatementPdfDownloader {
  @override
  Future<bool> savePdf(List<int> bytes, String fileName) async {
    try {
      final directory = await getReportStorageDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return true;
    } catch (e) {
      print('Error al guardar el PDF localmente: $e');
      return false;
    }
  }
}
