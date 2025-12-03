import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:church_finance_bk/features/member_experience/contributions/contribution_service.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:church_finance_bk/features/member_experience/contributions/state/member_contribution_form_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MemberContributionFormStore extends ChangeNotifier {
  MemberContributionFormState _state = MemberContributionFormState();
  final ContributionService _service = ContributionService();
  final AvailabilityAccountsListStore _accountsStore;
  final FinancialConceptStore _conceptStore;

  MemberContributionFormStore(this._accountsStore, this._conceptStore);

  MemberContributionFormState get state => _state;
  List<AvailabilityAccountModel> get availabilityAccounts =>
      _accountsStore.state.availabilityAccounts;

  // Initialize and load accounts
  Future<void> initialize() async {
    if (_accountsStore.state.availabilityAccounts.isEmpty) {
      await _accountsStore.searchAvailabilityAccounts();
    }
    // Load financial concepts for offerings if not loaded
    if (_conceptStore.state.financialConcepts.isEmpty) {
      await _conceptStore.searchFinancialConcepts(FinancialConceptType.INCOME);
    }
    // Auto-select first account if available
    if (availabilityAccounts.isNotEmpty &&
        _state.selectedDestinationId == null) {
      _state = _state.copyWith(
        selectedDestinationId: availabilityAccounts.first.availabilityAccountId,
      );
      notifyListeners();
    }
  }

  // Selection methods
  void selectType(MemberContributionType type) {
    _state = _state.copyWith(selectedType: type);
    notifyListeners();
  }

  void selectDestination(String destinationId) {
    _state = _state.copyWith(selectedDestinationId: destinationId);
    notifyListeners();
  }

  void setFinancialConceptId(String conceptId) {
    _state = _state.copyWith(financialConceptId: conceptId);
    notifyListeners();
  }

  void selectAmount(double amount) {
    _state = _state.copyWith(amount: amount);
    notifyListeners();
  }

  void selectPaymentChannel(MemberPaymentChannel channel) {
    _state = _state.copyWith(selectedChannel: channel);
    // Reset receipt data if switching away from manual
    if (channel != MemberPaymentChannel.externalWithReceipt) {
      _state = _state.copyWith(
        paidAt: null,
        receiptLocalPath: null,
        receiptFileName: null,
      );
    }
    notifyListeners();
  }

  void setMessage(String? message) {
    _state = _state.copyWith(message: message);
    notifyListeners();
  }

  // Receipt management (for externalWithReceipt)
  void setPaidAt(DateTime date) {
    _state = _state.copyWith(paidAt: date);
    notifyListeners();
  }

  void setReceiptFile(MultipartFile file, String fileName) {
    _state = _state.copyWith(
      receiptLocalPath: fileName,
      receiptFileName: fileName,
    );
    notifyListeners();
  }

  void clearReceipt() {
    _state = _state.copyWith(receiptLocalPath: null, receiptFileName: null);
    notifyListeners();
  }

  // Main submission logic
  Future<ContributionResult?> submitContribution(
    MultipartFile? receiptFile,
  ) async {
    // Validate
    if (!_state.isValid) {
      Toast.showMessage(
        'Por favor, preencha todos os campos obrigatórios',
        ToastType.warning,
      );
      return null;
    }

    _state = _state.copyWith(isSubmitting: true, errorMessage: null);
    notifyListeners();

    try {
      final request = MemberContributionRequest(
        type: _state.selectedType,
        destinationId: _state.selectedDestinationId!,
        financialConceptId: _state.financialConceptId,
        amount: _state.amount!,
        channel: _state.selectedChannel!,
        message: _state.message,
        paidAt: _state.paidAt,
      );

      ContributionResult result;

      switch (_state.selectedChannel!) {
        case MemberPaymentChannel.pix:
          final pixResponse = await _service.createPixCharge(request);
          result = ContributionResult(
            status: MemberContributionStatus.pending,
            channel: MemberPaymentChannel.pix,
            contributionId: pixResponse.contributionId,
            pixPayload: pixResponse,
          );
          break;

        case MemberPaymentChannel.boleto:
          final boletoResponse = await _service.createBoletoCharge(request);
          result = ContributionResult(
            status: MemberContributionStatus.pending,
            channel: MemberPaymentChannel.boleto,
            contributionId: boletoResponse.contributionId,
            boletoPayload: boletoResponse,
          );
          break;

        case MemberPaymentChannel.externalWithReceipt:
          // Upload receipt first
          if (receiptFile == null) {
            throw Exception('Comprovante é obrigatório');
          }

          _state = _state.copyWith(isUploadingReceipt: true);
          notifyListeners();

          // Register manual contribution with file
          await _service.registerManualContribution(request, receiptFile);

          _state = _state.copyWith(isUploadingReceipt: false);
          notifyListeners();

          result = ContributionResult(
            status: MemberContributionStatus.pendingReview,
            channel: MemberPaymentChannel.externalWithReceipt,
            contributionId: null,
          );
          break;
      }

      _state = _state.copyWith(isSubmitting: false);
      notifyListeners();

      return result;
    } catch (e) {
      _state = _state.copyWith(
        isSubmitting: false,
        isUploadingReceipt: false,
        errorMessage: e.toString(),
      );
      notifyListeners();

      Toast.showMessage(
        'Erro ao processar contribuição: ${e.toString()}',
        ToastType.error,
      );
      return null;
    }
  }

  // Reset form
  void reset() {
    _state = MemberContributionFormState(
      selectedType: MemberContributionType.tithe,
      selectedDestinationId:
          availabilityAccounts.isNotEmpty
              ? availabilityAccounts.first.availabilityAccountId
              : null,
    );
    notifyListeners();
  }
}
