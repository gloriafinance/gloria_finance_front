import 'package:gloria_finance/features/member_experience/contributions/models/member_contribution_models.dart';

class MemberContributionFormState {
  MemberContributionType selectedType;
  bool hasSelectedType;
  String? selectedDestinationId;
  String? financialConceptId;
  double? amount;
  final List<double> quickAmounts;
  MemberPaymentChannel? selectedChannel;
  int currentStep;
  bool showCustomAmountInput;

  DateTime? paidAt;
  String? receiptLocalPath;
  String? receiptFileName;
  bool isUploadingReceipt;

  String? message;

  bool isSubmitting;
  bool isWaitingPixPayment;
  bool pixPaymentFinished;
  String? errorMessage;

  MemberContributionFormState({
    this.selectedType = MemberContributionType.tithe,
    this.hasSelectedType = false,
    this.selectedDestinationId,
    this.financialConceptId,
    this.amount,
    this.quickAmounts = const [20.0, 50.0, 100.0],
    this.selectedChannel,
    this.currentStep = 1,
    this.showCustomAmountInput = false,
    this.paidAt,
    this.receiptLocalPath,
    this.receiptFileName,
    this.isUploadingReceipt = false,
    this.message,
    this.isSubmitting = false,
    this.isWaitingPixPayment = false,
    this.pixPaymentFinished = false,
    this.errorMessage,
  });

  MemberContributionFormState copyWith({
    MemberContributionType? selectedType,
    bool? hasSelectedType,
    String? selectedDestinationId,
    String? financialConceptId,
    bool clearFinancialConceptId = false,
    double? amount,
    List<double>? quickAmounts,
    MemberPaymentChannel? selectedChannel,
    bool clearSelectedChannel = false,
    int? currentStep,
    bool? showCustomAmountInput,
    DateTime? paidAt,
    bool clearPaidAt = false,
    String? receiptLocalPath,
    bool clearReceiptLocalPath = false,
    String? receiptFileName,
    bool clearReceiptFileName = false,
    bool? isUploadingReceipt,
    String? message,
    bool clearMessage = false,
    bool? isSubmitting,
    bool? isWaitingPixPayment,
    bool? pixPaymentFinished,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MemberContributionFormState(
      selectedType: selectedType ?? this.selectedType,
      hasSelectedType: hasSelectedType ?? this.hasSelectedType,
      selectedDestinationId:
          selectedDestinationId ?? this.selectedDestinationId,
      financialConceptId:
          clearFinancialConceptId
              ? null
              : financialConceptId ?? this.financialConceptId,
      amount: amount ?? this.amount,
      quickAmounts: quickAmounts ?? this.quickAmounts,
      selectedChannel:
          clearSelectedChannel
              ? null
              : selectedChannel ?? this.selectedChannel,
      currentStep: currentStep ?? this.currentStep,
      showCustomAmountInput:
          showCustomAmountInput ?? this.showCustomAmountInput,
      paidAt: clearPaidAt ? null : paidAt ?? this.paidAt,
      receiptLocalPath:
          clearReceiptLocalPath
              ? null
              : receiptLocalPath ?? this.receiptLocalPath,
      receiptFileName:
          clearReceiptFileName ? null : receiptFileName ?? this.receiptFileName,
      isUploadingReceipt: isUploadingReceipt ?? this.isUploadingReceipt,
      message: clearMessage ? null : message ?? this.message,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isWaitingPixPayment:
          isWaitingPixPayment ?? this.isWaitingPixPayment,
      pixPaymentFinished: pixPaymentFinished ?? this.pixPaymentFinished,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  int get totalSteps => selectedChannel == MemberPaymentChannel.pix ? 4 : 5;

  bool get hasValidAmount => amount != null && amount! > 0;

  bool get canContinueTypeStep {
    if (!hasSelectedType) return false;
    if (selectedType == MemberContributionType.tithe) return true;
    return financialConceptId != null && financialConceptId!.isNotEmpty;
  }

  bool get isValid {
    if (!hasValidAmount || selectedChannel == null) return false;

    if (selectedType == MemberContributionType.offering &&
        (financialConceptId == null || financialConceptId!.isEmpty)) {
      return false;
    }

    if (selectedChannel == MemberPaymentChannel.externalWithReceipt) {
      if (paidAt == null) return false;
      if (receiptLocalPath == null || receiptLocalPath!.isEmpty) return false;
    }

    return true;
  }
}
