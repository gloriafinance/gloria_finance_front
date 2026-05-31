//: "OVERDUE" | "UP_TO_DATE"

class AccountsPayable {
  double? installmentAmount;
  double? total;
  DateTime? nextPaymentDate;
  String? status;
  String? paymentSituation;
  String? accountPayableId;

  AccountsPayable({
    this.installmentAmount,
    this.total,
    this.nextPaymentDate,
    this.status,
    this.paymentSituation,
    this.accountPayableId,
  });

  factory AccountsPayable.fromJson(Map<String, dynamic> json) {
    return AccountsPayable(
      installmentAmount: json['installmentAmount']?.toDouble(),
      total: json['total']?.toDouble(),
      nextPaymentDate:
          json['nextPaymentDate'] != null
              ? DateTime.parse(json['nextPaymentDate'])
              : null,
      status: json['status'],
      paymentSituation: json['paymentSituation'],
      accountPayableId: json['accountPayableId'],
    );
  }
}

class DashboardAccountPayableModel {
  double? total;
  List<AccountsPayable>? accounts;

  DashboardAccountPayableModel({this.total, this.accounts});

  factory DashboardAccountPayableModel.fromJson(Map<String, dynamic> json) {
    return DashboardAccountPayableModel(
      total: json['total']?.toDouble(),
      accounts:
          json['accountPayables'] != null
              ? List<AccountsPayable>.from(
                json['accountPayables'].map((x) => AccountsPayable.fromJson(x)),
              )
              : null,
    );
  }
}
