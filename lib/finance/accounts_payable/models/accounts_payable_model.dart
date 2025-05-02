import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:church_finance_bk/providers/models/supplier_model.dart';

import '../../models/installment_model.dart';

enum AccountsPayableStatus {
  PENDING,
  PAID,
}

extension AccountsPayableStatusExtension on AccountsPayableStatus {
  String get friendlyName {
    switch (this) {
      case AccountsPayableStatus.PENDING:
        return 'Pendente';
      case AccountsPayableStatus.PAID:
        return 'Pago';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountsPayableStatus.PENDING:
        return 'PENDING';
      case AccountsPayableStatus.PAID:
        return 'PAID';
    }
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

  AccountsPayableModel(
      {this.accountPayableId,
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
      this.supplier,
      this.updatedAt});

  factory AccountsPayableModel.fromJson(Map<String, dynamic> json) {
    return AccountsPayableModel(
      accountPayableId: json['accountPayableId'],
      supplierId: json['supplierId'] ?? '',
      description: json['description'],
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) => InstallmentModel.fromJson(e))
              .toList() ??
          [],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
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
      status: json['status'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      supplier: json['supplier'] != null
          ? SupplierModel.fromMap(json['supplier'])
          : null,
    );
  }

  countsInstallments() {
    return installments.length;
  }

  String get createdAtFormatted {
    return convertDateFormatToDDMMYYYY(createdAt.toString());
  }

  String get updatedAtFormatted {
    return convertDateFormatToDDMMYYYY(updatedAt.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'description': description,
      'installments': installments.map((e) => e.toJson()).toList(),
    };
  }
}
