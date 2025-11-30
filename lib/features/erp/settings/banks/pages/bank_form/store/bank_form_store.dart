import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../../../bank_service.dart';
import '../../../models/bank_model.dart';
import '../state/bank_form_state.dart';

class BankFormStore extends ChangeNotifier {
  final BankService service;
  BankFormState state;

  BankFormStore({BankModel? bank})
    : service = BankService(),
      state =
          bank != null ? BankFormState.fromModel(bank) : BankFormState.init();

  void setName(String value) {
    state = state.copyWith(name: value.trim());
    notifyListeners();
  }

  void setTag(String value) {
    state = state.copyWith(tag: value.trim());
    notifyListeners();
  }

  void setAccountType(AccountBankType type) {
    state = state.copyWith(accountType: type);
    notifyListeners();
  }

  void setActive(bool value) {
    state = state.copyWith(active: value);
    notifyListeners();
  }

  void setAddressInstancePayment(String value) {
    state = state.copyWith(addressInstancePayment: value.trim());
    notifyListeners();
  }

  void setCodeBank(String value) {
    state = state.copyWith(codeBank: value.trim());
    notifyListeners();
  }

  void setAgency(String value) {
    state = state.copyWith(agency: value.trim());
    notifyListeners();
  }

  void setAccount(String value) {
    state = state.copyWith(account: value.trim());
    notifyListeners();
  }

  Future<bool> submit() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      final payload = state.toPayload(session.churchId);

      await service.saveBank(payload);

      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      debugPrint('ERROR saveBank: $e');
      return false;
    }
  }
}
