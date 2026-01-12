import 'package:church_finance_bk/core/utils/date_formatter.dart';
import 'package:church_finance_bk/core/utils/index.dart';

import '../../models/installment_model.dart';
import 'debtor_model.dart';

enum AccountsReceivableStatus { PENDING, PAID, PENDING_ACCEPTANCE, DENIED }

extension AccountsReceivableStatusExtension on AccountsReceivableStatus {
  String get friendlyName {
    switch (this) {
      case AccountsReceivableStatus.PENDING:
        return 'Pendente';
      case AccountsReceivableStatus.PAID:
        return 'Pago';
      case AccountsReceivableStatus.PENDING_ACCEPTANCE:
        return 'Pendente de Aceite';
      case AccountsReceivableStatus.DENIED:
        return 'Recusado';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountsReceivableStatus.PENDING:
        return 'PENDING';
      case AccountsReceivableStatus.PAID:
        return 'PAID';
      case AccountsReceivableStatus.PENDING_ACCEPTANCE:
        return 'PENDING_ACCEPTANCE';
      case AccountsReceivableStatus.DENIED:
        return 'DENIED';
    }
  }
}

class AccountsReceivableStatusHelper {
  static AccountsReceivableStatus? fromApiValue(String? value) {
    if (value == null) return null;

    try {
      return AccountsReceivableStatus.values.firstWhere(
        (element) => element.apiValue == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum AccountsReceivableType {
  CONTRIBUTION,
  SERVICE,
  INTERINSTITUTIONAL,
  RENTAL,
  LOAN,
  FINANCIAL,
  LEGAL,
}

extension AccountsReceivableTypeExtension on AccountsReceivableType {
  String get friendlyName {
    switch (this) {
      case AccountsReceivableType.CONTRIBUTION:
        return 'Contribuição';
      case AccountsReceivableType.SERVICE:
        return 'Serviço';
      case AccountsReceivableType.INTERINSTITUTIONAL:
        return 'Interinstitucional';
      case AccountsReceivableType.RENTAL:
        return 'Locação';
      case AccountsReceivableType.LOAN:
        return 'Empréstimo';
      case AccountsReceivableType.FINANCIAL:
        return 'Financeiro';
      case AccountsReceivableType.LEGAL:
        return 'Jurídico';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountsReceivableType.CONTRIBUTION:
        return 'CONTRIBUTION';
      case AccountsReceivableType.SERVICE:
        return 'SERVICE';
      case AccountsReceivableType.INTERINSTITUTIONAL:
        return 'INTERINSTITUTIONAL';
      case AccountsReceivableType.RENTAL:
        return 'RENTAL';
      case AccountsReceivableType.LOAN:
        return 'LOAN';
      case AccountsReceivableType.FINANCIAL:
        return 'FINANCIAL';
      case AccountsReceivableType.LEGAL:
        return 'LEGAL';
    }
  }
}

class AccountsReceivableTypeHelper {
  static AccountsReceivableType? fromApiValue(String? value) {
    if (value == null) return null;

    try {
      return AccountsReceivableType.values.firstWhere(
        (element) => element.apiValue == value,
      );
    } catch (_) {
      return null;
    }
  }
}

class AccountsReceivableModel {
  final DebtorModel debtor;
  final String churchId;
  final String description;
  final String symbol;
  final List<InstallmentModel> installments;
  final AccountsReceivableType? type;

  final String? accountReceivableId;
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
    required this.symbol,
    this.amountPaid,
    this.amountPending,
    this.amountTotal,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.accountReceivableId,
  });

  AccountsReceivableModel.fromJson(Map<String, dynamic> map)
    : debtor = DebtorModel.fromMap(map['debtor']),
      churchId = map['churchId'],
      description = map['description'],
      installments =
          (map['installments'] as List)
              .map((i) => InstallmentModel.fromJson(i))
              .toList(),
      status = map['status'],
      type =
          map['type'] == ""
              ? AccountsReceivableType.LOAN
              : AccountsReceivableTypeHelper.fromApiValue(map['type']),
      amountPaid = double.parse(map['amountPaid'].toString()),
      amountPending = double.parse(map['amountPending'].toString()),
      amountTotal = double.parse(map['amountTotal'].toString()),
      createdAt = DateTime.parse(map['createdAt']),
      updatedAt = DateTime.parse(map['updatedAt']),
      accountReceivableId = map['accountReceivableId'],
      symbol = map['symbol'] ?? CurrencyType.REAL.apiValue;

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
      'type': type?.apiValue,
    };
  }
}
