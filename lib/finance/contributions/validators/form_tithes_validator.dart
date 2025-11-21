import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_tithes_state.dart';

class FormTithesValidator extends LucidValidator<FormTitheState> {
  FormTithesValidator() {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: 'Informe o valor');

    ruleFor((m) => m.month, key: 'month').notEmpty(message: 'Selecione um mês');

    ruleFor((m) => m.availabilityAccountId, key: 'moneyLocation')
        .notEmpty(message: 'Selecione a conta de disponibilidade');
  }
}
