import 'package:church_finance_bk/finance/models/finance_record_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:dio/dio.dart';

class FormFinanceRecordState {
  bool makeRequest;
  double amount;
  String date;
  String financialConceptId;
  String moneyLocation;
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
    required this.moneyLocation,
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
      moneyLocation: '',
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
    String? moneyLocation,
    String? type,
    String? description,
    MultipartFile? file,
    String? bankId,
    bool? makeRequest,
  }) {
    return FormFinanceRecordState(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      moneyLocation: moneyLocation ?? this.moneyLocation,
      type: type ?? this.type,
      description: description ?? this.description,
      file: file ?? this.file,
      bankId: bankId ?? this.bankId,
      makeRequest: makeRequest ?? this.makeRequest,
      isPurchase: type == "PURCHASE",
      isMovementBank: moneyLocation == MoneyLocation.BANK.friendlyName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "date": convertDateFormat(date),
      "financialConceptId": financialConceptId,
      "moneyLocation": getMoneyLocationFromFriendlyName(moneyLocation)
          ?.toString()
          .split('.')
          .last,
      "description": description,
      "file": file,
      "bankId": bankId,
    };
  }
}
