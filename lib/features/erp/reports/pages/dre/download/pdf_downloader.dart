// lib/finance/reports/pages/dre/download/pdf_downloader.dart

import 'pdf_downloader_base.dart';
import 'pdf_downloader_stub.dart'
    if (dart.library.io) 'pdf_downloader_mobile.dart'
    if (dart.library.html) 'pdf_downloader_web.dart';

DREPdfDownloader getDREPdfDownloader() => DREPdfDownloaderImpl();
