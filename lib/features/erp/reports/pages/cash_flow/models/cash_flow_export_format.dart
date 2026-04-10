enum CashFlowExportFormat { csv, pdf }

extension CashFlowExportFormatX on CashFlowExportFormat {
  String get queryValue {
    switch (this) {
      case CashFlowExportFormat.csv:
        return 'csv';
      case CashFlowExportFormat.pdf:
        return 'pdf';
    }
  }

  String get fileName {
    switch (this) {
      case CashFlowExportFormat.csv:
        return 'flujo_caja_directo.csv';
      case CashFlowExportFormat.pdf:
        return 'flujo_caja_directo.pdf';
    }
  }

  String get mimeType {
    switch (this) {
      case CashFlowExportFormat.csv:
        return 'text/csv';
      case CashFlowExportFormat.pdf:
        return 'application/pdf';
    }
  }
}
