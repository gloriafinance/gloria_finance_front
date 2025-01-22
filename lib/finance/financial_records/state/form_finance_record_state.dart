import 'package:church_finance_bk/helpers/index.dart';
import 'package:dio/dio.dart';

class FormFinanceRecordState {
  bool makeRequest;
  double amount;
  String date;
  String financialConceptId;
  String availabilityAccountId;
  String type;
  String description;
  MultipartFile? file;
  String? bankId;
  bool isPurchase = false;
  bool isMovementBank = false;

  FormFinanceRecordState({
    required this.makeRequest,
    required this.amount,
    required this.date,
    required this.financialConceptId,
    required this.availabilityAccountId,
    required this.type,
    required this.description,
    this.file,
    required this.isPurchase,
    required this.isMovementBank,
    this.bankId,
  });

  factory FormFinanceRecordState.init() {
    return FormFinanceRecordState(
      makeRequest: false,
      amount: 0.0,
      date: '',
      availabilityAccountId: '',
      type: '',
      description: '',
      financialConceptId: '',
      isPurchase: false,
      isMovementBank: false,
    );
  }

  copyWith({
    double? amount,
    String? date,
    String? financialConceptId,
    String? availabilityAccountId,
    String? type,
    String? description,
    MultipartFile? file,
    String? bankId,
    bool? makeRequest,
    bool? isMovementBank,
  }) {
    return FormFinanceRecordState(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      type: type ?? this.type,
      description: description ?? this.description,
      file: file ?? this.file,
      bankId: bankId ?? this.bankId,
      makeRequest: makeRequest ?? this.makeRequest,
      isPurchase: type == "PURCHASE",
      isMovementBank: isMovementBank ?? this.isMovementBank,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "date": convertDateFormat(date),
      "financialConceptId": financialConceptId,
      "availabilityAccountId": availabilityAccountId,
      "description": description,
      "file": file,
      "bankId": bankId,
    };
  }
}
