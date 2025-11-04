import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

enum FinancialRecordStatus { PENDING, CLEARED, RECONCILED, VOID }

extension FinancialRecordStatusExtension on FinancialRecordStatus {
  String get friendlyName {
    switch (this) {
      case FinancialRecordStatus.PENDING:
        return 'Pendente';
      case FinancialRecordStatus.CLEARED:
        return 'Compensado';
      case FinancialRecordStatus.RECONCILED:
        return 'Conciliado';
      case FinancialRecordStatus.VOID:
        return 'Anulado';
    }
  }

  String get apiValue {
    switch (this) {
      case FinancialRecordStatus.PENDING:
        return 'PENDING';
      case FinancialRecordStatus.CLEARED:
        return 'CLEARED';
      case FinancialRecordStatus.RECONCILED:
        return 'RECONCILED';
      case FinancialRecordStatus.VOID:
        return 'VOID';
    }
  }

  Color get color {
    switch (this) {
      case FinancialRecordStatus.PENDING:
        return AppColors.mustard;
      case FinancialRecordStatus.CLEARED:
        return AppColors.green;
      case FinancialRecordStatus.RECONCILED:
        return AppColors.blue;
      case FinancialRecordStatus.VOID:
        return Colors.red;
    }
  }

  static FinancialRecordStatus fromApiValue(String apiValue) {
    return FinancialRecordStatus.values.firstWhere(
      (status) => status.apiValue == apiValue,
    );
  }
}
