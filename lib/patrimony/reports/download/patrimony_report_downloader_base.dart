abstract class PatrimonyReportDownloader {
  Future<bool> saveFile(List<int> bytes, String fileName, String mimeType);
}
