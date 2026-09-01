class AsaasConnectionModel {
  final String accountId;
  final String externalAccountId;
  final String status;
  final String connectionMode;

  const AsaasConnectionModel({
    required this.accountId,
    required this.externalAccountId,
    required this.status,
    required this.connectionMode,
  });

  factory AsaasConnectionModel.fromJson(Map<String, dynamic> json) {
    return AsaasConnectionModel(
      accountId: json['accountId'] as String,
      externalAccountId: json['externalAccountId'] as String,
      status: json['status'] as String,
      connectionMode: json['connectionMode'] as String,
    );
  }
}
