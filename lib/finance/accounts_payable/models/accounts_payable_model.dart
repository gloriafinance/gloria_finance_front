class InstallmentModel {
  final double amount;
  final String dueDate;

  InstallmentModel({
    required this.amount,
    required this.dueDate,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      amount: json['amount'] ?? 0.0,
      dueDate: json['dueDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dueDate': dueDate,
    };
  }
}

class AccountsPayableModel {
  final String? accountPayableId;
  final String supplierId;
  final String description;
  final List<InstallmentModel> installments;
  final DateTime? createdAt;
  final bool? isPaid;
  final String? supplierName;

  AccountsPayableModel({
    this.accountPayableId,
    required this.supplierId,
    required this.description,
    required this.installments,
    this.createdAt,
    this.isPaid,
    this.supplierName,
  });

  factory AccountsPayableModel.fromJson(Map<String, dynamic> json) {
    return AccountsPayableModel(
      accountPayableId: json['accountPayableId'],
      supplierId: json['supplierId'],
      description: json['description'],
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) => InstallmentModel.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      isPaid: json['isPaid'],
      supplierName: json['supplierName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'description': description,
      'installments': installments.map((e) => e.toJson()).toList(),
    };
  }
} 