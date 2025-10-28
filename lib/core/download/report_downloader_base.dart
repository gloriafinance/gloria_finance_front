class ReportDownloadResult {
  const ReportDownloadResult({required this.success, this.filePath});

  final bool success;
  final String? filePath;
}

abstract class ReportDownloader {
  Future<ReportDownloadResult> saveFile(
    List<int> bytes,
    String fileName,
    String mimeType,
  );
}
