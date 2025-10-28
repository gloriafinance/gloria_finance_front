import 'report_downloader_base.dart';
import 'report_downloader_stub.dart'
    if (dart.library.io) 'report_downloader_mobile.dart'
    if (dart.library.html) 'report_downloader_web.dart';

ReportDownloader getReportDownloader() => ReportDownloaderImpl();
