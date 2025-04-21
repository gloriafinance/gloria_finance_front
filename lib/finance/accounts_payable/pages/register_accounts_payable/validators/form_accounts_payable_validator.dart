import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_payable_state.dart';

class FormAccountsPayableValidator
    extends LucidValidator<FormAccountsPayableState> {
  FormAccountsPayableValidator() {
    ruleFor((m) => m.supplierId, key: 'supplierId')
        .notEmpty(message: 'O fornecedor é obrigatório');

    ruleFor((m) => m.description, key: 'description')
        .notEmpty(message: 'A descrição é obrigatória');

    ruleFor((m) => m.installments, key: 'installments').must(
        (installments) => installments.isNotEmpty,
        'Pelo menos uma parcela é obrigatória',
        'installments_empty');
  }
}
