import 'package:dio/dio.dart';

class PaymentAccountPayableState {
  bool makeRequest;
  String accountPayableId;
  List<String> installmentIds;
  double amount;
  bool isMovementBank;
  MultipartFile? file;
  String availabilityAccountId;
  String costCenterId;

  PaymentAccountPayableState({
    required this.makeRequest,
    required this.accountPayableId,
    required this.installmentIds,
    required this.amount,
    required this.isMovementBank,
    this.availabilityAccountId = '',
    this.costCenterId = '',
    this.file,
  });

  factory PaymentAccountPayableState.init() {
    return PaymentAccountPayableState(
      makeRequest: false,
      accountPayableId: '',
      installmentIds: [],
      amount: 0,
      isMovementBank: false,
      availabilityAccountId: '',
      costCenterId: '',
    );
  }

  PaymentAccountPayableState copyWith({
    bool? makeRequest,
    String? accountPayableId,
    List<String>? installmentIds,
    double? amount,
    bool? isMovementBank,
    MultipartFile? file,
    String? availabilityAccountId,
    String? costCenterId,
  }) {
    return PaymentAccountPayableState(
      makeRequest: makeRequest ?? this.makeRequest,
      accountPayableId: accountPayableId ?? this.accountPayableId,
      installmentIds: installmentIds ?? this.installmentIds,
      amount: amount ?? this.amount,
      isMovementBank: isMovementBank ?? this.isMovementBank,
      file: file ?? this.file,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      costCenterId: costCenterId ?? this.costCenterId,
    );
  }

  bool anyInstallmentSelected() {
    return installmentIds.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'accountPayableId': accountPayableId,
      'installmentIds': installmentIds.join(','),
      'amount': amount,
      'isMovementBank': isMovementBank,
      'file': file,
      'availabilityAccountId': availabilityAccountId,
      'costCenterId': costCenterId,
    };
  }
}
