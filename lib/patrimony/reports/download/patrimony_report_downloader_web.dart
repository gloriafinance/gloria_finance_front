import 'package:universal_html/html.dart' as html;

import 'patrimony_report_downloader_base.dart';

class PatrimonyReportDownloaderImpl implements PatrimonyReportDownloader {
  @override
  Future<bool> saveFile(List<int> bytes, String fileName, String mimeType) async {
    try {
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      return true;
    } catch (e) {
      print('Erro ao iniciar download de relatório na web: $e');
      return false;
    }
  }
}
