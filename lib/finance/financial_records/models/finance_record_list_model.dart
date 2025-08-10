import 'package:church_finance_bk/settings/financial_concept/models/financial_concept_model.dart';

class AvailabilityAccount {
  final String availabilityAccountId;
  final String accountName;
  final String accountType;

  AvailabilityAccount({
    required this.availabilityAccountId,
    required this.accountName,
    required this.accountType,
  });

  factory AvailabilityAccount.fromJson(Map<String, dynamic> json) {
    return AvailabilityAccount(
      availabilityAccountId: json['availabilityAccountId'],
      accountName: json['accountName'],
      accountType: json['accountType'],
    );
  }
}

class CostCenter {
  final String costCenterId;
  final String name;

  CostCenter({required this.costCenterId, required this.name});

  factory CostCenter.fromJson(Map<String, dynamic> json) {
    return CostCenter(costCenterId: json['costCenterId'], name: json['name']);
  }
}

class FinanceRecordListModel {
  final double amount;
  final DateTime date;
  final FinancialConceptModel? financialConcept;
  final String financialRecordId;
  final String churchId;
  final String? description;
  final String type;
  final String? voucher;
  final AvailabilityAccount availabilityAccount;
  final CostCenter? costCenter;

  FinanceRecordListModel({
    this.voucher,
    this.costCenter,
    required this.amount,
    required this.date,
    required this.financialConcept,
    required this.financialRecordId,
    required this.churchId,
    required this.description,
    required this.type,
    required this.availabilityAccount,
  });

  factory FinanceRecordListModel.fromJson(Map<String, dynamic> json) {
    return FinanceRecordListModel(
      availabilityAccount: AvailabilityAccount.fromJson(
        json['availabilityAccount'],
      ),
      voucher: json['voucher'],
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
      financialConcept:
          json['financialConcept'] != null
              ? FinancialConceptModel.fromJson(json['financialConcept'])
              : null,
      financialRecordId: json['financialRecordId'],
      churchId: json['churchId'],
      description: json['description'],
      type: json['type'],
      costCenter:
          json['costCenter'] != null
              ? CostCenter.fromJson(json['costCenter'])
              : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'voucher': voucher,
  //     'amount': amount,
  //     'date': date.toIso8601String(),
  //     'financialConcept': financialConcept.toJson(),
  //     'financialRecordId': financialRecordId,
  //     'churchId': churchId,
  //     'description': description,
  //     'type': type,
  //     //'availabilityAccount': availabilityAccountId,
  //   };
  // }
}
