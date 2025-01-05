enum ContributionType {
  OFFERING,
  TITHE,
}

enum ContributionStatus {
  PROCESSED,
  PENDING_VERIFICATION,
  REJECTED,
}

extension ContributionStatusExtension on ContributionStatus {
  String get friendlyName {
    switch (this) {
      case ContributionStatus.PROCESSED:
        return 'Processada';
      case ContributionStatus.PENDING_VERIFICATION:
        return 'Verificação pendente';
      case ContributionStatus.REJECTED:
        return 'Rejeitada';
    }
  }
}

class ContributionModel {
  final double amount;
  final String status;
  final DateTime createdAt;
  final String bankTransferReceipt;
  final ContributionFinancialConcept financeConcept;
  final ContributionMember member;
  final String contributionId;

  ContributionModel({
    required this.contributionId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.bankTransferReceipt,
    required this.financeConcept,
    required this.member,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      contributionId: json['contributionId'],
      amount: json['amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      bankTransferReceipt: json['bankTransferReceipt'],
      financeConcept:
          ContributionFinancialConcept.fromJson(json['financeConcept']),
      member: ContributionMember.fromJson(json['member']),
    );
  }

  copyWith({
    double? amount,
    String? status,
    DateTime? createdAt,
    String? bankTransferReceipt,
    ContributionType? type,
    ContributionFinancialConcept? financeConcept,
    ContributionMember? member,
    String? contributionId,
  }) {
    return ContributionModel(
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      bankTransferReceipt: bankTransferReceipt ?? this.bankTransferReceipt,
      financeConcept: financeConcept ?? this.financeConcept,
      member: member ?? this.member,
      contributionId: contributionId ?? this.contributionId,
    );
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

class ContributionFinancialConcept {
  final String financialConceptId;
  final String name;

  ContributionFinancialConcept({
    required this.financialConceptId,
    required this.name,
  });

  factory ContributionFinancialConcept.fromJson(Map<String, dynamic> json) {
    return ContributionFinancialConcept(
      financialConceptId: json['financialConceptId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financialConceptId': financialConceptId,
      'name': name,
    };
  }
}
