import 'package:lucid_validation/lucid_validation.dart';

import '../state/purchase_register_form.dart';

class PurchaseRegisterFormValidator
    extends LucidValidator<PurchaseRegisterFormState> {
  PurchaseRegisterFormValidator() {
    ruleFor((m) => m.financialConceptId, key: 'financialConceptId')
        .notEmpty(message: 'Conceito é obrigatório');
    ruleFor((m) => m.description, key: 'description')
        .notEmpty(message: 'Descrição é obrigatória');
  }
}
