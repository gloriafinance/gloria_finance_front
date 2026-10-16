import 'package:gloria_finance/core/utils/date_formatter.dart';

/// Estado de la operación bancaria en curso (`currentPayment.status`).
enum RecurringPaymentExecutionStatus { PROCESSING, BLOCKED, FAILED }

extension RecurringPaymentExecutionStatusExtension
    on RecurringPaymentExecutionStatus {
  String get apiValue => toString().split('.').last;

  static RecurringPaymentExecutionStatus? tryFromApiValue(String? value) {
    for (final element in RecurringPaymentExecutionStatus.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }
}

/// Método elegido **para esa ejecución**. Nunca es configuración permanente.
enum RecurringPaymentMethodType { PIX, BILL }

extension RecurringPaymentMethodTypeExtension on RecurringPaymentMethodType {
  String get apiValue => toString().split('.').last;

  static RecurringPaymentMethodType? tryFromApiValue(String? value) {
    for (final element in RecurringPaymentMethodType.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }
}

/// Operación bancaria de una competencia (`currentPayment`).
///
/// Es estado operativo, no histórico: lo que quedó pagado vive en el asiento
/// contable ([RecurringPaymentSettlementModel]).
class RecurringPaymentExecutionModel {
  final String competence;
  final int attempt;
  final String externalReference;

  /// Importe del intento. Es nulo mientras un boleto no fue leído: el boleto
  /// trae su propio importe.
  final double? amount;

  /// Importe que cobra el boleto, leído de la línea por el banco.
  final int? providerValueInCents;

  final RecurringPaymentMethodType? method;
  final String? identificationField;
  final RecurringPaymentExecutionStatus? status;
  final String providerStatus;
  final String? failureCode;
  final DateTime? paymentDate;
  final String? transactionReceiptUrl;
  final DateTime? updatedAt;

  const RecurringPaymentExecutionModel({
    required this.competence,
    required this.attempt,
    required this.externalReference,
    required this.amount,
    required this.providerValueInCents,
    required this.method,
    required this.identificationField,
    required this.status,
    required this.providerStatus,
    required this.failureCode,
    required this.paymentDate,
    required this.transactionReceiptUrl,
    required this.updatedAt,
  });

  factory RecurringPaymentExecutionModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];

    return RecurringPaymentExecutionModel(
      competence: json['competence'] ?? '',
      attempt: json['attempt'] ?? 1,
      externalReference: json['externalReference'] ?? '',
      amount: rawAmount is num ? rawAmount.toDouble() : null,
      providerValueInCents:
          json['providerValueInCents'] is num
              ? (json['providerValueInCents'] as num).toInt()
              : null,
      method: RecurringPaymentMethodTypeExtension.tryFromApiValue(
        json['paymentMethod'] as String?,
      ),
      identificationField: json['identificationField'] as String?,
      status: RecurringPaymentExecutionStatusExtension.tryFromApiValue(
        json['status'] as String?,
      ),
      providerStatus: json['providerStatus'] ?? '',
      failureCode: json['failureCode'] as String?,
      paymentDate: parseIsoDate(json['paymentDate']),
      transactionReceiptUrl: json['transactionReceiptUrl'] as String?,
      updatedAt: parseIsoDate(json['updatedAt']),
    );
  }

  /// Importe del intento, venga del pago o del boleto.
  double? get effectiveAmount {
    if (amount != null) return amount;
    final providerValue = providerValueInCents;
    return providerValue == null ? null : providerValue / 100;
  }

  /// El banco rechazó el intento por diferencia de importe.
  bool get isAmountMismatch =>
      failureCode == 'RECURRING_PAYMENT_BILL_AMOUNT_MISMATCH';
}
