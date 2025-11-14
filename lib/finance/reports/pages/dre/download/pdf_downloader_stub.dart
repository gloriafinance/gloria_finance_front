// lib/finance/reports/pages/dre/download/pdf_downloader_stub.dart

import 'pdf_downloader_base.dart';

class DREPdfDownloaderImpl implements DREPdfDownloader {
  @override
  Future<bool> savePdf(List<int> bytes, String fileName) async {
    throw UnsupportedError('DRE PDF download not supported on this platform');
  }
}
