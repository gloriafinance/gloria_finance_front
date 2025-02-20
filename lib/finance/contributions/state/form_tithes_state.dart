import 'package:dio/dio.dart';

class FormTitheState {
  bool makeRequest;
  double amount;
  String month;
  MultipartFile? file;
  String bankId;
  String memberId;
  String financialConceptId;
  String availabilityAccountId;

  FormTitheState({
    required this.availabilityAccountId,
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
      availabilityAccountId: '',
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
      String? availabilityAccountId,
      String? month,
      MultipartFile? file,
      String? bankId,
      String? memberId,
      String? financialConceptId,
      bool? makeRequest}) {
    return FormTitheState(
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
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
      'availabilityAccountId': availabilityAccountId,
      'amount': amount,
      'month': month,
      'file': file,
      'bankId': bankId,
      'memberId': memberId,
      'financialConceptId': financialConceptId,
    };
  }
}
