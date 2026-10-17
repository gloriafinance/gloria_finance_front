/// Response of `POST /recurring-payments/:id/bill/simulate`.
///
/// Amounts are represented in integer cents. Nullable provider fields remain
/// nullable here so the review can show only the data Asaas returned.
class RecurringPaymentBillSimulation {
  const RecurringPaymentBillSimulation({
    this.minimumScheduleDate,
    this.feeInCents,
    this.bankSlip,
  });

  final String? minimumScheduleDate;
  final int? feeInCents;
  final RecurringPaymentBankSlip? bankSlip;

  factory RecurringPaymentBillSimulation.fromJson(Map<String, dynamic> json) {
    final bankSlip = json['bankSlip'] as Map<String, dynamic>?;
    return RecurringPaymentBillSimulation(
      minimumScheduleDate: json['minimumScheduleDate'] as String?,
      feeInCents: json['feeInCents'] as int?,
      bankSlip:
          bankSlip == null ? null : RecurringPaymentBankSlip.fromJson(bankSlip),
    );
  }
}

class RecurringPaymentBankSlip {
  const RecurringPaymentBankSlip({
    this.identificationField,
    this.valueInCents,
    this.originalValueInCents,
    this.dueDate,
    this.companyName,
    this.bank,
    this.beneficiaryCpfCnpj,
    this.beneficiaryName,
    this.allowChangeValue,
    this.minValueInCents,
    this.maxValueInCents,
    this.discountValueInCents,
    this.interestValueInCents,
    this.fineValueInCents,
    this.totalDiscountValueInCents,
    this.totalAdditionalValueInCents,
    this.isOverdue,
  });

  final String? identificationField;
  final int? valueInCents;
  final int? originalValueInCents;
  final String? dueDate;
  final String? companyName;
  final String? bank;
  final String? beneficiaryCpfCnpj;
  final String? beneficiaryName;
  final bool? allowChangeValue;
  final int? minValueInCents;
  final int? maxValueInCents;
  final int? discountValueInCents;
  final int? interestValueInCents;
  final int? fineValueInCents;
  final int? totalDiscountValueInCents;
  final int? totalAdditionalValueInCents;
  final bool? isOverdue;

  factory RecurringPaymentBankSlip.fromJson(Map<String, dynamic> json) {
    return RecurringPaymentBankSlip(
      identificationField: json['identificationField'] as String?,
      valueInCents: json['valueInCents'] as int?,
      originalValueInCents: json['originalValueInCents'] as int?,
      dueDate: json['dueDate'] as String?,
      companyName: json['companyName'] as String?,
      bank: json['bank'] as String?,
      beneficiaryCpfCnpj: json['beneficiaryCpfCnpj'] as String?,
      beneficiaryName: json['beneficiaryName'] as String?,
      allowChangeValue: json['allowChangeValue'] as bool?,
      minValueInCents: json['minValueInCents'] as int?,
      maxValueInCents: json['maxValueInCents'] as int?,
      discountValueInCents: json['discountValueInCents'] as int?,
      interestValueInCents: json['interestValueInCents'] as int?,
      fineValueInCents: json['fineValueInCents'] as int?,
      totalDiscountValueInCents: json['totalDiscountValueInCents'] as int?,
      totalAdditionalValueInCents: json['totalAdditionalValueInCents'] as int?,
      isOverdue: json['isOverdue'] as bool?,
    );
  }
}

enum RecurringPaymentBillSimulationError { invalid, unavailable, generic }
