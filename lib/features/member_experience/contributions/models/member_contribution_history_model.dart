enum MemberContributionStatus {
  PENDING_VERIFICATION,
  PROCESSED,
  REJECTED,
  CANCELED,
}

extension MemberContributionStatusExtension on MemberContributionStatus {
  String get displayName {
    switch (this) {
      case MemberContributionStatus.PENDING_VERIFICATION:
        return 'Pendente';
      case MemberContributionStatus.PROCESSED:
        return 'Processado';
      case MemberContributionStatus.REJECTED:
        return 'Rejeitado';
      case MemberContributionStatus.CANCELED:
        return 'Cancelado';
    }
  }
}

class MemberContributionHistoryModel {
  final String contributionId;
  final double amount;
  final MemberContributionStatus status;
  final DateTime createdAt;
  final String? bankTransferReceipt;
  final String accountName;
  final String accountSymbol;
  final String conceptName;

  MemberContributionHistoryModel({
    required this.contributionId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.bankTransferReceipt,
    required this.accountName,
    required this.accountSymbol,
    required this.conceptName,
  });

  factory MemberContributionHistoryModel.fromJson(Map<String, dynamic> json) {
    return MemberContributionHistoryModel(
      contributionId: json['contributionId'],
      amount: (json['amount'] ?? 0).toDouble(),
      status: _parseStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      bankTransferReceipt: json['bankTransferReceipt'],
      accountName: json['availabilityAccount']?['accountName'] ?? '',
      accountSymbol: json['availabilityAccount']?['symbol'] ?? 'R\$',
      conceptName: json['financeConcept']?['name'] ?? '',
    );
  }

  static MemberContributionStatus _parseStatus(String? status) {
    switch (status) {
      case 'PENDING_VERIFICATION':
        return MemberContributionStatus.PENDING_VERIFICATION;
      case 'PROCESSED':
        return MemberContributionStatus.PROCESSED;
      case 'REJECTED':
        return MemberContributionStatus.REJECTED;
      case 'CANCELED':
        return MemberContributionStatus.CANCELED;
      default:
        return MemberContributionStatus.PENDING_VERIFICATION;
    }
  }
}

class MemberContributionHistoryResponse {
  final int count;
  final String? nextPag;
  final List<MemberContributionHistoryModel> results;

  MemberContributionHistoryResponse({
    required this.count,
    this.nextPag,
    required this.results,
  });

  factory MemberContributionHistoryResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return MemberContributionHistoryResponse(
      count: json['count'] ?? 0,
      nextPag: json['nextPag'],
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => MemberContributionHistoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
