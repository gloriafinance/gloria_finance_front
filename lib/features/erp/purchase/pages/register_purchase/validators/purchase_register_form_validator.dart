import 'package:lucid_validation/lucid_validation.dart';

import '../state/purchase_register_form_state.dart';

class PurchaseRegisterFormValidator
    extends LucidValidator<PurchaseRegisterFormState> {
  PurchaseRegisterFormValidator() {
    ruleFor((m) => m.costCenterId, key: 'costCenterId')
        .notEmpty(message: 'Centro de custo e obrigatorio');
    ruleFor((m) => m.financialConceptId, key: 'financialConceptId')
        .notEmpty(message: 'Conceito é obrigatório');
    ruleFor((m) => m.availabilityAccountId, key: 'availabilityAccountId')
        .notEmpty(message: 'Conta de disponibilidade e obrigatoria');
    ruleFor((m) => m.purchaseDate, key: 'purchaseDate')
        .notEmpty(message: 'Data da compra e obrigatoria');
    ruleFor((m) => m, key: 'total').must(
      (state) => state.total > 0,
      'Total da fatura e obrigatorio',
      'total_required',
    );
    ruleFor((m) => m.description, key: 'description')
        .notEmpty(message: 'Descrição é obrigatória');
  }
}
