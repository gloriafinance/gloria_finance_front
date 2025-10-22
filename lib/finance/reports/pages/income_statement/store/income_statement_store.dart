import 'package:church_finance_bk/core/toast.dart';
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

  Future<void> downloadIncomeStatementPdf() async {
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
          'PDF baixado com sucesso',
          ToastType.info,
        );
      } else {
        Toast.showMessage(
          'Não foi possível baixar o PDF',
          ToastType.error,
        );
      }
    } catch (e) {
      print("Error al descargar el PDF del estado de ingresos: $e");
      Toast.showMessage(
        'Erro ao baixar o PDF',
        ToastType.error,
      );
    } finally {
      state = state.copyWith(downloadingPdf: false);
      notifyListeners();
    }
  }
}
