import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_receivable_state.dart';

class FormAccountsReceivableValidator
    extends LucidValidator<FormAccountsReceivableState> {
  FormAccountsReceivableValidator() {
    ruleFor((m) => m.description, key: 'description')
        .notEmpty(message: 'Descrição é obrigatória');

    ruleFor((m) => m.financialConceptId, key: 'financialConceptId')
        .notEmpty(message: 'Selecione um conceito financeiro');

    ruleFor((m) => m.debtorName, key: 'debtorName')
        .notEmpty(message: 'Nome do devedor é obrigatório');

    ruleFor((m) => m.debtorDNI, key: 'debtorDNI')
        .notEmpty(message: 'Identificador do devedor é obrigatório');

    ruleFor((m) => m.debtorPhone, key: 'debtorPhone')
        .notEmpty(message: 'Telefone do devedor é obrigatório');

    ruleFor((m) => m.debtorEmail, key: 'debtorEmail')
        .notEmpty(message: 'Email do devedor é obrigatório');
  }
}
