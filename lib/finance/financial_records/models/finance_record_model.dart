import 'package:church_finance_bk/settings/financial_concept/models/financial_concept_model.dart';

enum MoneyLocation { BANK, CASH, WALLET, INVESTMENT }

extension MoneyLocationExtension on MoneyLocation {
  String get friendlyName {
    switch (this) {
      case MoneyLocation.BANK:
        return 'Banco';
      case MoneyLocation.CASH:
        return 'Dinheiro';
      case MoneyLocation.WALLET:
        return 'Carteira Digital';
      case MoneyLocation.INVESTMENT:
        return 'Investimento';
    }
  }

  String get apiValue {
    switch (this) {
      case MoneyLocation.BANK:
        return 'BANK';
      case MoneyLocation.CASH:
        return 'CASH';
      case MoneyLocation.WALLET:
        return 'WALLET';
      case MoneyLocation.INVESTMENT:
        return 'INVESTMENT';
    }
  }
}

String getFriendlyNameMoneyLocation(String apiValue) {
  final moneyLocation = MoneyLocation.values
      .firstWhere((e) => e.toString().split('.').last == apiValue);

  return moneyLocation.friendlyName;
}

MoneyLocation? getMoneyLocationFromFriendlyName(String? friendlyName) {
  if (friendlyName == null || friendlyName.isEmpty) return null;

  for (var location in MoneyLocation.values) {
    if (location.friendlyName == friendlyName) {
      return location;
    }
  }
  return null;
}

class FinanceRecordModel {
  final double amount;
  final DateTime date;
  final FinancialConceptModel financialConcept;
  final String financialRecordId;
  final String moneyLocation;
  final String churchId;
  final String description;
  final String type;
  final String? voucher;

  FinanceRecordModel({
    this.voucher,
    required this.amount,
    required this.date,
    required this.financialConcept,
    required this.financialRecordId,
    required this.moneyLocation,
    required this.churchId,
    required this.description,
    required this.type,
  });

  factory FinanceRecordModel.fromJson(Map<String, dynamic> json) {
    return FinanceRecordModel(
      voucher: json['voucher'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      financialConcept:
          FinancialConceptModel.fromJson(json['financialConcept']),
      financialRecordId: json['financialRecordId'],
      moneyLocation: json['moneyLocation'],
      churchId: json['churchId'],
      description: json['description'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voucher': voucher,
      'amount': amount,
      'date': date.toIso8601String(),
      'financialConcept': financialConcept.toJson(),
      'financialRecordId': financialRecordId,
      'moneyLocation': moneyLocation,
      'churchId': churchId,
      'description': description,
      'type': type,
    };
  }
}
