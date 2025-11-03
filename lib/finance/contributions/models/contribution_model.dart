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

double _parseAmount(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value.toDouble();
  }

  if (value is Map<String, dynamic>) {
    final nestedValue = value['amount'] ?? value['value'];
    return _parseAmount(nestedValue);
  }

  return double.tryParse(value.toString()) ?? 0;
}

DateTime _parseCreatedAt(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

String? _parseBankTransferReceipt(Map<String, dynamic> json) {
  final receipt = json['bankTransferReceipt'] ??
      json['bankTransferReceiptUrl'] ??
      json['receiptUrl'];

  if (receipt is Map<String, dynamic>) {
    return receipt['url'] as String?;
  }

  return receipt?.toString();
}

Map<String, dynamic>? _extractAccount(Map<String, dynamic> json) {
  return (json['availabilityAccount'] ??
          json['account'] ??
          json['availabilityAccountBank']) as Map<String, dynamic>?;
}

Map<String, dynamic>? _extractConcept(Map<String, dynamic> json) {
  return (json['financeConcept'] ??
          json['financialConcept'] ??
          json['concept']) as Map<String, dynamic>?;
}

Map<String, dynamic>? _extractMember(Map<String, dynamic> json) {
  return (json['member'] ?? json['contributor'] ?? json['person'])
      as Map<String, dynamic>?;
}

class ContributionModel {
  final double amount;
  final String status;
  final DateTime createdAt;
  final String bankTransferReceipt;
  final ContributionFinancialConcept financeConcept;
  final ContributionAvailabilityAccount account;
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
    required this.account,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    final accountJson = _extractAccount(json);
    final conceptJson = _extractConcept(json);
    final memberJson = _extractMember(json);

    return ContributionModel(
      contributionId: json['contributionId'] ?? json['id'],
      amount: _parseAmount(json['amount']),
      status: (json['status'] ?? json['currentStatus'] ?? '').toString(),
      createdAt: _parseCreatedAt(json['createdAt'] ?? json['contributionDate']),
      bankTransferReceipt: _parseBankTransferReceipt(json) ?? '',
      financeConcept:
          ContributionFinancialConcept.fromJson(
              conceptJson ?? <String, dynamic>{}),
      member: ContributionMember.fromJson(memberJson ?? <String, dynamic>{}),
      account: ContributionAvailabilityAccount.fromJson(
          accountJson ?? <String, dynamic>{}),
    );
  }

  ContributionModel copyWith({
    double? amount,
    String? status,
    DateTime? createdAt,
    String? bankTransferReceipt,
    ContributionFinancialConcept? financeConcept,
    ContributionMember? member,
    String? contributionId,
    ContributionAvailabilityAccount? availableContribution,
  }) {
    return ContributionModel(
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      bankTransferReceipt: bankTransferReceipt ?? this.bankTransferReceipt,
      financeConcept: financeConcept ?? this.financeConcept,
      member: member ?? this.member,
      contributionId: contributionId ?? this.contributionId,
      account: availableContribution ?? this.account,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'bankTransferReceipt': bankTransferReceipt,
      'financeConcept': financeConcept.toJson(),
      'member': member.toJson(),
      'contributionId': contributionId,
      'availabilityAccount': account.toJson(),
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
      memberId: json['memberId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      churchId: json['churchId']?.toString() ?? '',
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
      financialConceptId: json['financialConceptId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financialConceptId': financialConceptId,
      'name': name,
    };
  }
}

class ContributionAvailabilityAccount {
  final String symbol;
  final String accountName;

  ContributionAvailabilityAccount(
      {required this.symbol, required this.accountName});

  factory ContributionAvailabilityAccount.fromJson(Map<String, dynamic> json) {
    return ContributionAvailabilityAccount(
      symbol: json['symbol']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'accountName': accountName,
    };
  }
}
