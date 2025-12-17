import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:church_finance_bk/features/member_experience/commitments/service/member_commitment_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MemberCommitmentPaymentStore extends ChangeNotifier {
  final MemberCommitmentModel commitment;
  final MemberCommitmentService _service = MemberCommitmentService();

  MemberCommitmentInstallment? selectedInstallment;
  double? amount;
  DateTime? paidAt;
  MultipartFile? voucher;
  String? observation;
  String? selectedAvailabilityAccountId;

  bool isSubmitting = false;

  MemberCommitmentPaymentStore(this.commitment) {
    selectedInstallment = commitment.nextInstallment ??
        (commitment.installments.isNotEmpty
            ? commitment.installments.first
            : null);
    amount = selectedInstallment?.remainingAmount ?? commitment.amountPending;
    paidAt = DateTime.now();
    selectedAvailabilityAccountId = commitment.availabilityAccountId;
  }

  void setInstallment(MemberCommitmentInstallment installment) {
    selectedInstallment = installment;
    amount = installment.remainingAmount;
    notifyListeners();
  }

  void setAmount(double value) {
    amount = value;
    notifyListeners();
  }

  void setPaidAt(DateTime date) {
    paidAt = date;
    notifyListeners();
  }

  void setVoucher(MultipartFile file) {
    voucher = file;
    notifyListeners();
  }

  void setObservation(String? value) {
    observation = value;
    notifyListeners();
  }

  void setAvailabilityAccount(String accountId) {
    selectedAvailabilityAccountId = accountId;
    notifyListeners();
  }

  bool get isValid {
    return selectedInstallment != null &&
        amount != null &&
        amount! > 0 &&
        paidAt != null &&
        voucher != null &&
        selectedAvailabilityAccountId != null &&
        selectedAvailabilityAccountId!.isNotEmpty;
  }

  Future<bool> submit() async {
    if (!isValid) {
      return false;
    }
    isSubmitting = true;
    notifyListeners();

    try {
      await _service.declarePayment(
        accountReceivableId: commitment.accountReceivableId,
        installmentId: selectedInstallment!.installmentId,
        availabilityAccountId: selectedAvailabilityAccountId!,
        amount: amount!,
        paidAt: paidAt!,
        voucher: voucher,
        observation: observation,
      );
      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      Toast.showMessage(
        e.toString(),
        ToastType.error,
      );
      return false;
    }
  }
}
