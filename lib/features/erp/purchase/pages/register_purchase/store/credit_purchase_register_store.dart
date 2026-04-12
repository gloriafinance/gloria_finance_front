import 'package:dio/dio.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/state/form_accounts_payable_state.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/store/form_accounts_payable_store.dart';
import 'package:gloria_finance/features/erp/purchase/purchase_services.dart';
import 'package:flutter/material.dart';

import '../state/credit_purchase_register_state.dart';
import '../state/purchase_register_form_state.dart';

class CreditPurchaseRegisterStore extends FormAccountsPayableStore {
  final PurchaseService _service = PurchaseService();
  CreditPurchaseRegisterState purchaseState = CreditPurchaseRegisterState.init();

  @override
  void setSymbolFormatMoney(String symbol) {
    if (purchaseState.symbolFormatMoney == symbol &&
        state.symbolFormatMoney == symbol) {
      return;
    }

    purchaseState = purchaseState.copyWith(symbolFormatMoney: symbol);
    super.setSymbolFormatMoney(symbol);
  }

  void setCostCenterId(String costCenterId) {
    purchaseState = purchaseState.copyWith(costCenterId: costCenterId);
    notifyListeners();
  }

  void setPurchaseDate(String purchaseDate) {
    purchaseState = purchaseState.copyWith(purchaseDate: purchaseDate);
    notifyListeners();
  }

  void setTotal(double total) {
    purchaseState = purchaseState.copyWith(total: total);
    super.setTotalAmount(total);
  }

  void setTax(double tax) {
    purchaseState = purchaseState.copyWith(tax: tax);
    notifyListeners();
  }

  void setFiles(List<MultipartFile> files) {
    purchaseState = purchaseState.copyWith(files: files);
    notifyListeners();
  }

  void addItem(PurchaseItem item) {
    purchaseState = purchaseState.copyWith(
      items: [...purchaseState.items, item],
    );
    notifyListeners();
  }

  void removeItem(PurchaseItem item) {
    purchaseState = purchaseState.copyWith(
      items: purchaseState.items.where((current) => current != item).toList(),
    );
    notifyListeners();
  }

  @override
  void setPaymentMode(AccountsPayablePaymentMode mode) {
    super.setPaymentMode(mode);
    if (purchaseState.total > 0) {
      super.setTotalAmount(purchaseState.total);
    }
  }

  double get installmentsTotal {
    return state.installments.fold<double>(
      0,
      (acc, installment) => acc + installment.amount,
    );
  }

  bool get hasInstallmentsTotalMismatch {
    if (state.paymentMode != AccountsPayablePaymentMode.automatic) {
      return false;
    }

    if (purchaseState.total <= 0 || state.installments.isEmpty) {
      return false;
    }

    return (installmentsTotal - purchaseState.total).abs() > 0.01;
  }

  Future<bool> send() async {
    if (state.paymentMode == AccountsPayablePaymentMode.automatic &&
        state.installments.isEmpty) {
      generateAutomaticInstallments();
    }

    purchaseState = purchaseState.copyWith(makeRequest: true);
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await _service.sendSaveCreditPurchase(_toJson());
      _resetState();
      return true;
    } catch (_) {
      purchaseState = purchaseState.copyWith(makeRequest: false);
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  Map<String, dynamic> _toJson() {
    final payload = <String, dynamic>{
      ...state.toJson(),
      'costCenterId': purchaseState.costCenterId,
      'purchaseDate': convertDateFormat(purchaseState.purchaseDate),
      'total': purchaseState.total,
      'tax': purchaseState.tax,
      'amountTotal': purchaseState.total,
      'items': purchaseState.items.map((item) => item.toJson()).toList(),
    };

    if (purchaseState.files.isNotEmpty) {
      payload['file'] = purchaseState.files;
    }

    return payload;
  }

  void _resetState() {
    final symbol = purchaseState.symbolFormatMoney;
    purchaseState = CreditPurchaseRegisterState.init(
      symbolFormatMoney: symbol,
    );
    state = FormAccountsPayableState.init().copyWith(
      symbolFormatMoney: symbol,
    );
    notifyListeners();
  }
}
