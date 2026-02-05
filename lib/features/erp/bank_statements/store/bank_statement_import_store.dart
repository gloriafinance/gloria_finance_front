import 'package:gloria_finance/features/erp/bank_statements/bank_statement_service.dart';
import 'package:gloria_finance/features/erp/bank_statements/state/bank_statement_import_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BankStatementImportStore extends ChangeNotifier {
  final BankStatementService service;
  BankStatementImportState state = BankStatementImportState.initial();

  BankStatementImportStore({BankStatementService? service})
    : service = service ?? BankStatementService();

  void setBankId(String? bankId) {
    state = state.copyWith(bankId: bankId, bankIdHasValue: true);
    notifyListeners();
  }

  void setMonth(int? month) {
    state = state.copyWith(month: month, monthHasValue: true);
    notifyListeners();
  }

  void setYear(int? year) {
    state = state.copyWith(year: year, yearHasValue: true);
    notifyListeners();
  }

  void setFile(MultipartFile? file) {
    state = state.copyWith(file: file, fileHasValue: true);
    notifyListeners();
  }

  Future<void> importStatement() async {
    if (!state.isValid) {
      throw StateError('Cannot import statement: form is incomplete');
    }

    state = state.copyWith(importing: true);
    notifyListeners();

    try {
      await service.importBankStatement(state.toJson());
      reset();
    } catch (e) {
      state = state.copyWith(importing: false);
      notifyListeners();
      rethrow;
    }
  }

  void reset() {
    state = BankStatementImportState.initial();
    notifyListeners();
  }
}
