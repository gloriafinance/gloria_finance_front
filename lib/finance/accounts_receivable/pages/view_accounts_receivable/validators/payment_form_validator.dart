import 'package:lucid_validation/lucid_validation.dart';

import '../state/payment_form_state.dart';

class PaymentFormValidator extends LucidValidator<PaymentFormState> {
  PaymentFormValidator() {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: 'Informe o valor do pagamento');

    ruleFor((m) => m.availabilityAccountId, key: 'availabilityAccountId')
        .notEmpty(message: 'Selecione uma conta de disponibilidade');

    // ruleFor((m) => m.installmentIds, key: 'installmentIds')
    //     .must((ids) => ids.isNotEmpty, message: 'Selecione pelo menos uma parcela');
  }
}
