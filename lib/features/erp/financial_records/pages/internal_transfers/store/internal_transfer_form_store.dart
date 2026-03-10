import 'package:flutter/material.dart';

import 'package:gloria_finance/features/erp/financial_records/finance_record_service.dart';

import '../state/internal_transfer_form_state.dart';

class InternalTransferFormStore extends ChangeNotifier {
  final service = FinanceRecordService();
  InternalTransferFormState state = InternalTransferFormState.init();

  void setFromAvailabilityAccountId(String value) {
    state = state.copyWith(fromAvailabilityAccountId: value);
    notifyListeners();
  }

  void setToAvailabilityAccountId(String value) {
    state = state.copyWith(toAvailabilityAccountId: value);
    notifyListeners();
  }

  void setDate(String value) {
    state = state.copyWith(date: value);
    notifyListeners();
  }

  void setAmount(double value) {
    state = state.copyWith(amount: value);
    notifyListeners();
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
    notifyListeners();
  }

  void setSymbolFormatMoney(String symbol) {
    state = state.copyWith(symbolFormatMoney: symbol);
    notifyListeners();
  }

  Future<bool> send() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await service.sendInternalTransfer(state.toJson());

      state = InternalTransferFormState.init();
      notifyListeners();

      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
