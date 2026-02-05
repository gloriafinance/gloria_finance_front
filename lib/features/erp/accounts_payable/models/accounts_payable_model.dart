import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/features/erp/accounts_payable/models/accounts_payable_tax.dart';
import 'package:gloria_finance/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:gloria_finance/features/erp/providers/models/supplier_model.dart';

import '../../models/installment_model.dart';

enum AccountsPayableStatus { PENDING, PARTIAL, PAID }

extension AccountsPayableStatusExtension on AccountsPayableStatus {
  String get friendlyName {
    switch (this) {
      case AccountsPayableStatus.PENDING:
        return 'Pendente';
      case AccountsPayableStatus.PARTIAL:
        return 'Pagamento parcial';
      case AccountsPayableStatus.PAID:
        return 'Pago';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountsPayableStatus.PENDING:
        return 'PENDING';
      case AccountsPayableStatus.PARTIAL:
        return 'PARTIAL';
      case AccountsPayableStatus.PAID:
        return 'PAID';
    }
  }

  static AccountsPayableStatus? fromApi(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'PENDING':
        return AccountsPayableStatus.PENDING;
      case 'PARTIAL':
        return AccountsPayableStatus.PARTIAL;
      case 'PAID':
        return AccountsPayableStatus.PAID;
      default:
        return null;
    }
  }

  static String labelFor(String? value) {
    final status = fromApi(value);
    return status?.friendlyName ?? 'Status desconhecido';
  }
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
      issueDate: parseIsoDate(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      if (number.isNotEmpty) 'number': number,
      if (issueDate != null)
        'date': issueDate!.toIso8601String().split('T').first,
    };
  }

  String get issueDateFormatted {
    if (issueDate == null) return '';
    return convertDateFormatToDDMMYYYY(issueDate!.toIso8601String());
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
  final double taxAmountTotal;
  final String? status;
  final DateTime? updatedAt;
  final SupplierModel? supplier;
  final AccountsPayableDocument? document;
  final AccountsPayableTaxMetadata? taxMetadata;
  final List<AccountsPayableTaxLine> taxes;
  final String symbol;

  AccountsPayableModel({
    this.accountPayableId,
    required this.supplierId,
    required this.description,
    required this.installments,
    required this.symbol,
    this.createdAt,
    this.isPaid,
    this.supplierName,
    this.amountPaid,
    this.amountPending,
    this.amountTotal,
    this.taxAmountTotal = 0.0,
    this.status,
    this.updatedAt,
    this.supplier,
    this.document,
    this.taxMetadata,
    this.taxes = const [],
  });

  factory AccountsPayableModel.fromJson(Map<String, dynamic> json) {
    final supplierJson = mapOrNull(json['supplier']);
    final documentJson = mapOrNull(json['taxDocument'] ?? json['document']);
    final taxMetadataJson = mapOrNull(json['taxMetadata']);
    final status = stringOrNull(json['status']);
    final parsedIsPaid = parseNullableBool(json['isPaid']);
    final statusEnum = AccountsPayableStatusExtension.fromApi(status);

    return AccountsPayableModel(
      symbol: json['symbol'] ?? CurrencyType.REAL.apiValue,
      accountPayableId: stringOrNull(json['accountPayableId']),
      supplierId: stringOrEmpty(
        json['supplierId'] ??
            supplierJson?['supplierId'] ??
            supplierJson?['id'],
      ),
      description: stringOrEmpty(json['description']),
      installments:
          (json['installments'] as List<dynamic>? ?? [])
              .whereType<Map>()
              .map(
                (entry) =>
                    InstallmentModel.fromJson(Map<String, dynamic>.from(entry)),
              )
              .toList(),
      createdAt: parseIsoDate(json['createdAt']),
      isPaid:
          parsedIsPaid ??
          (statusEnum == null
              ? null
              : statusEnum == AccountsPayableStatus.PAID),
      supplierName:
          stringOrNull(json['supplierName']) ??
          stringOrNull(supplierJson?['name']) ??
          '',
      amountPaid: parseAmount(json['amountPaid']),
      amountPending: parseAmount(json['amountPending']),
      amountTotal: parseAmount(json['amountTotal']),
      taxAmountTotal: parseAmount(json['taxAmountTotal']),
      status: status,
      updatedAt: parseIsoDate(json['updatedAt']),
      supplier:
          supplierJson != null ? SupplierModel.fromMap(supplierJson) : null,
      document:
          documentJson != null
              ? AccountsPayableDocument.fromJson(documentJson)
              : null,
      taxMetadata:
          taxMetadataJson != null
              ? AccountsPayableTaxMetadata.fromJson(taxMetadataJson)
              : null,
      taxes:
          (json['taxes'] as List<dynamic>? ?? [])
              .whereType<Map>()
              .map(
                (entry) => AccountsPayableTaxLine.fromJson(
                  Map<String, dynamic>.from(entry),
                ),
              )
              .toList(),
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
      data['taxDocument'] = document!.toJson();
    }

    if (taxMetadata != null) {
      data['taxMetadata'] = taxMetadata!.toJson();
    }

    if (taxes.isNotEmpty) {
      data['taxes'] = taxes.map((tax) => tax.toJson()).toList();
    }

    return data;
  }
}
