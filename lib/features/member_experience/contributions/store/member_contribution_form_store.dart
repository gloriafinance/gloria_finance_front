import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/websocket_service.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:gloria_finance/features/member_experience/contributions/contribution_service.dart';
import 'package:gloria_finance/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:gloria_finance/features/member_experience/contributions/state/member_contribution_form_state.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

class MemberContributionFormStore extends ChangeNotifier {
  MemberContributionFormState _state = MemberContributionFormState();
  final ContributionService _service = ContributionService();
  final AvailabilityAccountsListStore _accountsStore;
  final FinancialConceptStore _conceptStore;
  final WebSocketService _webSocketService = WebSocketService();

  MultipartFile? _receiptFile;
  late final void Function(dynamic data) _paidPixListener;

  MemberContributionFormStore(this._accountsStore, this._conceptStore) {
    _paidPixListener = _handlePaidPix;
    _webSocketService.onPaidPix(_paidPixListener);
  }

  MemberContributionFormState get state => _state;

  List<AvailabilityAccountModel> get availabilityAccounts =>
      _accountsStore.state.availabilityAccounts;

  List<FinancialConceptModel> get offeringConcepts {
    return _conceptStore.state.financialConcepts
        .where((concept) => concept.active && concept.tag == 'Offering')
        .toList();
  }

  FinancialConceptModel? get titheConcept => _findConceptByTag('Tithes');

  FinancialConceptModel? get selectedFinancialConcept {
    if (_state.selectedType == MemberContributionType.tithe) {
      return titheConcept;
    }

    final conceptId = _state.financialConceptId;
    if (conceptId == null) return null;

    for (final concept in _conceptStore.state.financialConcepts) {
      if (concept.financialConceptId == conceptId) {
        return concept;
      }
    }

    return null;
  }

  FinancialConceptPixModel? get selectedPix => selectedFinancialConcept?.pix;

  bool get canPayWithPix => selectedPix != null;

  Future<void> initialize() async {
    if (_accountsStore.state.availabilityAccounts.isEmpty) {
      await _accountsStore.searchAvailabilityAccounts();
    }

    if (_conceptStore.state.financialConcepts.isEmpty) {
      await _conceptStore.searchFinancialConcepts(
        type: FinancialConceptType.INCOME,
        updateSelectedType: true,
      );
    }

    var nextState = _state;

    if (availabilityAccounts.isNotEmpty &&
        nextState.selectedDestinationId == null) {
      nextState = nextState.copyWith(
        selectedDestinationId: availabilityAccounts.first.availabilityAccountId,
      );
    }

    if (nextState.hasSelectedType &&
        nextState.selectedType == MemberContributionType.tithe) {
      final concept = titheConcept;
      if (concept != null) {
        nextState = nextState.copyWith(
          financialConceptId: concept.financialConceptId,
        );
      }
    }

    _state = nextState;
    notifyListeners();
  }

  void selectType(MemberContributionType type) {
    final tithe = type == MemberContributionType.tithe ? titheConcept : null;

    _receiptFile = null;
    _state = _state.copyWith(
      selectedType: type,
      hasSelectedType: true,
      financialConceptId: tithe?.financialConceptId,
      clearFinancialConceptId:
          type == MemberContributionType.offering || tithe == null,
      clearSelectedChannel: true,
      clearPaidAt: true,
      clearReceiptLocalPath: true,
      clearReceiptFileName: true,
      currentStep: 1,
      isWaitingPixPayment: false,
      pixPaymentFinished: false,
    );
    notifyListeners();
  }

  void selectDestination(String destinationId) {
    _state = _state.copyWith(selectedDestinationId: destinationId);
    notifyListeners();
  }

  void setFinancialConceptId(String conceptId) {
    _receiptFile = null;
    _state = _state.copyWith(
      financialConceptId: conceptId,
      clearSelectedChannel: true,
      clearPaidAt: true,
      clearReceiptLocalPath: true,
      clearReceiptFileName: true,
      isWaitingPixPayment: false,
      pixPaymentFinished: false,
    );
    notifyListeners();
  }

  void selectAmount(double amount) {
    _state = _state.copyWith(amount: amount);
    notifyListeners();
  }

  void setCustomAmountInput(bool value) {
    _state = _state.copyWith(showCustomAmountInput: value);
    notifyListeners();
  }

