import 'package:gloria_finance/features/erp/accounts_receivable/accounts_receivable_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../state/payment_form_state.dart';

class PaymentAccountReceiveStore extends ChangeNotifier {
  PaymentFormState state = PaymentFormState.init();
  final _service = AccountsReceivableService();

  void setSymbolFormatMoney(String symbol) {
    state = state.copyWith(symbolFormatMoney: symbol);
    notifyListeners();
  }

  void setAccountReceivableId(String id) {
    state = state.copyWith(accountReceivableId: id);
    notifyListeners();
  }

  void setInstallmentIds(List<String> ids) {
    state = state.copyWith(installmentIds: ids);
    notifyListeners();
  }

  void setAvailabilityAccountId(String id) {
    state = state.copyWith(availabilityAccountId: id);
    notifyListeners();
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    notifyListeners();
  }

  void setIsMovementBank(bool value) {
    state = state.copyWith(isMovementBank: value);
    notifyListeners();
  }

  void setFile(MultipartFile file) {
    state = state.copyWith(file: file);
    notifyListeners();
  }

  void setMakeRequest(bool value) {
    state = state.copyWith(makeRequest: value);
    notifyListeners();
  }

  Future<bool> sendPayment() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await _service.sendPayment(state.toJson());

      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();

      return false;
    }
  }
}
