import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

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

  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case FinancialRecordStatus.PENDING:
        return l10n.finance_records_status_pending;
      case FinancialRecordStatus.CLEARED:
        return l10n.finance_records_status_cleared;
      case FinancialRecordStatus.RECONCILED:
        return l10n.finance_records_status_reconciled;
      case FinancialRecordStatus.VOID:
        return l10n.finance_records_status_void;
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
