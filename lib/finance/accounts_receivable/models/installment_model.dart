import '../../../helpers/date_formatter.dart';

enum InstallmentsStatus { PENDING, PAID, PARTIAL }

extension InstallmentsStatusExtension on InstallmentsStatus {
  String get friendlyName {
    switch (this) {
      case InstallmentsStatus.PENDING:
        return 'Pendente';
      case InstallmentsStatus.PAID:
        return 'Pago';
      case InstallmentsStatus.PARTIAL:
        return 'Pagamento parcial';
    }
  }

  String get apiValue {
    switch (this) {
      case InstallmentsStatus.PENDING:
        return 'PENDING';
      case InstallmentsStatus.PAID:
        return 'PAID';
      case InstallmentsStatus.PARTIAL:
        return 'PARTIAL_PAYMENT';
    }
  }
}

class InstallmentModel {
  final double amount;
  final String dueDate;
  final String? installmentId;
  final double? amountPaid;
  final double? amountPending;
  final DateTime? paymentDate;
  final String? status;
  final String? financialTransactionId;

  InstallmentModel({
    required this.amount,
    required this.dueDate,
    this.installmentId,
    this.amountPaid,
    this.amountPending,
    this.paymentDate,
    this.status,
    this.financialTransactionId,
  });

  InstallmentModel.fromJson(Map<String, dynamic> map)
      : amount = double.parse(map['amount'].toString()),
        dueDate = map['dueDate'],
        installmentId = map['installmentId'],
        amountPaid = map['amountPaid'] != null
            ? double.parse(map['amountPaid'].toString())
            : null,
        amountPending = map['amountPending'] != null
            ? double.parse(map['amountPending'].toString())
            : null,
        paymentDate = map['paymentDate'] != null
            ? DateTime.parse(map['paymentDate'])
            : null,
        status = map['status'],
        financialTransactionId = map['financialTransactionId'];

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dueDate': convertDateFormat(dueDate),
    };
  }
}
