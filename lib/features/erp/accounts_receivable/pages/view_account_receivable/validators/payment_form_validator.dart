import 'package:lucid_validation/lucid_validation.dart';

import '../state/payment_form_state.dart';

class PaymentFormValidator extends LucidValidator<PaymentFormState> {
  final String amountRequired;
  final String availabilityAccountRequired;

  PaymentFormValidator({
    required this.amountRequired,
    required this.availabilityAccountRequired,
  }) {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: amountRequired);

    ruleFor((m) => m.availabilityAccountId, key: 'availabilityAccountId')
        .notEmpty(message: availabilityAccountRequired);

    // ruleFor((m) => m.installmentIds, key: 'installmentIds')
    //     .must((ids) => ids.isNotEmpty, message: 'Selecione pelo menos uma parcela');
  }
}
