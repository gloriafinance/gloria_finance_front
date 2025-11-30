class LinkBankStatementResponse {
  final bool reconciled;
  final String bankStatementId;
  final String financialRecordId;

  const LinkBankStatementResponse({
    required this.reconciled,
    required this.bankStatementId,
    required this.financialRecordId,
  });

  factory LinkBankStatementResponse.fromJson(Map<String, dynamic> json) {
    return LinkBankStatementResponse(
      reconciled: json['reconciled'] == true,
      bankStatementId: (json['bankStatementId'] ?? '').toString(),
      financialRecordId: (json['financialRecordId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reconciled': reconciled,
      'bankStatementId': bankStatementId,
      'financialRecordId': financialRecordId,
    };
  }
}
