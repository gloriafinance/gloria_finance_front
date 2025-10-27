import 'patrimony_report_downloader_base.dart';
import 'patrimony_report_downloader_stub.dart'
    if (dart.library.io) 'patrimony_report_downloader_mobile.dart'
    if (dart.library.html) 'patrimony_report_downloader_web.dart';

PatrimonyReportDownloader getPatrimonyReportDownloader() =>
    PatrimonyReportDownloaderImpl();
