import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_tithes_state.dart';

class FormTithesValidator extends LucidValidator<FormTitheState> {
  FormTithesValidator() {
    ruleFor((m) => m.amount, key: 'amount').greaterThan(0);
    ruleFor((m) => m.month, key: 'month').notEmpty();
    ruleFor((m) => m.month, key: 'file').notEmpty();
  }
}
