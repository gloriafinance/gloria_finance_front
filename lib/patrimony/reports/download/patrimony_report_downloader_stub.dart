import 'patrimony_report_downloader_base.dart';

class PatrimonyReportDownloaderImpl implements PatrimonyReportDownloader {
  @override
  Future<bool> saveFile(List<int> bytes, String fileName, String mimeType) async {
    return false;
  }
}
