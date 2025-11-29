abstract class IncomeStatementPdfDownloader {
  Future<bool> savePdf(List<int> bytes, String fileName);
}
