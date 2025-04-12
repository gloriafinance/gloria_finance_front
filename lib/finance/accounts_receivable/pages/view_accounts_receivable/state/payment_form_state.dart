import 'package:dio/dio.dart';

class PaymentFormState {
  bool makeRequest;
  String accountReceivableId;
  List<String> installmentIds;
  String availabilityAccountId;
  double amount;
  bool isMovementBank;
  MultipartFile? file;

  PaymentFormState({
    required this.makeRequest,
    required this.accountReceivableId,
    required this.installmentIds,
    required this.availabilityAccountId,
    required this.amount,
    required this.isMovementBank,
    this.file,
  });

  factory PaymentFormState.init() {
    return PaymentFormState(
      makeRequest: false,
      accountReceivableId: '',
      installmentIds: [],
      availabilityAccountId: '',
      amount: 0,
      isMovementBank: false,
    );
  }

  PaymentFormState copyWith({
    bool? makeRequest,
    String? accountReceivableId,
    List<String>? installmentIds,
    String? availabilityAccountId,
    double? amount,
    bool? isMovementBank,
    MultipartFile? file,
  }) {
    return PaymentFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      accountReceivableId: accountReceivableId ?? this.accountReceivableId,
      installmentIds: installmentIds ?? this.installmentIds,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      amount: amount ?? this.amount,
      isMovementBank: isMovementBank ?? this.isMovementBank,
      file: file ?? this.file,
    );
  }

  bool anyInstallmentSelected() {
    return installmentIds.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'accountReceivableId': accountReceivableId,
      'installmentId': installmentIds.join(','),
      'availabilityAccountId': availabilityAccountId,
      'amount': amount,
      'isMovementBank': isMovementBank,
      'file': file,
    };
  }
}
