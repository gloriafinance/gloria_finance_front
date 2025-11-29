// lib/finance/reports/pages/dre/store/dre_store.dart

import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';

import '../dre_service.dart';
import '../state/dre_state.dart';

class DREStore extends ChangeNotifier {
  final service = DREService();
  DREState state = DREState.empty();

  void setMonth(int month) {
    state = state.copyWith(month: month);
    notifyListeners();
  }

  void setYear(int year) {
    state = state.copyWith(year: year);
    notifyListeners();
  }

  Future<void> fetchDRE() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final data = await service.fetchDRE(state.filter);

      state = state.copyWith(
        data: data,
        makeRequest: false,
      );

      notifyListeners();
    } catch (e) {
      print("Error al obtener el DRE: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }

  Future<void> downloadDREPdf() async {
    if (state.downloadingPdf) {
      return;
    }

    state = state.copyWith(downloadingPdf: true);
    notifyListeners();

    try {
      final success = await service.downloadDREPdf(state.filter);

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
      print("Error al descargar el PDF del DRE: $e");
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
