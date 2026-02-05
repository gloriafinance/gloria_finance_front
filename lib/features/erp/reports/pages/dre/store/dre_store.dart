// lib/finance/reports/pages/dre/store/dre_store.dart

import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

import '../dre_service.dart';
import '../models/dre_model.dart';
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

      state = state.copyWith(data: data, makeRequest: false);

      notifyListeners();
    } catch (e) {
      print("Error al obtener el DRE: $e");
      state = state.copyWith(makeRequest: false, data: DREReportModel.empty());
      notifyListeners();
    }
  }

  Future<void> downloadDREPdf(BuildContext context) async {
    if (state.downloadingPdf) {
      return;
    }

    state = state.copyWith(downloadingPdf: true);
    notifyListeners();

    try {
      final success = await service.downloadDREPdf(state.filter);

      if (success) {
        Toast.showMessage(
          context.l10n.reports_dre_download_success,
          ToastType.info,
        );
      } else {
        Toast.showMessage(
          context.l10n.reports_dre_download_error,
          ToastType.error,
        );
      }
    } catch (e) {
      print("Error al descargar el PDF del DRE: $e");
      Toast.showMessage(
        context.l10n.reports_dre_download_error_generic,
        ToastType.error,
      );
    } finally {
      state = state.copyWith(downloadingPdf: false);
      notifyListeners();
    }
  }
}
