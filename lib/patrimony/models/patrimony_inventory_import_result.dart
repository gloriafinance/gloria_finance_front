class PatrimonyInventoryImportResult {
  final int processed;
  final int updated;
  final int skipped;
  final int errors;

  const PatrimonyInventoryImportResult({
    required this.processed,
    required this.updated,
    required this.skipped,
    required this.errors,
  });

  factory PatrimonyInventoryImportResult.fromMap(Map<String, dynamic> map) {
    int parseCount(dynamic value) {
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
      return 0;
    }

    return PatrimonyInventoryImportResult(
      processed: parseCount(map['processed']),
      updated: parseCount(map['updated']),
      skipped: parseCount(map['skipped']),
      errors: parseCount(map['errors']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'processed': processed,
      'updated': updated,
      'skipped': skipped,
      'errors': errors,
    };
  }
}
