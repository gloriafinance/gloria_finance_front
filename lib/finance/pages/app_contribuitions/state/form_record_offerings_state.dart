import 'package:dio/dio.dart';

class FormRecordOfferingState {
  bool makeRequest;
  double amount;
  String memberId;
  String financialConceptId;
  MultipartFile? file;
  String bankId;

  FormRecordOfferingState({
    required this.amount,
    required this.memberId,
    required this.financialConceptId,
    required this.bankId,
    required this.makeRequest,
    this.file,
  });

  factory FormRecordOfferingState.init() {
    return FormRecordOfferingState(
      amount: 0.0,
      memberId: '',
      financialConceptId: '',
      bankId: '',
      makeRequest: false,
    );
  }

  copyWith({
    double? amount,
    String? memberId,
    String? financialConceptId,
    String? bankId,
    bool? makeRequest,
    MultipartFile? file,
  }) {
    return FormRecordOfferingState(
      amount: amount ?? this.amount,
      memberId: memberId ?? this.memberId,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      bankId: bankId ?? this.bankId,
      makeRequest: makeRequest ?? this.makeRequest,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'memberId': memberId,
      'financialConceptId': financialConceptId,
      'bankId': bankId,
      'file': file,
    };
  }
}
