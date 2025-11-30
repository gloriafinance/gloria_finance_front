import 'pdf_downloader_base.dart';

class IncomeStatementPdfDownloaderImpl
    implements IncomeStatementPdfDownloader {
  @override
  Future<bool> savePdf(List<int> bytes, String fileName) async {
    return false;
  }
}
