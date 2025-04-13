import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../../../accounts_receivable_service.dart';
import '../../../models/index.dart';
import '../state/form_accounts_receivable_state.dart';

class FormAccountsReceivableStore extends ChangeNotifier {
  var service = AccountsReceivableService();
  FormAccountsReceivableState state = FormAccountsReceivableState.init();

  void setDebtorType(DebtorType debtorType) {
    state = state.copyWith(
      debtorType: debtorType,
      debtorDNI: '',
      debtorName: '',
    );
    notifyListeners();
  }

  void setDebtorDNI(String debtorDNI) {
    state = state.copyWith(debtorDNI: debtorDNI);
    //notifyListeners();
  }

  void setDebtorName(String debtorName) {
    state = state.copyWith(debtorName: debtorName);
    //notifyListeners();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void addInstallment(InstallmentModel installment) {
    state = state.copyWith(
      installments: [...state.installments, installment],
    );
    notifyListeners();
  }

  void removeInstallment(int index) {
    final List<InstallmentModel> updatedInstallments = [...state.installments];
    updatedInstallments.removeAt(index);
    state = state.copyWith(installments: updatedInstallments);
    notifyListeners();
  }

  void setMember(String memberDNI, String memberName) {
    state = state.copyWith(
      debtorDNI: memberDNI,
      debtorName: memberName,
    );
    notifyListeners();
  }

  Future<void> save() async {
    try {
      final session = await AuthPersistence().restore();
      state = state.copyWith(
        makeRequest: true,
        churchId: session.churchId,
      );
      notifyListeners();

      await service.sendAccountsReceivable(state.toJson());

      state = FormAccountsReceivableState.init();
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    } catch (e) {
      print("ERROR: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      rethrow;
    }
  }
}
