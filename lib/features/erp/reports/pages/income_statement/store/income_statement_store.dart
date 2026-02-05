import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

import '../income_statement_service.dart';
import '../state/income_statement_state.dart';

class IncomeStatementStore extends ChangeNotifier {
  final service = IncomeStatementService();
  IncomeStatementState state = IncomeStatementState.empty();

  void setMonth(int month) {
    state = state.copyWith(month: month);
    notifyListeners();
  }

  void setYear(int year) {
    state = state.copyWith(year: year);
    notifyListeners();
  }

  Future<void> fetchIncomeStatement() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final data = await service.fetchIncomeStatement(state.filter);

      state = state.copyWith(
        data: data,
        makeRequest: false,
      );

      notifyListeners();
    } catch (e) {
      print("Error al obtener el estado de ingresos: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }

  Future<void> downloadIncomeStatementPdf(BuildContext context) async {
    if (state.downloadingPdf) {
      return;
    }

    state = state.copyWith(downloadingPdf: true);
    notifyListeners();

    try {
      final success =
          await service.downloadIncomeStatementPdf(state.filter);

      if (success) {
        Toast.showMessage(
          context.l10n.reports_income_download_success,
          ToastType.info,
        );
      } else {
        Toast.showMessage(
          context.l10n.reports_income_download_error,
          ToastType.error,
        );
      }
    } catch (e) {
      print("Error al descargar el PDF del estado de ingresos: $e");
      Toast.showMessage(
        context.l10n.reports_income_download_error_generic,
        ToastType.error,
      );
    } finally {
      state = state.copyWith(downloadingPdf: false);
      notifyListeners();
    }
  }
}
