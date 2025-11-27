import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../financial_month_service.dart';
import '../state/financial_month_state.dart';

class FinancialMonthStore extends ChangeNotifier {
  final service = FinancialMonthService();
  var state = FinancialMonthState.empty();

  Future<void> loadFinancialMonths({int? year}) async {
    final selectedYear = year ?? state.selectedYear;
    state = state.copyWith(isLoading: true, selectedYear: selectedYear);
    notifyListeners();

    try {
      final months = await service.listFinancialMonths(selectedYear);
      state = state.copyWith(isLoading: false, months: months);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading financial months: $e');
      state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<bool> closeMonth(int month, int year) async {
    try {
      await service.updateFinancialMonthStatus(
        month: month,
        year: year,
        action: 'close',
      );
      Toast.showMessage('Mês fechado com sucesso!', ToastType.info);
      await loadFinancialMonths(year: year);
      return true;
    } catch (e) {
      debugPrint('Error closing month: $e');
      return false;
    }
  }

  Future<bool> openMonth(int month, int year) async {
    try {
      await service.updateFinancialMonthStatus(
        month: month,
        year: year,
        action: 'open',
      );
      Toast.showMessage('Mês reaberto com sucesso!', ToastType.info);
      await loadFinancialMonths(year: year);
      return true;
    } catch (e) {
      debugPrint('Error opening month: $e');
      return false;
    }
  }

  void setYear(int year) {
    state = state.copyWith(selectedYear: year);
    notifyListeners();
    loadFinancialMonths(year: year);
  }
}
