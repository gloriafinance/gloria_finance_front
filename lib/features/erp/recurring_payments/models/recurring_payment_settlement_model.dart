import 'package:gloria_finance/core/utils/date_formatter.dart';

/// De dónde viene el asiento que pagó la competencia.
///
/// `CLEARED` es un registro manual y puede anularse; `RECONCILED` es un débito
/// bancario confirmado y **no** es reversible. Un valor fuera del contrato queda
/// como [UNKNOWN] y la pantalla no ofrece cancelar.
enum RecurringPaymentSettlementOrigin { MANUAL, BANK, UNKNOWN }

/// Resumen del `FinancialRecord` que hace que una competencia esté PAID.
///
/// El asiento contable sigue siendo la fuente de verdad histórica; esto es solo
/// lo que la pantalla necesita para explicarla.
class RecurringPaymentSettlementModel {
  final String financialRecordId;
  final double amount;
  final DateTime? date;
  final RecurringPaymentSettlementOrigin origin;
  final String availabilityAccountId;
  final String? voucher;

  const RecurringPaymentSettlementModel({
    required this.financialRecordId,
    required this.amount,
    required this.date,
    required this.origin,
    required this.availabilityAccountId,
    required this.voucher,
  });

  factory RecurringPaymentSettlementModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];

    return RecurringPaymentSettlementModel(
      financialRecordId: json['financialRecordId'] ?? '',
      amount: rawAmount is num ? rawAmount.toDouble() : 0,
      date: parseIsoDate(json['date']),
      origin: originOf(json['status'] as String?),
      availabilityAccountId: json['availabilityAccountId'] ?? '',
      voucher: json['voucher'] as String?,
    );
  }

  static RecurringPaymentSettlementOrigin originOf(String? status) {
    switch (status) {
      case 'CLEARED':
        return RecurringPaymentSettlementOrigin.MANUAL;
      case 'RECONCILED':
        return RecurringPaymentSettlementOrigin.BANK;
      default:
        return RecurringPaymentSettlementOrigin.UNKNOWN;
    }
  }

  bool get isManual => origin == RecurringPaymentSettlementOrigin.MANUAL;

  /// Solo un registro manual puede anularse.
  bool get canBeCancelled => isManual && financialRecordId.isNotEmpty;
}
