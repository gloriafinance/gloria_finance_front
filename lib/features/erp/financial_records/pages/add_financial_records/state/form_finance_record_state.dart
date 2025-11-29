import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
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
  bool isPurchase = false;
  bool isMovementBank = false;
  String costCenterId;

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
    required this.costCenterId,
  });

  factory FormFinanceRecordState.init() {
    return FormFinanceRecordState(
      costCenterId: '',
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
    bool? makeRequest,
    bool? isMovementBank,
    String? costCenterId,
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
      makeRequest: makeRequest ?? this.makeRequest,
      isPurchase: type == FinancialConceptType.PURCHASE.apiValue,
      isMovementBank: isMovementBank ?? this.isMovementBank,
      costCenterId: costCenterId ?? this.costCenterId,
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
      "costCenterId": costCenterId,
    };
  }
}
