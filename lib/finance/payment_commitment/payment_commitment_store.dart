import 'package:flutter/material.dart';

import 'payment_commitment_service.dart';

class PaymentCommitmentState {
  final String token;
  final String action;
  final double amount;
  final String linkContract;
  final bool makeRequest;

  PaymentCommitmentState({
    required this.token,
    required this.action,
    required this.amount,
    required this.linkContract,
    required this.makeRequest,
  });

  factory PaymentCommitmentState.empty() {
    return PaymentCommitmentState(
      token: '',
      action: '',
      amount: 0.0,
      linkContract: '',
      makeRequest: false,
    );
  }

  PaymentCommitmentState copyWith({
    String? token,
    String? action,
    double? amount,
    String? linkContract,
    bool? makeRequest,
  }) {
    return PaymentCommitmentState(
      token: token ?? this.token,
      action: action ?? this.action,
      amount: amount ?? this.amount,
      linkContract: linkContract ?? this.linkContract,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }
}

class PaymentCommitmentStore extends ChangeNotifier {
  var service = PaymentCommitmentService();
  PaymentCommitmentState state = PaymentCommitmentState.empty();

  void setToken(String token) {
    state = state.copyWith(token: token);
    notifyListeners();
  }

  void setAction(String action) {
    state = state.copyWith(action: action);
    notifyListeners();
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    notifyListeners();
  }

  void setLinkContract(String linkContract) {
    state = state.copyWith(linkContract: linkContract);
    notifyListeners();
  }

  void setMakeRequest(bool makeRequest) {
    state = state.copyWith(makeRequest: makeRequest);
    notifyListeners();
  }

  Future<void> send() async {
    setMakeRequest(true);

    final link = await service.confirmOrRejectPaymentCommitment(
      state.token,
      state.action,
    );

    state = state.copyWith(linkContract: link, makeRequest: false);
    notifyListeners();
  }
}
