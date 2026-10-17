/// Resultado de `POST /recurring-payments/:id/pay`.
enum RecurringPaymentPayOutcome {
  PROCESSING,
  BLOCKED,
  FAILED,
  PAID,
  ALREADY_PAID,
}

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
    return RecurringPaymentPayResult(
      outcome: RecurringPaymentPayOutcomeExtension.tryFromApiValue(
        json['status'] as String?,
      ),
      competence: json['competence'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      providerValueInCents: json['providerValueInCents'] as int?,
      failureCode: json['failureCode'] as String?,
    );
  }

  /// Importe a mostrar cuando el boleto fue el que definió el valor.
  double? get providerAmount {
    final cents = providerValueInCents;
    return cents == null ? null : cents / 100;
  }
}
