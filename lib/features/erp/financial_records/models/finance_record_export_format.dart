enum FinanceRecordExportFormat { csv, pdf }

extension FinanceRecordExportFormatX on FinanceRecordExportFormat {
  String get queryValue {
    switch (this) {
      case FinanceRecordExportFormat.csv:
        return 'csv';
      case FinanceRecordExportFormat.pdf:
        return 'pdf';
    }
  }

  String get fileName {
    switch (this) {
      case FinanceRecordExportFormat.csv:
        return 'registros_financieros.csv';
      case FinanceRecordExportFormat.pdf:
        return 'registros_financieros.pdf';
    }
  }

  String get mimeType {
    switch (this) {
      case FinanceRecordExportFormat.csv:
        return 'text/csv';
      case FinanceRecordExportFormat.pdf:
        return 'application/pdf';
    }
  }
}
