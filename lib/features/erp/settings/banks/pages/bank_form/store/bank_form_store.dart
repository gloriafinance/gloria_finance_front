import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../../../bank_service.dart';
import '../../../models/bank_model.dart';
import '../state/bank_form_state.dart';

class BankFormStore extends ChangeNotifier {
  final BankService service;
  BankFormState state;

  BankFormStore({
    BankModel? bank,
    required BankInstructionType instructionType,
  }) : service = BankService(),
       state =
           bank != null
               ? BankFormState.fromModel(
                 bank,
                 instructionType: instructionType,
               )
               : BankFormState.init(instructionType: instructionType);

  void setName(String value) {
    state = state.copyWith(name: value.trim());
    notifyListeners();
  }

  void setTag(String value) {
    state = state.copyWith(tag: value.trim());
    notifyListeners();
  }

  void setBankName(String value) {
    final trimmed = value.trim();
    state = state.copyWith(name: trimmed, tag: trimmed);
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
    if (state.instructionType == BankInstructionType.venezuela) {
      state = state.copyWith(addressInstancePayment: 'PAGO_MOVIL');
    } else {
      state = state.copyWith(addressInstancePayment: value.trim());
    }
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

  void setHolderName(String value) {
    state = state.copyWith(holderName: value.trim());
    notifyListeners();
  }

  void setDocumentId(String value) {
    state = state.copyWith(documentId: value.trim());
    notifyListeners();
  }

  void setAccountNumber(String value) {
    state = state.copyWith(accountNumber: value.trim());
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
