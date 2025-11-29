import 'package:church_finance_bk/features/erp/bank_statements/bank_statement_service.dart';
import 'package:church_finance_bk/features/erp/bank_statements/models/index.dart';
import 'package:church_finance_bk/features/erp/bank_statements/state/bank_statement_list_state.dart';
import 'package:flutter/material.dart';

class BankStatementListStore extends ChangeNotifier {
  final BankStatementService service;
  BankStatementListState state = BankStatementListState.initial();

  BankStatementListStore({BankStatementService? service})
    : service = service ?? BankStatementService();

  Future<void> fetchStatements({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(loading: true);
      notifyListeners();
    }

    try {
      final statements = await service.fetchStatements(state.filter);
      state = state.copyWith(statements: statements, loading: false);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false);
      notifyListeners();
      rethrow;
    }
  }

  Future<RetryBankStatementResponse> retryStatement(
    String bankStatementId, {
    String? churchId,
  }) async {
    final retrying = Map<String, bool>.from(state.retrying)
      ..[bankStatementId] = true;
    state = state.copyWith(retrying: retrying);
    notifyListeners();

    try {
      final response = await service.retryStatement(
        bankStatementId,
        churchId: churchId,
      );

      await fetchStatements(silent: true);
      return response;
    } catch (e) {
      rethrow;
    } finally {
      final retrying = Map<String, bool>.from(state.retrying)
        ..remove(bankStatementId);
      state = state.copyWith(retrying: retrying);
      notifyListeners();
    }
  }

  Future<LinkBankStatementResponse> linkStatement({
    required String bankStatementId,
    required String financialRecordId,
  }) async {
    final linking = Map<String, bool>.from(state.linking)
      ..[bankStatementId] = true;
    state = state.copyWith(linking: linking);
    notifyListeners();

    try {
      final response = await service.linkStatement(
        bankStatementId: bankStatementId,
        financialRecordId: financialRecordId,
      );

      await fetchStatements(silent: true);
      return response;
    } catch (e) {
      rethrow;
    } finally {
      final linking = Map<String, bool>.from(state.linking)
        ..remove(bankStatementId);
      state = state.copyWith(linking: linking);
      notifyListeners();
    }
  }

  void setBank(String? bankId) {
    state = state.copyWith(filter: state.filter.copyWith(bankId: bankId));
    notifyListeners();
  }

  void setStatus(BankStatementReconciliationStatus? status) {
    state = state.copyWith(filter: state.filter.copyWith(status: status));
    notifyListeners();
  }

  void setMonth(int? month) {
    state = state.copyWith(filter: state.filter.copyWith(month: month));
    notifyListeners();
  }

  void setYear(int? year) {
    state = state.copyWith(filter: state.filter.copyWith(year: year));
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(
      filter: state.filter.copyWith(dateFrom: range?.start, dateTo: range?.end),
    );
    notifyListeners();
  }

  void setChurchId(String? churchId) {
    state = state.copyWith(filter: state.filter.copyWith(churchId: churchId));
    notifyListeners();
  }

  void clearFilters() {
    state = state.copyWith(filter: BankStatementFilterModel.initial());
    notifyListeners();
  }
}
