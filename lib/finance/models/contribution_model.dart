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

  Contribution({
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.bankTransferReceipt,
    required this.type,
    required this.financeConcept,
  });

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      amount: json['amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      bankTransferReceipt: json['bankTransferReceipt'],
      type: json['type'],
      financeConcept: FinancialConcept.fromJson(json['financeConcept']),
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
