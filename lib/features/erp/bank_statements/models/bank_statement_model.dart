import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:flutter/material.dart';

enum BankStatementDirection { income, outgo }

extension BankStatementDirectionExtension on BankStatementDirection {
  static BankStatementDirection fromApiValue(String value) {
    switch (value.toUpperCase()) {
      case 'INCOME':
        return BankStatementDirection.income;
      case 'OUTGO':
        return BankStatementDirection.outgo;
      default:
        return BankStatementDirection.income;
    }
  }

  String get apiValue {
    switch (this) {
      case BankStatementDirection.income:
        return 'INCOME';
      case BankStatementDirection.outgo:
        return 'OUTGO';
    }
  }

  String get friendlyName {
    switch (this) {
      case BankStatementDirection.income:
        return 'Entrada';
      case BankStatementDirection.outgo:
        return 'Saída';
    }
  }
}

enum BankStatementReconciliationStatus { pending, unmatched, reconciled }

extension BankStatementReconciliationStatusExtension
    on BankStatementReconciliationStatus {
  static BankStatementReconciliationStatus fromApiValue(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return BankStatementReconciliationStatus.pending;
      case 'UNMATCHED':
        return BankStatementReconciliationStatus.unmatched;
      case 'RECONCILED':
        return BankStatementReconciliationStatus.reconciled;
      default:
        return BankStatementReconciliationStatus.pending;
    }
  }

  String get apiValue {
    switch (this) {
      case BankStatementReconciliationStatus.pending:
        return 'PENDING';
      case BankStatementReconciliationStatus.unmatched:
        return 'UNMATCHED';
      case BankStatementReconciliationStatus.reconciled:
        return 'RECONCILED';
    }
  }

  String get friendlyName {
    switch (this) {
      case BankStatementReconciliationStatus.pending:
        return 'Pendente';
      case BankStatementReconciliationStatus.unmatched:
        return 'Não conciliado';
      case BankStatementReconciliationStatus.reconciled:
        return 'Conciliado';
    }
  }

  Color get badgeColor {
    switch (this) {
      case BankStatementReconciliationStatus.pending:
        return AppColors.mustard;
      case BankStatementReconciliationStatus.unmatched:
        return Colors.redAccent;
      case BankStatementReconciliationStatus.reconciled:
        return AppColors.green;
    }
  }
}

class BankInStatementModel {
  final String bankName;
  final String bankId;
  final String tag;

  const BankInStatementModel({
    required this.bankName,
    required this.bankId,
    required this.tag,
  });

  factory BankInStatementModel.fromJson(Map<String, dynamic> json) {
    return BankInStatementModel(
      bankName: json['bankName'] as String,
      bankId: json['bankId'] as String,
      tag: json['tag'] as String,
    );
  }
}

class AvailabilityAccountModel {
  final String accountName;
  final String availabilityAccountId;

  const AvailabilityAccountModel({
    required this.accountName,
    required this.availabilityAccountId,
  });

  factory AvailabilityAccountModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityAccountModel(
      accountName: json['accountName'] as String,
      availabilityAccountId: json['availabilityAccountId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountName': accountName,
      'availabilityAccountId': availabilityAccountId,
    };
  }
}

class BankStatementModel {
  final String bankStatementId;
  final String churchId;
  final BankInStatementModel bank;
  final AvailabilityAccountModel availabilityAccount;
  final DateTime postedAt;
  final double amount;
  final String description;
  final BankStatementDirection direction;
  final String? fitId;
  final String? hash;
  final int month;
  final int year;
  final BankStatementReconciliationStatus reconciliationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? financialRecordId;
  final DateTime? reconciledAt;
  final Map<String, dynamic>? raw;

  const BankStatementModel({
    required this.bankStatementId,
    required this.churchId,
    required this.bank,
    required this.availabilityAccount,
    required this.postedAt,
    required this.amount,
    required this.description,
    required this.direction,
    this.fitId,
    this.hash,
    required this.month,
    required this.year,
    required this.reconciliationStatus,
    required this.createdAt,
    required this.updatedAt,
    this.financialRecordId,
    this.reconciledAt,
    this.raw,
  });

  factory BankStatementModel.fromJson(Map<String, dynamic> json) {
    return BankStatementModel(
      bankStatementId: json['bankStatementId'] as String,
      churchId: json['churchId'] as String,
      bank: BankInStatementModel.fromJson(json['bank'] as Map<String, dynamic>),
      availabilityAccount: AvailabilityAccountModel.fromJson(
        json['availabilityAccount'] as Map<String, dynamic>,
      ),
      postedAt: DateTime.parse(json['postedAt'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      direction: BankStatementDirectionExtension.fromApiValue(
        json['direction'] as String,
      ),
      fitId: json['fitId'] as String?,
      hash: json['hash'] as String?,
      month: int.parse(json['month'] as String),
      year: int.parse(json['year'] as String),
      reconciliationStatus:
          BankStatementReconciliationStatusExtension.fromApiValue(
            json['reconciliationStatus'] as String,
          ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      financialRecordId: json['financialRecordId'] as String?,
      reconciledAt:
          json['reconciledAt'] != null
              ? DateTime.parse(json['reconciledAt'] as String)
              : null,
      raw: json['raw'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankStatementId': bankStatementId,
      'churchId': churchId,
      'bank': {
        'bankName': bank.bankName,
        'bankId': bank.bankId,
        'tag': bank.tag,
      },
      'availabilityAccount': availabilityAccount.toJson(),
      'postedAt': postedAt.toIso8601String(),
      'amount': amount,
      'description': description,
      'direction': direction.apiValue,
      'fitId': fitId,
      'hash': hash,
      'month': month.toString(),
      'year': year.toString(),
      'reconciliationStatus': reconciliationStatus.apiValue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'financialRecordId': financialRecordId,
      'reconciledAt': reconciledAt?.toIso8601String(),
      'raw': raw,
    };
  }

  bool get isReconciled =>
      reconciliationStatus == BankStatementReconciliationStatus.reconciled;
}
