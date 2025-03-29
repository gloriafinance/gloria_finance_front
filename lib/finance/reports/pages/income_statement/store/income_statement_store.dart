// lib/finance/reports/pages/income_statement/store/income_statement_store.dart

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
}
