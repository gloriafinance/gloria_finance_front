import 'recurring_payment_execution_model.dart';
import 'recurring_payment_model.dart';

/// Método de pago de **una ejecución** (nunca configuración permanente).
class RecurringPaymentPayMethod {
  const RecurringPaymentPayMethod.pixQr({required String this.payload})
    : type = RecurringPaymentMethodType.PIX_QR,
      identificationField = null;

  const RecurringPaymentPayMethod.bill({
    required String this.identificationField,
  }) : type = RecurringPaymentMethodType.BILL,
       payload = null;

  final String? payload;

  final RecurringPaymentMethodType type;
  final String? identificationField;

  Map<String, dynamic> toJson() {
    if (type == RecurringPaymentMethodType.PIX_QR) {
      return {'type': type.apiValue, 'payload': payload};
    }
    return {'type': type.apiValue, 'identificationField': identificationField};
  }
}

/// Dueño único del payload de `POST /recurring-payments/:id/pay`.
class RecurringPaymentExecutionPayload {
  const RecurringPaymentExecutionPayload._();

  static Map<String, dynamic> build({
    required String competence,
    required RecurringPaymentValueType? type,
    required double? amount,
    required RecurringPaymentPayMethod method,
    String? availabilityAccountId,
  }) {
    // VARIABLE sends the PIX amount entered by the payer, or the amount read
    // from the simulated bill. FIXED always uses the configured amount.
    final declaresAmount = type == RecurringPaymentValueType.VARIABLE;

    return {
      'competence': competence,
      if (declaresAmount && amount != null) 'amount': amount,
      'payment': method.toJson(),
      if (availabilityAccountId != null)
        'availabilityAccountId': availabilityAccountId,
    };
  }
}
