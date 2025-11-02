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

ContributionType? _parseContributionType(dynamic value) {
  if (value is String) {
    final normalized = value.toUpperCase();
    try {
      return ContributionType.values.firstWhere(
        (type) => type.toString().split('.').last == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  return null;
}

ContributionStatus _parseContributionStatus(dynamic value) {
  if (value is ContributionStatus) {
    return value;
  }

  if (value is String) {
    return ContributionStatus.values.firstWhere(
      (status) => status.toString().split('.').last == value.toUpperCase(),
      orElse: () => ContributionStatus.PENDING_VERIFICATION,
    );
  }

  return ContributionStatus.PENDING_VERIFICATION;
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
  final ContributionStatus status;
  final DateTime createdAt;
  final String? bankTransferReceipt;
  final ContributionFinancialConcept? financeConcept;
  final ContributionAvailabilityAccount? account;
  final ContributionMember? member;
  final String contributionId;
  final ContributionType? type;

  ContributionModel({
    this.account,
    required this.contributionId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.bankTransferReceipt,
    this.financeConcept,
    this.member,
    this.type,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    final accountJson = _extractAccount(json);
    final conceptJson = _extractConcept(json);
    final memberJson = _extractMember(json);

    return ContributionModel(
      contributionId: json['contributionId'] ?? json['id'],
      amount: _parseAmount(json['amount']),
      status: _parseContributionStatus(json['status'] ?? json['currentStatus']),
      createdAt: _parseCreatedAt(json['createdAt'] ?? json['contributionDate']),
      bankTransferReceipt: _parseBankTransferReceipt(json),
      financeConcept: conceptJson != null
          ? ContributionFinancialConcept.fromJson(conceptJson)
          : null,
      member:
          memberJson != null ? ContributionMember.fromJson(memberJson) : null,
      account: accountJson != null
          ? ContributionAvailabilityAccount.fromJson(accountJson)
          : null,
      type: _parseContributionType(json['type']),
    );
  }

  ContributionModel copyWith({
    double? amount,
    ContributionStatus? status,
    DateTime? createdAt,
    String? bankTransferReceipt,
    ContributionType? type,
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
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'bankTransferReceipt': bankTransferReceipt,
      'financeConcept': financeConcept?.toJson(),
      'member': member?.toJson(),
      'contributionId': contributionId,
      'type': type?.toString().split('.').last,
      'availabilityAccount': account?.toJson(),
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