  void selectPaymentChannel(MemberPaymentChannel channel) {
    if (channel == MemberPaymentChannel.pix && !canPayWithPix) {
      return;
    }

    if (channel == MemberPaymentChannel.pix) {
      _receiptFile = null;
      _state = _state.copyWith(
        selectedChannel: channel,
        clearPaidAt: true,
        clearReceiptLocalPath: true,
        clearReceiptFileName: true,
        isWaitingPixPayment: false,
        pixPaymentFinished: false,
      );
    } else {
      _state = _state.copyWith(
        selectedChannel: channel,
        isWaitingPixPayment: false,
        pixPaymentFinished: false,
      );
    }

    notifyListeners();
  }

  void nextStep() {
    switch (_state.currentStep) {
      case 1:
        if (!_state.canContinueTypeStep) return;
        _state = _state.copyWith(currentStep: 2);
        break;
      case 2:
        if (!_state.hasValidAmount) return;
        _state = _state.copyWith(currentStep: 3);
        break;
      case 3:
        final channel = _state.selectedChannel;
        if (channel == null) return;
        if (channel == MemberPaymentChannel.pix && !canPayWithPix) return;

        _state = _state.copyWith(
          currentStep: 4,
          isWaitingPixPayment: channel == MemberPaymentChannel.pix,
          pixPaymentFinished: false,
        );
        break;
      case 4:
        if (_state.selectedChannel != MemberPaymentChannel.externalWithReceipt ||
            _state.paidAt == null) {
          return;
        }
        _state = _state.copyWith(currentStep: 5);
        break;
      default:
        return;
    }

    notifyListeners();
  }

  void setMessage(String? message) {
    _state = _state.copyWith(message: message);
    notifyListeners();
  }

  void setPaidAt(DateTime date) {
    _state = _state.copyWith(paidAt: date);
    notifyListeners();
  }

  void setReceiptFile(MultipartFile file, String fileName) {
    _receiptFile = file;
    _state = _state.copyWith(
      receiptLocalPath: fileName,
      receiptFileName: fileName,
    );
    notifyListeners();
  }

  void clearReceipt() {
    _receiptFile = null;
    _state = _state.copyWith(
      clearReceiptLocalPath: true,
      clearReceiptFileName: true,
    );
    notifyListeners();
  }

  Future<bool> submitContribution(AppLocalizations l10n) async {
    if (_state.selectedChannel != MemberPaymentChannel.externalWithReceipt ||
        !_state.isValid ||
        _receiptFile == null) {
      Toast.showMessage(
        l10n.member_contribution_form_required_fields_error,
        ToastType.warning,
      );
      return false;
    }

    _state = _state.copyWith(isSubmitting: true, clearErrorMessage: true);
    notifyListeners();

    try {
      final request = MemberContributionRequest(
        type: _state.selectedType,
        destinationId: _state.selectedDestinationId,
        financialConceptId: _state.financialConceptId,
        amount: _state.amount!,
        channel: MemberPaymentChannel.externalWithReceipt,
        message: _state.message,
        paidAt: _state.paidAt,
      );

      _state = _state.copyWith(isUploadingReceipt: true);
      notifyListeners();

      await _service.registerManualContribution(request, _receiptFile);

      _state = _state.copyWith(
        isSubmitting: false,
        isUploadingReceipt: false,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isSubmitting: false,
        isUploadingReceipt: false,
        errorMessage: e.toString(),
      );
      notifyListeners();

      Toast.showMessage(
        l10n.member_contribution_form_submission_error(e.toString()),
        ToastType.error,
      );
      return false;
    }
  }

  void consumePixPaymentFinished() {
    if (!_state.pixPaymentFinished) return;
    _state = _state.copyWith(pixPaymentFinished: false);
    notifyListeners();
  }

  void reset() {
    _receiptFile = null;
    _state = MemberContributionFormState(
      selectedDestinationId:
          availabilityAccounts.isNotEmpty
              ? availabilityAccounts.first.availabilityAccountId
              : null,
    );
    notifyListeners();
  }

  FinancialConceptModel? _findConceptByTag(String tag) {
    for (final concept in _conceptStore.state.financialConcepts) {
      if (concept.active && concept.tag == tag) {
        return concept;
      }
    }

    return null;
  }

  void _handlePaidPix(dynamic data) {
    if (!_state.isWaitingPixPayment ||
        _state.selectedChannel != MemberPaymentChannel.pix ||
        _state.currentStep != 4) {
      return;
    }

    if (data is! Map || data['payment'] != 'finish') {
      return;
    }

    _state = _state.copyWith(
      isWaitingPixPayment: false,
      pixPaymentFinished: true,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _webSocketService.offPaidPix(_paidPixListener);
    super.dispose();
  }
}
