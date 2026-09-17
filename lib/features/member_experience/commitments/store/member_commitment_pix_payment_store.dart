import 'package:flutter/material.dart';
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
  final MemberCommitmentInstallment installment;

  MemberCommitmentPixPayment? payment;
  MemberCommitmentPixPaymentUiStatus status =
      MemberCommitmentPixPaymentUiStatus.idle;
  String? errorMessage;

  MemberCommitmentPixPaymentStore(
    this.installment, {
    MemberCommitmentService? service,
  }) : _service = service ?? MemberCommitmentService();

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

  void retry() {
    createPayment();
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
}
