import 'package:church_finance_bk/features/erp//accounts_payable/pages/view_account_payable/state/payment_account_payable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../accounts_payable_service.dart';

class PaymentAccountPayableStore extends ChangeNotifier {
  PaymentAccountPayableState state = PaymentAccountPayableState.init();
  final _service = AccountsPayableService();

  void setAccountPayableId(String id) {
    state = state.copyWith(accountPayableId: id);
    notifyListeners();
  }

  void setInstallmentIds(List<String> ids) {
    print('ids: $ids');
    state = state.copyWith(installmentIds: ids);
    notifyListeners();
  }

  void setAvailabilityAccountId(String id) {
    state = state.copyWith(availabilityAccountId: id);
    notifyListeners();
  }

  void setCostCenterId(String id) {
    state = state.copyWith(costCenterId: id);
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
