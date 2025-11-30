import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp/settings/banks/models/bank_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../contribution_service.dart';
import '../state/form_record_offerings_state.dart';

class FormRecordOfferingStore extends ChangeNotifier {
  var service = ContributionService();
  FormRecordOfferingState state = FormRecordOfferingState.init();

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    notifyListeners();
  }

  void setFile(MultipartFile file) {
    state = state.copyWith(file: file);
    notifyListeners();
  }

  void setBankId(String bankId) {
    state = state.copyWith(bankId: bankId);
    notifyListeners();
  }

  void setAvailabilityAccount(AvailabilityAccountModel availabilityAccount) {
    state = state.copyWith(
      availabilityAccountId: availabilityAccount.availabilityAccountId,
      bankId: _bankIdFromAvailabilityAccount(availabilityAccount),
    );
    notifyListeners();
  }

  void setAvailabilityAccountId(String availabilityAccountId) {
    state = state.copyWith(availabilityAccountId: availabilityAccountId);
    notifyListeners();
  }

  void setFinancialConceptId(String financialConceptId) {
    state = state.copyWith(financialConceptId: financialConceptId);
    notifyListeners();
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
      state = FormRecordOfferingState.init();

      state.copyWith(makeRequest: false);

      notifyListeners();

      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();

      return false;
    }
  }

  String _bankIdFromAvailabilityAccount(
    AvailabilityAccountModel availabilityAccount,
  ) {
    if (availabilityAccount.accountType != AccountType.BANK.apiValue) {
      return '';
    }

    final source = availabilityAccount.getSource();
    if (source is BankModel) {
      return source.bankId;
    }

    return '';
  }
}
