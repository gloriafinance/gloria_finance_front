import 'package:church_finance_bk/helpers/date_formatter.dart';

enum DebtorType { MEMBER, EXTERNAL }

extension DebtorTypeExtension on DebtorType {
  String get apiValue {
    switch (this) {
      case DebtorType.MEMBER:
        return 'MEMBER';
      case DebtorType.EXTERNAL:
        return 'EXTERNAL';
    }
  }

  String get displayName {
    switch (this) {
      case DebtorType.MEMBER:
        return 'Membro';
      case DebtorType.EXTERNAL:
        return 'Externo';
    }
  }
}

class InstallmentModel {
  final double amount;
  final String dueDate;

  InstallmentModel({
    required this.amount,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dueDate': convertDateFormat(dueDate),
    };
  }
}

class DebtorModel {
  final String debtorType;
  final String debtorDNI;
  final String name;

  DebtorModel({
    required this.debtorType,
    required this.debtorDNI,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'debtorType': debtorType,
      'debtorDNI': debtorDNI,
      'name': name,
    };
  }
}

class AccountsReceivableModel {
  final DebtorModel debtor;
  final String churchId;
  final String description;
  final List<InstallmentModel> installments;

  AccountsReceivableModel({
    required this.debtor,
    required this.churchId,
    required this.description,
    required this.installments,
  });

  Map<String, dynamic> toJson() {
    return {
      'debtor': debtor.toJson(),
      'churchId': churchId,
      'description': description,
      'installments': installments.map((i) => i.toJson()).toList(),
    };
  }
}
