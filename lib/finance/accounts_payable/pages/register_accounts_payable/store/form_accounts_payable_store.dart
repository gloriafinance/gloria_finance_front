import 'package:flutter/material.dart';

import '../../../accounts_payable_service.dart';
import '../../../models/accounts_payable_model.dart';
import '../state/form_accounts_payable_state.dart';

class FormAccountsPayableStore extends ChangeNotifier {
  final AccountsPayableService service = AccountsPayableService();
  FormAccountsPayableState state = FormAccountsPayableState.init();

  void setSupplier(String supplierId, String supplierName) {
    state = state.copyWith(
      supplierId: supplierId,
      supplierName: supplierName,
    );
    notifyListeners();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
    notifyListeners();
  }

  void addInstallment(double amount, String dueDate) {
    final newInstallment = InstallmentModel(
      amount: amount,
      dueDate: dueDate,
    );
    final installments = [...state.installments, newInstallment];
    state = state.copyWith(installments: installments);
    notifyListeners();
  }

  void removeInstallment(int index) {
    if (index >= 0 && index < state.installments.length) {
      final installments = [...state.installments];
      installments.removeAt(index);
      state = state.copyWith(installments: installments);
      notifyListeners();
    }
  }

  void updateInstallment(int index, double amount, String dueDate) {
    if (index >= 0 && index < state.installments.length) {
      final installments = [...state.installments];
      installments[index] = InstallmentModel(
        amount: amount,
        dueDate: dueDate,
      );
      state = state.copyWith(installments: installments);
      notifyListeners();
    }
  }

  Future<bool> save() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await service.saveAccountPayable(state.toJson());

      state = FormAccountsPayableState.init();
      notifyListeners();
      return true;
    } catch (e) {
      print("ERROR: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
