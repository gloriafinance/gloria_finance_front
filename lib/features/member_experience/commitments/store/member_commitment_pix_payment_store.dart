import 'package:flutter/material.dart';
import 'package:gloria_finance/core/websocket_service.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:gloria_finance/features/member_experience/commitments/service/member_commitment_service.dart';

enum MemberCommitmentPixPaymentUiStatus {
  idle,
  loading,
  waiting,
  paid,
  expired,
  error,
  unknown,
}

class MemberCommitmentPixPaymentStore extends ChangeNotifier {
  final MemberCommitmentService _service;
  final WebSocketService _webSocketService;
  final MemberCommitmentInstallment installment;
  late final void Function(dynamic data) _paidPixListener;

  MemberCommitmentPixPayment? payment;
  MemberCommitmentPixPaymentUiStatus status =
      MemberCommitmentPixPaymentUiStatus.idle;
  String? errorMessage;

  MemberCommitmentPixPaymentStore(
    this.installment, {
    MemberCommitmentService? service,
    WebSocketService? webSocketService,
  }) : _service = service ?? MemberCommitmentService(),
       _webSocketService = webSocketService ?? WebSocketService() {
    _paidPixListener = _handlePaidPix;
    _webSocketService.onPaidPix(_paidPixListener);
  }

  bool get isLoading => status == MemberCommitmentPixPaymentUiStatus.loading;

  Future<bool> createPayment() async {
    if (isLoading) return false;
    status = MemberCommitmentPixPaymentUiStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      payment = await _service.createPixPayment(
        installmentId: installment.installmentId,
        amount: installment.remainingAmount,
      );
      status = _statusFor(payment!.status);
      if (status == MemberCommitmentPixPaymentUiStatus.unknown &&
          payment!.copyPaste != null) {
        status = MemberCommitmentPixPaymentUiStatus.waiting;
      }
      notifyListeners();
      return true;
    } catch (error) {
      status = MemberCommitmentPixPaymentUiStatus.error;
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  void retry() => createPayment();

  void _handlePaidPix(dynamic data) {
    if (payment == null ||
        status != MemberCommitmentPixPaymentUiStatus.waiting) {
      return;
    }

    if (data is! Map || data['payment'] != 'finish') {
      return;
    }

    status = MemberCommitmentPixPaymentUiStatus.paid;
    notifyListeners();
  }

  MemberCommitmentPixPaymentUiStatus _statusFor(String value) {
    switch (value.toUpperCase()) {
      case 'PAID':
      case 'RECEIVED':
        return MemberCommitmentPixPaymentUiStatus.paid;
      case 'EXPIRED':
        return MemberCommitmentPixPaymentUiStatus.expired;
      case 'CREATED':
      case 'PENDING':
      case 'AWAITING_PAYMENT':
        return MemberCommitmentPixPaymentUiStatus.waiting;
      default:
        return MemberCommitmentPixPaymentUiStatus.unknown;
    }
  }

  @override
  void dispose() {
    _webSocketService.offPaidPix(_paidPixListener);
    super.dispose();
  }
}
