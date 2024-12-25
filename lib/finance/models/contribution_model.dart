enum ContributionType {
  OFFERING,
  TITHE,
}

enum ContributionStatus {
  PROCESSED,
  PENDING_VERIFICATION,
  REJECTED,
}

class Contribution {
  final double amount;
  final String status;
  final DateTime createdAt;
  final String bankTransferReceipt;
  final ContributionType type;
  final FinancialConcept financeConcept;
  final ContributionMember member;

  Contribution({
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.bankTransferReceipt,
    required this.type,
    required this.financeConcept,
    required this.member,
  });

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      amount: json['amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      bankTransferReceipt: json['bankTransferReceipt'],
      type: ContributionType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      financeConcept: FinancialConcept.fromJson(json['financeConcept']),
      member: ContributionMember.fromJson(json['member']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'bankTransferReceipt': bankTransferReceipt,
      'type': type,
      'financeConcept': financeConcept.toJson(),
      'member': member.toJson(),
    };
  }
}

class ContributionMember {
  final String memberId;
  final String name;
  final String churchId;

  ContributionMember({
    required this.memberId,
    required this.name,
    required this.churchId,
  });

  factory ContributionMember.fromJson(Map<String, dynamic> json) {
    return ContributionMember(
      memberId: json['memberId'],
      name: json['name'],
      churchId: json['churchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'name': name,
      'churchId': churchId,
    };
  }
}

class FinancialConcept {
  final String financeConceptId;
  final String name;

  FinancialConcept({
    required this.financeConceptId,
    required this.name,
  });

  factory FinancialConcept.fromJson(Map<String, dynamic> json) {
    return FinancialConcept(
      financeConceptId: json['financeConceptId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financeConceptId': financeConceptId,
      'name': name,
    };
  }
}
