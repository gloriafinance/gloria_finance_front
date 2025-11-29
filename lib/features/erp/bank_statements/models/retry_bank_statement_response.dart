class RetryBankStatementResponse {
  final bool matched;
  final String? financialRecordId;

  const RetryBankStatementResponse({
    required this.matched,
    required this.financialRecordId,
  });

  factory RetryBankStatementResponse.fromJson(Map<String, dynamic> json) {
    return RetryBankStatementResponse(
      matched: json['matched'] == true,
      financialRecordId: json['financialRecordId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'matched': matched, 'financialRecordId': financialRecordId};
  }
}
