import 'package:lucid_validation/lucid_validation.dart';

import '../state/payment_account_payable.dart';

class PaymentAccountPayableValidator
    extends LucidValidator<PaymentAccountPayableState> {
  PaymentAccountPayableValidator() {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: 'Informe o valor do pagamento');

    ruleFor((m) => m.availabilityAccountId, key: 'availabilityAccountId')
        .notEmpty(message: 'Selecione uma conta de disponibilidade');

    ruleFor((m) => m.costCenterId, key: 'costCenterId')
        .notEmpty(message: 'Selecione um centro de custo');
  }
}
