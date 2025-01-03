import 'package:church_finance_bk/finance/models/financial_concept_model.dart';

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

class FinanceRecordModel {
  final String financeRecordId;
  final double amount;
  final DateTime date;
  final FinancialConcept financialConcept;
  final String moneyLocation;
  final String type;
  final String? voucher;

  FinanceRecordModel({
    required this.financeRecordId,
    required this.amount,
    required this.date,
    required this.financialConcept,
    required this.moneyLocation,
    required this.type,
    this.voucher,
  });
}
