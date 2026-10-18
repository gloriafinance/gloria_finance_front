import 'recurring_payment_execution_model.dart';
import 'recurring_payment_model.dart';

/// Método de pago de **una ejecución** (nunca configuración permanente).
class RecurringPaymentPayMethod {
  const RecurringPaymentPayMethod.pix({
    required String this.pixKey,
    required PixKeyType this.pixKeyType,
  }) : type = RecurringPaymentMethodType.PIX,
       identificationField = null;

  const RecurringPaymentPayMethod.bill({
    required String this.identificationField,
  }) : type = RecurringPaymentMethodType.BILL,
       pixKey = null,
       pixKeyType = null;

  final RecurringPaymentMethodType type;
  final String? pixKey;
  final PixKeyType? pixKeyType;
  final String? identificationField;

  bool get isPix => type == RecurringPaymentMethodType.PIX;

  Map<String, dynamic> toJson() {
    if (isPix) {
      return {
        'type': type.apiValue,
        'pixKey': pixKey,
        'pixKeyType': pixKeyType?.apiValue,
      };
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
    required String availabilityAccountId,
  }) {
    // VARIABLE sends the PIX amount entered by the payer, or the amount read
    // from the simulated bill. FIXED always uses the configured amount.
    final declaresAmount = type == RecurringPaymentValueType.VARIABLE;

    return {
      'competence': competence,
      if (declaresAmount && amount != null) 'amount': amount,
      'payment': method.toJson(),
      'availabilityAccountId': availabilityAccountId,
    };
  }
}
