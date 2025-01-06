import 'package:church_finance_bk/finance/models/finance_record_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class FormFinanceRecordState extends ChangeNotifier {
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
  }) {
    this.amount = amount ?? this.amount;
    this.date = date ?? this.date;
    this.financialConceptId = financialConceptId ?? this.financialConceptId;
    this.moneyLocation = moneyLocation ?? this.moneyLocation;
    this.type = type ?? this.type;
    this.description = description ?? this.description;
    this.file = file ?? this.file;
    isPurchase = type == "PURCHASE";
    isMovementBank = moneyLocation == MoneyLocation.BANK.friendlyName;
    this.bankId = bankId ?? this.bankId;

    notifyListeners();
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
