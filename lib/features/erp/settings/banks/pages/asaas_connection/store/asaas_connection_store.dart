import 'package:flutter/material.dart';

import '../../../bank_service.dart';
import '../state/asaas_connection_state.dart';

class AsaasConnectionStore extends ChangeNotifier {
  final BankService service;
  AsaasConnectionState state;

  AsaasConnectionStore({BankService? service})
    : service = service ?? BankService(),
      state = AsaasConnectionState.initial();

  void setApiKey(String value) {
    state = state.copyWith(apiKey: value);
    notifyListeners();
  }

  void setConnectionName(String value) {
    state = state.copyWith(connectionName: value);
    notifyListeners();
  }

  Future<bool> connect() async {
    final apiKey = state.apiKey.trim();
    if (apiKey.isEmpty || state.makeRequest) {
      return false;
    }

    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final connection = await service.connectAsaasAccount(apiKey: apiKey);
      state = state.copyWith(
        step: AsaasConnectionStep.confirmation,
        apiKey: '',
        makeRequest: false,
        connection: connection,
      );
      notifyListeners();
      return true;
    } catch (_) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
