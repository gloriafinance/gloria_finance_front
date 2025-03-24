import 'package:church_finance_bk/finance/contributions/contribution_service.dart';
import 'package:church_finance_bk/settings/availability_accounts/models/availability_account_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../state/form_tithes_state.dart';

class FormTitheStore extends ChangeNotifier {
  var service = ContributionService();
  FormTitheState state = FormTitheState.init();

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    notifyListeners();
  }

  void setMonth(String month) {
    state = state.copyWith(month: month);
    notifyListeners();
  }

  void setFile(MultipartFile file) {
    state = state.copyWith(file: file);
    notifyListeners();
  }

  void setBankId(String bankId) {
    state = state.copyWith(bankId: bankId);
  }

  void setAvailabilityAccount(AvailabilityAccountModel availabilityAccount) {
    state = state.copyWith(
        availabilityAccountId: availabilityAccount.availabilityAccountId);
  }

  void setFinancialConceptId(String financialConceptId) {
    state = state.copyWith(financialConceptId: financialConceptId);
  }

  void setMakeRequest(bool makeRequest) {
    state = state.copyWith(makeRequest: makeRequest);
    notifyListeners();
  }

  Future<bool> send() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await service.sendSaveContribution(state.toJson());
      state = FormTitheState.init();

      state.copyWith(makeRequest: false);

      notifyListeners();

      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();

      return false;
    }
  }
}
