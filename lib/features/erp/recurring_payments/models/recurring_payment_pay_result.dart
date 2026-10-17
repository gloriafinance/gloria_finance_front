/// Resultado de `POST /recurring-payments/:id/pay`.
enum RecurringPaymentPayOutcome { PROCESSING, BLOCKED, FAILED, ALREADY_PAID }

extension RecurringPaymentPayOutcomeExtension on RecurringPaymentPayOutcome {
  String get apiValue => toString().split('.').last;

  static RecurringPaymentPayOutcome? tryFromApiValue(String? value) {
    for (final element in RecurringPaymentPayOutcome.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }

  /// El banco aceptó la operación: **no** significa pagado. La confirmación
  /// llega por webhook.
  bool get isAccepted => this == RecurringPaymentPayOutcome.PROCESSING;
}

class RecurringPaymentPayResult {
  final RecurringPaymentPayOutcome? outcome;
  final String competence;

  /// Importe que se cobró (en un boleto viene de la línea).
  final double? amount;
  final int? providerValueInCents;
  final String? failureCode;

  const RecurringPaymentPayResult({
    required this.outcome,
    required this.competence,
    required this.amount,
    required this.providerValueInCents,
    required this.failureCode,
  });

  factory RecurringPaymentPayResult.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];

    return RecurringPaymentPayResult(
      outcome: RecurringPaymentPayOutcomeExtension.tryFromApiValue(
        json['status'] as String?,
      ),
      competence: json['competence'] ?? '',
      amount: rawAmount is num ? rawAmount.toDouble() : null,
      providerValueInCents:
          json['providerValueInCents'] is num
              ? (json['providerValueInCents'] as num).toInt()
              : null,
      failureCode: json['failureCode'] as String?,
    );
  }

  /// El banco rechazó el boleto porque cobra otro importe.
  bool get isAmountMismatch =>
      failureCode == 'RECURRING_PAYMENT_BILL_AMOUNT_MISMATCH';

  /// Importe a mostrar cuando el boleto fue el que definió el valor.
  double? get providerAmount {
    final cents = providerValueInCents;
    return cents == null ? null : cents / 100;
  }
}
