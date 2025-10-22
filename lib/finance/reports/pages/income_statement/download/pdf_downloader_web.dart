import 'package:universal_html/html.dart' as html;

import 'pdf_downloader_base.dart';

class IncomeStatementPdfDownloaderImpl
    implements IncomeStatementPdfDownloader {
  @override
  Future<bool> savePdf(List<int> bytes, String fileName) async {
    try {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute('download', fileName)
            ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      return true;
    } catch (e) {
      print('Error al iniciar la descarga en web: $e');
      return false;
    }
  }
}
