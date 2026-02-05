import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../purchase_services.dart';
import '../state/purchase_register_form_state.dart';

class PurchaseRegisterFormStore extends ChangeNotifier {
  PurchaseRegisterFormState state = PurchaseRegisterFormState.init();
  final _service = PurchaseService();

  // void setSymbolFormatMoney(String symbol) {
  //   state = state.copyWith(symbolFormatMoney: symbol);
  //   notifyListeners();
  // }

  void setMakeRequest(bool makeRequest) {
    state = state.copyWith(makeRequest: makeRequest);
    notifyListeners();
  }

  void setTotal(double total) {
    state = state.copyWith(total: total);
    notifyListeners();
  }

  void setTax(double tax) {
    state = state.copyWith(tax: tax);
    notifyListeners();
  }

  void setPurchaseDate(String purchaseDate) {
    state = state.copyWith(purchaseDate: purchaseDate);
    notifyListeners();
  }

  void setFinancialConceptId(String financialConceptId) {
    state = state.copyWith(financialConceptId: financialConceptId);
    notifyListeners();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
    notifyListeners();
  }

  void setFiles(List<MultipartFile> files) {
    state = state.copyWith(files: files);
    notifyListeners();
  }

  void setBankId(String bankId) {
    state = state.copyWith(bankId: bankId);
    notifyListeners();
  }
  
  void addItem(PurchaseItem item) {
    state = state.copyWith(items: [...state.items, item]);
    notifyListeners();
  }

  void removeItem(PurchaseItem item) {
    state = state.copyWith(items: state.items.where((i) => i != item).toList());
    notifyListeners();
  }

  void setAvailabilityAccount(AvailabilityAccountModel availabilityAccount) {
    state = state.copyWith(
      availabilityAccountId: availabilityAccount.availabilityAccountId,
      symbol: availabilityAccount.symbol,
    );
    notifyListeners();
  }

  void setIsMovementBank(bool isMovementBank) {
    state = state.copyWith(isMovementBank: isMovementBank);
    notifyListeners();
  }

  void setCostCenterId(String costCenterId) {
    state = state.copyWith(costCenterId: costCenterId);
    notifyListeners();
  }

  Future<bool> send() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await _service.sendSavePurchase(state.toJson());
      state = PurchaseRegisterFormState.init();

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
