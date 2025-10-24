import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:church_finance_bk/providers/models/supplier_model.dart';

import '../../models/installment_model.dart';

DateTime? _parseIsoDate(dynamic value) {
  if (value == null) return null;
  final stringValue = value.toString();
  if (stringValue.isEmpty || stringValue == 'null') {
    return null;
  }
  return DateTime.tryParse(stringValue);
}

class AccountsPayableDocument {
  final AccountsPayableDocumentType type;
  final String number;
  final DateTime? issueDate;

  const AccountsPayableDocument({
    required this.type,
    required this.number,
    this.issueDate,
  });

  factory AccountsPayableDocument.fromJson(Map<String, dynamic> json) {
    return AccountsPayableDocument(
      type: AccountsPayableDocumentType.fromApi(json['type'] as String?),
      number: json['number']?.toString() ?? '',
      issueDate: _parseIsoDate(json['issueDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      'number': number,
      if (issueDate != null) 'issueDate': issueDate!.toIso8601String(),
    };
  }

  String get issueDateFormatted {
    if (issueDate == null) return '';
    return convertDateFormatToDDMMYYYY(issueDate!.toIso8601String());
  }
}

class AccountsPayableSinglePayment {
  final double amount;
  final DateTime? dueDate;

  const AccountsPayableSinglePayment({
    required this.amount,
    this.dueDate,
  });

  factory AccountsPayableSinglePayment.fromJson(Map<String, dynamic> json) {
    return AccountsPayableSinglePayment(
      amount: double.parse(json['amount'].toString()),
      dueDate: _parseIsoDate(json['dueDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    };
  }

  String get dueDateFormatted {
    if (dueDate == null) return '';
    return convertDateFormatToDDMMYYYY(dueDate!.toIso8601String());
  }
}

class AccountsPayableManualPayment {
  final double totalAmount;
  final List<InstallmentModel> installments;

  const AccountsPayableManualPayment({
    required this.totalAmount,
    required this.installments,
  });

  factory AccountsPayableManualPayment.fromJson(Map<String, dynamic> json) {
    final installmentsJson = (json['installments'] as List<dynamic>?) ?? [];
    return AccountsPayableManualPayment(
      totalAmount: double.parse(json['totalAmount'].toString()),
      installments: installmentsJson
          .map((entry) => InstallmentModel.fromJson(
              Map<String, dynamic>.from(entry as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'installments': installments
          .map((installment) => {
                'sequence': installment.sequence,
                'amount': installment.amount,
                'dueDate': installment.dueDate,
              })
          .toList(),
    };
  }
}

class AccountsPayableAutomaticPayment {
  final int installmentsCount;
  final double amountPerInstallment;
  final DateTime? firstDueDate;
  final double totalAmount;
  final List<InstallmentModel> installments;

  const AccountsPayableAutomaticPayment({
    required this.installmentsCount,
    required this.amountPerInstallment,
    required this.firstDueDate,
    required this.totalAmount,
    required this.installments,
  });

  factory AccountsPayableAutomaticPayment.fromJson(Map<String, dynamic> json) {
    final installmentsJson = (json['installments'] as List<dynamic>?) ?? [];
    return AccountsPayableAutomaticPayment(
      installmentsCount: int.parse(json['installmentsCount'].toString()),
      amountPerInstallment:
          double.parse(json['amountPerInstallment'].toString()),
      firstDueDate: _parseIsoDate(json['firstDueDate']),
      totalAmount: double.parse(json['totalAmount'].toString()),
      installments: installmentsJson
          .map((entry) => InstallmentModel.fromJson(
              Map<String, dynamic>.from(entry as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installmentsCount': installmentsCount,
      'amountPerInstallment': amountPerInstallment,
      if (firstDueDate != null) 'firstDueDate': firstDueDate!.toIso8601String(),
      'totalAmount': totalAmount,
      'installments': installments
          .map((installment) => {
                'sequence': installment.sequence,
                'amount': installment.amount,
                'dueDate': installment.dueDate,
              })
          .toList(),
    };
  }

  String get firstDueDateFormatted {
    if (firstDueDate == null) return '';
    return convertDateFormatToDDMMYYYY(firstDueDate!.toIso8601String());
  }
}

class AccountsPayablePayment {
  final AccountsPayablePaymentMode mode;
  final AccountsPayableSinglePayment? single;
  final AccountsPayableManualPayment? manual;
  final AccountsPayableAutomaticPayment? automatic;

  const AccountsPayablePayment({
    required this.mode,
    this.single,
    this.manual,
    this.automatic,
  });

  factory AccountsPayablePayment.fromJson(Map<String, dynamic> json) {
    final mode = AccountsPayablePaymentMode.fromApi(json['mode'] as String?) ??
        AccountsPayablePaymentMode.single;

    AccountsPayableSinglePayment? single;
    AccountsPayableManualPayment? manual;
    AccountsPayableAutomaticPayment? automatic;

    if (mode == AccountsPayablePaymentMode.single && json['single'] is Map) {
      single = AccountsPayableSinglePayment.fromJson(
          Map<String, dynamic>.from(json['single'] as Map));
    }

    if (mode == AccountsPayablePaymentMode.manual && json['manual'] is Map) {
      manual = AccountsPayableManualPayment.fromJson(
          Map<String, dynamic>.from(json['manual'] as Map));
    }

    if (mode == AccountsPayablePaymentMode.automatic &&
        json['automatic'] is Map) {
      automatic = AccountsPayableAutomaticPayment.fromJson(
          Map<String, dynamic>.from(json['automatic'] as Map));
    }

    return AccountsPayablePayment(
      mode: mode,
      single: single,
      manual: manual,
      automatic: automatic,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'mode': mode.apiValue};

    switch (mode) {
      case AccountsPayablePaymentMode.single:
        if (single != null) {
          payload['single'] = single!.toJson();
        }
        break;
      case AccountsPayablePaymentMode.manual:
        if (manual != null) {
          payload['manual'] = manual!.toJson();
        }
        break;
      case AccountsPayablePaymentMode.automatic:
        if (automatic != null) {
          payload['automatic'] = automatic!.toJson();
        }
        break;
    }

    return payload;
  }
}

enum AccountsPayableStatus {
  PENDING,
  PAID,
  PARTIAL,
  OVERDUE,
  CANCELLED,
}

extension AccountsPayableStatusExtension on AccountsPayableStatus {
  String get friendlyName {
    switch (this) {
      case AccountsPayableStatus.PENDING:
        return 'Pendente';
      case AccountsPayableStatus.PAID:
        return 'Pago';
      case AccountsPayableStatus.PARTIAL:
        return 'Pagamento parcial';
      case AccountsPayableStatus.OVERDUE:
        return 'Em atraso';
      case AccountsPayableStatus.CANCELLED:
        return 'Cancelado';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountsPayableStatus.PENDING:
        return 'PENDING';
      case AccountsPayableStatus.PAID:
        return 'PAID';
      case AccountsPayableStatus.PARTIAL:
        return 'PARTIAL';
      case AccountsPayableStatus.OVERDUE:
        return 'OVERDUE';
      case AccountsPayableStatus.CANCELLED:
        return 'CANCELLED';
    }
  }

  static AccountsPayableStatus? fromApi(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'PENDING':
        return AccountsPayableStatus.PENDING;
      case 'PAID':
        return AccountsPayableStatus.PAID;
      case 'PARTIAL':
      case 'PARTIAL_PAYMENT':
      case 'PARTIALLY_PAID':
        return AccountsPayableStatus.PARTIAL;
      case 'OVERDUE':
      case 'LATE':
        return AccountsPayableStatus.OVERDUE;
      case 'CANCELLED':
      case 'CANCELED':
        return AccountsPayableStatus.CANCELLED;
      default:
        return null;
    }
  }

  static String labelFor(String? value) {
    final status = fromApi(value);
    return status?.friendlyName ?? 'Status desconhecido';
  }
}

class AccountsPayableModel {
  final String? accountPayableId;
  final String supplierId;
  final String description;
  final List<InstallmentModel> installments;
  final DateTime? createdAt;
  final bool? isPaid;
  final String? supplierName;
  final double? amountPaid;
  final double? amountPending;
  final double? amountTotal;
  final String? status;
  final DateTime? updatedAt;
  final SupplierModel? supplier;
  final AccountsPayableDocument? document;
  final AccountsPayablePayment? payment;

  AccountsPayableModel({
    this.accountPayableId,
    required this.supplierId,
    required this.description,
    required this.installments,
    this.createdAt,
    this.isPaid,
    this.supplierName,
    this.amountPaid,
    this.amountPending,
    this.amountTotal,
    this.status,
    this.updatedAt,
    this.supplier,
    this.document,
    this.payment,
  });

  factory AccountsPayableModel.fromJson(Map<String, dynamic> json) {
    return AccountsPayableModel(
      accountPayableId: json['accountPayableId'],
      supplierId: json['supplierId']?.toString() ?? '',
      description: json['description'] ?? '',
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) => InstallmentModel.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      createdAt: _parseIsoDate(json['createdAt']),
      isPaid: json['isPaid'] ?? true,
      supplierName: json['supplierName'] ?? '',
      amountPaid: json['amountPaid'] != null
          ? double.parse(json['amountPaid'].toString())
          : 0.0,
      amountPending: json['amountPending'] != null
          ? double.parse(json['amountPending'].toString())
          : 0.0,
      amountTotal: json['amountTotal'] != null
          ? double.parse(json['amountTotal'].toString())
          : 0.0,
      status: json['status']?.toString(),
      updatedAt: _parseIsoDate(json['updatedAt']),
      supplier: json['supplier'] != null
          ? SupplierModel.fromMap(
              Map<String, dynamic>.from(json['supplier'] as Map))
          : null,
      document: json['document'] != null
          ? AccountsPayableDocument.fromJson(
              Map<String, dynamic>.from(json['document'] as Map))
          : null,
      payment: json['payment'] != null
          ? AccountsPayablePayment.fromJson(
              Map<String, dynamic>.from(json['payment'] as Map))
          : null,
    );
  }

  AccountsPayableStatus? get statusEnum =>
      AccountsPayableStatusExtension.fromApi(status);

  String get statusLabel => AccountsPayableStatusExtension.labelFor(status);

  int countsInstallments() {
    return installments.length;
  }

  String get createdAtFormatted {
    if (createdAt == null) return '';
    return convertDateFormatToDDMMYYYY(createdAt!.toIso8601String());
  }

  String get updatedAtFormatted {
    if (updatedAt == null) return '';
    return convertDateFormatToDDMMYYYY(updatedAt!.toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final data = {
      'supplierId': supplierId,
      'description': description,
      'installments': installments.map((e) => e.toJson()).toList(),
    };

    if (document != null) {
      data['document'] = document!.toJson();
    }

    if (payment != null) {
      data['payment'] = payment!.toJson();
    }

    return data;
  }
}
