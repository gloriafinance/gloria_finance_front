import 'accounts_payable_types.dart';

class AccountsPayableTaxMetadata {
  final AccountsPayableTaxStatus status;
  final bool taxExempt;
  final String? exemptionReason;
  final String? observation;
  final String? cstCode;
  final String? cfop;

  const AccountsPayableTaxMetadata({
    required this.status,
    required this.taxExempt,
    this.exemptionReason,
    this.observation,
    this.cstCode,
    this.cfop,
  });

  factory AccountsPayableTaxMetadata.fromJson(Map<String, dynamic> json) {
    return AccountsPayableTaxMetadata(
      status:
          AccountsPayableTaxStatus.fromApi(json['status'] as String?) ??
              AccountsPayableTaxStatus.exempt,
      taxExempt: json['taxExempt'] == true,
      exemptionReason: json['exemptionReason']?.toString(),
      observation: json['observation']?.toString(),
      cstCode: json['cstCode']?.toString(),
      cfop: json['cfop']?.toString(),
    );
  }

  AccountsPayableTaxMetadata copyWith({
    AccountsPayableTaxStatus? status,
    bool? taxExempt,
    String? exemptionReason,
    bool resetExemptionReason = false,
    String? observation,
    bool resetObservation = false,
    String? cstCode,
    bool resetCstCode = false,
    String? cfop,
    bool resetCfop = false,
  }) {
    return AccountsPayableTaxMetadata(
      status: status ?? this.status,
      taxExempt: taxExempt ?? this.taxExempt,
      exemptionReason:
          resetExemptionReason ? null : (exemptionReason ?? this.exemptionReason),
      observation: resetObservation ? null : (observation ?? this.observation),
      cstCode: resetCstCode ? null : (cstCode ?? this.cstCode),
      cfop: resetCfop ? null : (cfop ?? this.cfop),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.apiValue,
      'taxExempt': taxExempt,
      if ((exemptionReason ?? '').isNotEmpty) 'exemptionReason': exemptionReason,
      if ((observation ?? '').isNotEmpty) 'observation': observation,
      if ((cstCode ?? '').isNotEmpty) 'cstCode': cstCode,
      if ((cfop ?? '').isNotEmpty) 'cfop': cfop,
    };
  }
}

class AccountsPayableTaxLine {
  final String taxType;
  final double percentage;
  final double amount;
  final AccountsPayableTaxStatus status;

  const AccountsPayableTaxLine({
    required this.taxType,
    required this.percentage,
    required this.amount,
    required this.status,
  });

  factory AccountsPayableTaxLine.fromJson(Map<String, dynamic> json) {
    return AccountsPayableTaxLine(
      taxType: json['taxType']?.toString() ?? '',
      percentage: double.tryParse(json['percentage']?.toString() ?? '') ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      status: AccountsPayableTaxStatus.fromApi(json['status'] as String?) ??
          AccountsPayableTaxStatus.taxed,
    );
  }

  AccountsPayableTaxLine copyWith({
    String? taxType,
    double? percentage,
    double? amount,
    AccountsPayableTaxStatus? status,
  }) {
    return AccountsPayableTaxLine(
      taxType: taxType ?? this.taxType,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taxType': taxType,
      'percentage': percentage,
      'amount': amount,
      'status': status.apiValue,
    };
  }
}
