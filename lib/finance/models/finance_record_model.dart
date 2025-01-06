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

class FinancialConcept {
  final String financialConceptId;
  final String name;

  FinancialConcept({
    required this.financialConceptId,
    required this.name,
  });

  factory FinancialConcept.fromJson(Map<String, dynamic> json) {
    return FinancialConcept(
      financialConceptId: json['financialConceptId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financialConceptId': financialConceptId,
      'name': name,
    };
  }
}

class FinanceRecordModel {
  final double amount;
  final DateTime date;
  final FinancialConcept financialConcept;
  final String financialRecordId;
  final String moneyLocation;

  FinanceRecordModel({
    required this.amount,
    required this.date,
    required this.financialConcept,
    required this.financialRecordId,
    required this.moneyLocation,
  });

  factory FinanceRecordModel.fromJson(Map<String, dynamic> json) {
    return FinanceRecordModel(
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      financialConcept: FinancialConcept.fromJson(json['financialConcept']),
      financialRecordId: json['financialRecordId'],
      moneyLocation: json['moneyLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'financialConcept': financialConcept.toJson(),
      'financialRecordId': financialRecordId,
      'moneyLocation': moneyLocation,
    };
  }
}
