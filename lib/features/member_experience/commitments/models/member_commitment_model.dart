import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:flutter/material.dart';

enum MemberCommitmentStatus {
  pending,
  paid,
  pendingAcceptance,
  denied,
}

extension MemberCommitmentStatusExt on MemberCommitmentStatus {
  Color get badgeColor {
    switch (this) {
      case MemberCommitmentStatus.paid:
        return AppColors.green;
      case MemberCommitmentStatus.pendingAcceptance:
        return Colors.orange;
      case MemberCommitmentStatus.denied:
        return Colors.redAccent;
      case MemberCommitmentStatus.pending:
      default:
        return AppColors.purple;
    }
  }
}

class MemberCommitmentInstallment {
  final String installmentId;
  final double amount;
  final double? amountPaid;
  final double? amountPending;
  final DateTime dueDate;
  final DateTime? paymentDate;
  final String status;

  MemberCommitmentInstallment({
    required this.installmentId,
    required this.amount,
    this.amountPaid,
    this.amountPending,
    required this.dueDate,
    this.paymentDate,
    required this.status,
  });

  factory MemberCommitmentInstallment.fromJson(Map<String, dynamic> json) {
    return MemberCommitmentInstallment(
      installmentId: json['installmentId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      amountPaid: json['amountPaid'] != null
          ? (json['amountPaid']).toDouble()
          : null,
      amountPending: json['amountPending'] != null
          ? (json['amountPending']).toDouble()
          : null,
      dueDate: DateTime.parse(json['dueDate']),
      paymentDate: json['paymentDate'] != null
          ? DateTime.tryParse(json['paymentDate'])
          : null,
      status: json['status'] ?? 'PENDING',
    );
  }

  bool get isPaid => status == 'PAID';
  bool get isUnderReview => status == 'IN_REVIEW';
  bool get canBePaid => !isPaid && !isUnderReview;

  double get remainingAmount {
    if (amountPending != null) return amountPending!;
    if (amountPaid != null) return amount - amountPaid!;
    return amount;
  }
}

class MemberCommitmentModel {
  final String accountReceivableId;
  final String description;
  final double amountTotal;
  final double amountPaid;
  final double amountPending;
  final MemberCommitmentStatus status;
  final List<MemberCommitmentInstallment> installments;
  final String? availabilityAccountId;

  MemberCommitmentModel({
    required this.accountReceivableId,
    required this.description,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountPending,
    required this.status,
    required this.installments,
    this.availabilityAccountId,
  });

  factory MemberCommitmentModel.fromJson(Map<String, dynamic> json) {
    final installmentsJson =
        (json['installments'] as List<dynamic>? ?? [])
            .map((e) =>
                MemberCommitmentInstallment.fromJson(
                  e as Map<String, dynamic>,
                ))
            .toList();

    return MemberCommitmentModel(
      accountReceivableId: json['accountReceivableId'] ?? '',
      description: json['description'] ?? '',
      amountTotal: (json['amountTotal'] ?? 0).toDouble(),
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
      amountPending: (json['amountPending'] ?? 0).toDouble(),
      status: _parseStatus(json['status']),
      installments: installmentsJson,
      availabilityAccountId: json['availabilityAccountId'],
    );
  }

  static MemberCommitmentStatus _parseStatus(String? value) {
    switch (value) {
      case 'PAID':
        return MemberCommitmentStatus.paid;
      case 'PENDING_ACCEPTANCE':
        return MemberCommitmentStatus.pendingAcceptance;
      case 'DENIED':
        return MemberCommitmentStatus.denied;
      case 'PENDING':
      default:
        return MemberCommitmentStatus.pending;
    }
  }

  double get progress {
    if (amountTotal <= 0) return 0;
    final value = amountPaid / amountTotal;
    return value.clamp(0, 1);
  }

  bool get isCompleted => status == MemberCommitmentStatus.paid;

  MemberCommitmentInstallment? get nextInstallment {
    final unpaid = installments
        .where((installment) => installment.canBePaid)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    if (unpaid.isEmpty) return null;
    return unpaid.first;
  }
}

class MemberCommitmentListResponse {
  final int count;
  final int? nextPag;
  final List<MemberCommitmentModel> results;

  MemberCommitmentListResponse({
    required this.count,
    required this.nextPag,
    required this.results,
  });

  factory MemberCommitmentListResponse.fromJson(Map<String, dynamic> json) {
    return MemberCommitmentListResponse(
      count: json['count'] ?? 0,
      nextPag: json['nextPag'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map(
            (e) => MemberCommitmentModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
