import 'package:dio/dio.dart';

class FormTitheState {
  bool makeRequest;
  double amount;
  String month;
  MultipartFile? file;
  String bankId;
  String memberId;
  String financialConceptId;

  FormTitheState({
    required this.amount,
    required this.month,
    required this.bankId,
    required this.memberId,
    required this.financialConceptId,
    required this.makeRequest,
    this.file,
  });

  factory FormTitheState.init() {
    return FormTitheState(
      amount: 0.0,
      month: '',
      bankId: '',
      memberId: '',
      financialConceptId: '',
      makeRequest: false,
    );
  }

  copyWith(
      {double? amount,
      String? month,
      MultipartFile? file,
      String? bankId,
      String? memberId,
      String? financialConceptId,
      bool? makeRequest}) {
    return FormTitheState(
      amount: amount ?? this.amount,
      month: month ?? this.month,
      file: file ?? this.file,
      bankId: bankId ?? this.bankId,
      memberId: memberId ?? this.memberId,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'month': month,
      'file': file,
      'bankId': bankId,
      'memberId': memberId,
      'financialConceptId': financialConceptId,
    };
  }
}
