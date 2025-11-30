import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/financial_records/finance_record_service.dart';
import 'package:church_finance_bk/features/erp/financial_records/models/finance_record_export_format.dart';
import 'package:flutter/material.dart';

import '../state/finance_record_paginate_state.dart';

class FinanceRecordPaginateStore extends ChangeNotifier {
  var service = FinanceRecordService();
  FinanceRecordPaginateState state = FinanceRecordPaginateState.empty();
  bool _exporting = false;

  bool get exporting => _exporting;

  void setFinancialConceptId(String financialConceptId) {
    state = state.copyWith(financialConceptId: financialConceptId);
    notifyListeners();
  }

  void setConceptType(String conceptType) {
    state = state.copyWith(conceptType: conceptType);
    notifyListeners();
  }

  void setAvailabilityAccountId(String availabilityAccountId) {
    state = state.copyWith(availabilityAccountId: availabilityAccountId);
    notifyListeners();
  }

  void setStartDate(String startDate) {
    state = state.copyWith(startDate: convertDateFormatToDDMMYYYY(startDate));
    notifyListeners();
  }

  void setEndDate(String endDate) {
    state = state.copyWith(endDate: convertDateFormatToDDMMYYYY(endDate));
    notifyListeners();
  }

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage);
    notifyListeners();
    searchFinanceRecords();
  }

  void nextPage() {
    state = state.copyWith(page: state.filter.page + 1);
    notifyListeners();

    searchFinanceRecords();
  }

  void prevPage() {
    if (state.filter.page > 1) {
      state = state.copyWith(page: state.filter.page - 1);
      notifyListeners();

      searchFinanceRecords();
    }
  }

  void apply() {
    notifyListeners();
    searchFinanceRecords();
  }

  void clearFilters() {
    state = FinanceRecordPaginateState.empty();
    notifyListeners();
    searchFinanceRecords();
  }

  Future<void> searchFinanceRecords() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final paginate = await service.searchFinanceRecords(state.filter);

      state = state.copyWith(makeRequest: false, paginate: paginate);

      notifyListeners();
    } catch (e) {
      print("ERRROR ${e}");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }

  Future<bool> exportFinanceRecords(FinanceRecordExportFormat format) async {
    try {
      _exporting = true;
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final result = await service.exportFinanceRecords(
        state.filter,
        format: format,
      );

      _exporting = false;
      state = state.copyWith(makeRequest: false);
      notifyListeners();

      return result;
    } catch (e) {
      print("ERROR EN EXPORTACIÓN: ${e}");
      _exporting = false;
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelFinanceRecord(String id) async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await service.cancelFinanceRecord(id);

      state = state.copyWith(makeRequest: false);
      notifyListeners();

      return true;
    } catch (e) {
      print("ERROR EN CANCELACIÓN: ${e}");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
