import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../finance_record_service.dart';
import '../state/form_finance_record_state.dart';

class FormFinanceRecordStore extends ChangeNotifier {
  var service = FinanceRecordService();
  FormFinanceRecordState state = FormFinanceRecordState.init();

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    notifyListeners();
  }

  void setDate(String date) {
    state = state.copyWith(date: date);
    notifyListeners();
  }

  void setFinancialConceptId(String financialConceptId) {
    state = state.copyWith(financialConceptId: financialConceptId);
    notifyListeners();
  }

  void setAvailabilityAccountId(String availabilityAccountId) {
    state = state.copyWith(availabilityAccountId: availabilityAccountId);
    notifyListeners();
  }

  void setIsMovementBank(bool isMovementBank) {
    state = state.copyWith(isMovementBank: isMovementBank);
    notifyListeners();
  }

  void setType(String type) {
    state = state.copyWith(type: type);
    notifyListeners();
  }

  void setCostCenterId(String costCenterId) {
    state = state.copyWith(costCenterId: costCenterId);
    notifyListeners();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
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

  Future<bool> send() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await service.sendSaveFinanceRecord(state.toJson());
      state = FormFinanceRecordState.init();

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
