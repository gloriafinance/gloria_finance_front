// lib/finance/reports/pages/dre/download/pdf_downloader_base.dart

abstract class DREPdfDownloader {
  Future<bool> savePdf(List<int> bytes, String fileName);
}
