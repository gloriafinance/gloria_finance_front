import 'package:dio/dio.dart';

class PaymentDeclarationState {
  final String? availabilityAccountId;
  final double? amount;
  final MultipartFile? voucher;
  final bool isSubmitting;
  final Map<String, String> validationErrors;
  final String? errorMessage;

  const PaymentDeclarationState({
    this.availabilityAccountId,
    this.amount,
    this.voucher,
    this.isSubmitting = false,
    this.validationErrors = const {},
    this.errorMessage,
  });

  PaymentDeclarationState copyWith({
    String? availabilityAccountId,
    double? amount,
    MultipartFile? voucher,
    bool? isSubmitting,
    Map<String, String>? validationErrors,
    String? errorMessage,
  }) {
    return PaymentDeclarationState(
      availabilityAccountId: availabilityAccountId ?? this.availabilityAccountId,
      amount: amount ?? this.amount,
      voucher: voucher ?? this.voucher,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validationErrors: validationErrors ?? this.validationErrors,
      errorMessage: errorMessage,
    );
  }
}
