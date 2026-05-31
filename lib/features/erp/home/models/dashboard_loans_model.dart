//: "OVERDUE" | "UP_TO_DATE"

class Loans {
  String? accountReceivableId;
  String? debtorName;
  String? description;
  double? amountTotal;
  double? amountPaid;
  double? amountPending;

  DateTime? createdAt;
  String? status;

  Loans({
    this.accountReceivableId,
    this.debtorName,
    this.description,
    this.amountPaid,
    this.amountPending,
    this.amountTotal,
    this.createdAt,
    this.status,
  });

  factory Loans.fromJson(Map<String, dynamic> json) {
    return Loans(
      accountReceivableId: json['accountReceivableId'],
      debtorName: json['debtorName'],
      description: json['description'],
      amountTotal: json['amountTotal']?.toDouble(),
      amountPaid: json['amountPaid']?.toDouble(),
      amountPending: json['amountPending']?.toDouble(),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      status: json['status'],
    );
  }
}

class DashboardLoanModel {
  double? total;
  List<Loans>? loans;

  DashboardLoanModel({this.total, this.loans});

  factory DashboardLoanModel.fromJson(Map<String, dynamic> json) {
    return DashboardLoanModel(
      total: json['total']?.toDouble(),
      loans:
          json['loans'] != null
              ? List<Loans>.from(json['loans'].map((x) => Loans.fromJson(x)))
              : null,
    );
  }
}
