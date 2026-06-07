import 'package:gloria_finance/features/member_experience/contributions/models/member_contribution_models.dart';

class MemberContributionFormState {
  // Selection state
  MemberContributionType selectedType;
  String? selectedDestinationId;
  String? financialConceptId; // For offerings
  double? amount;
  final List<double> quickAmounts;
  MemberPaymentChannel? selectedChannel;

  // Receipt upload (for externalWithReceipt)
  DateTime? paidAt;
  String? receiptLocalPath;
  String? receiptFileName;
  bool isUploadingReceipt;

  // Optional message
  String? message;

  // Submission state
  bool isSubmitting;
  String? errorMessage;

  MemberContributionFormState({
    this.selectedType = MemberContributionType.tithe,
    this.selectedDestinationId,
    this.financialConceptId,
    this.amount,
    this.quickAmounts = const [20.0, 50.0, 100.0],
    this.selectedChannel = MemberPaymentChannel.externalWithReceipt,
    this.paidAt,
    this.receiptLocalPath,
    this.receiptFileName,
    this.isUploadingReceipt = false,
    this.message,
    this.isSubmitting = false,
    this.errorMessage,
  });

  MemberContributionFormState copyWith({
    MemberContributionType? selectedType,
    String? selectedDestinationId,
    String? financialConceptId,
    bool clearFinancialConceptId = false,
    double? amount,
    List<double>? quickAmounts,
    MemberPaymentChannel? selectedChannel,
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
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MemberContributionFormState(
      selectedType: selectedType ?? this.selectedType,
      selectedDestinationId:
          selectedDestinationId ?? this.selectedDestinationId,
      financialConceptId:
          clearFinancialConceptId
              ? null
              : financialConceptId ?? this.financialConceptId,
      amount: amount ?? this.amount,
      quickAmounts: quickAmounts ?? this.quickAmounts,
      selectedChannel: selectedChannel ?? this.selectedChannel,
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
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid {
    if (amount == null || amount! <= 0) return false;
    if (selectedDestinationId == null) return false;
    if (selectedChannel == null) return false;

    // For offerings, financial concept is required
    if (selectedType == MemberContributionType.offering) {
      if (financialConceptId == null || financialConceptId!.isEmpty) {
        return false;
      }
    }

    // Additional validation for manual receipt upload
    if (selectedChannel == MemberPaymentChannel.externalWithReceipt) {
      if (paidAt == null) return false;
      if (receiptLocalPath == null || receiptLocalPath!.isEmpty) return false;
    }

    return true;
  }
}
