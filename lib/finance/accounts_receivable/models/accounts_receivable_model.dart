import 'package:church_finance_bk/helpers/date_formatter.dart';

import 'debtor_model.dart';
import 'installment_model.dart';

enum AccountsReceivableStatus {
  PENDING,
  PAID,
}

extension AccountsReceivableStatusExtension on AccountsReceivableStatus {
  String get friendlyName {
    switch (this) {
      case AccountsReceivableStatus.PENDING:
        return 'Pendente';
      case AccountsReceivableStatus.PAID:
        return 'Pago';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountsReceivableStatus.PENDING:
        return 'PENDING';
      case AccountsReceivableStatus.PAID:
        return 'PAID';
    }
  }
}

class AccountsReceivableModel {
  final DebtorModel debtor;
  final String churchId;
  final String description;
  final List<InstallmentModel> installments;

  final double? amountPaid;
  final double? amountPending;
  final double? amountTotal;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountsReceivableModel({
    required this.debtor,
    required this.churchId,
    required this.description,
    required this.installments,
    this.amountPaid,
    this.amountPending,
    this.amountTotal,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  AccountsReceivableModel.fromJson(Map<String, dynamic> map)
      : debtor = DebtorModel.fromMap(map['debtor']),
        churchId = map['churchId'],
        description = map['description'],
        installments = (map['installments'] as List)
            .map((i) => InstallmentModel.fromJson(i))
            .toList(),
        status = map['status'],
        amountPaid = double.parse(map['amountPaid'].toString()),
        amountPending = double.parse(map['amountPending'].toString()),
        amountTotal = double.parse(map['amountTotal'].toString()),
        createdAt = DateTime.parse(map['createdAt']),
        updatedAt = DateTime.parse(map['updatedAt']);

  String get createdAtFormatted {
    return convertDateFormatToDDMMYYYY(createdAt.toString());
  }

  String get updatedAtFormatted {
    return convertDateFormatToDDMMYYYY(updatedAt.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'debtor': debtor.toJson(),
      'churchId': churchId,
      'description': description,
      'installments': installments.map((i) => i.toJson()).toList(),
    };
  }
}
