import 'report_downloader_base.dart';

class ReportDownloaderImpl implements ReportDownloader {
  @override
  Future<ReportDownloadResult> saveFile(
    List<int> bytes,
    String fileName,
    String mimeType,
  ) async {
    return const ReportDownloadResult(success: false);
  }
}
