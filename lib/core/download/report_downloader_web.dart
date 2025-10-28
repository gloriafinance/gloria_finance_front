import 'package:universal_html/html.dart' as html;

import 'report_downloader_base.dart';

class ReportDownloaderImpl implements ReportDownloader {
  @override
  Future<ReportDownloadResult> saveFile(
    List<int> bytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute('download', fileName)
            ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      return const ReportDownloadResult(success: true);
    } catch (e) {
      print('Error al iniciar descarga de reporte en web: $e');
      return const ReportDownloadResult(success: false);
    }
  }
}
