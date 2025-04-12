import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_receivable_state.dart';

class FormAccountsReceivableValidator
    extends LucidValidator<FormAccountsReceivableState> {
  FormAccountsReceivableValidator() {
    // Validación para el deudor de tipo miembro
    // ruleFor((m) => m.debtorDNI, key: 'debtorDNI').when(
    //     (m) => m.debtorType == DebtorType.MEMBER,
    //     must: (value) => value != null && value.isNotEmpty,
    //     otherwise: (value) => true,
    //     message: 'Selecione um membro');
    //
    // // Validación para el deudor de tipo externo
    // ruleFor((m) => m.debtorName, key: 'debtorName').when(
    //     (m) => m.debtorType == DebtorType.EXTERNAL,
    //     must: (value) => value != null && value.isNotEmpty,
    //     otherwise: (value) => true,
    //     message: 'Nome do deudor é obrigatório');
    //
    // ruleFor((m) => m.debtorDNI, key: 'debtorDNI').when(
    //     (m) => m.debtorType == DebtorType.EXTERNAL,
    //     must: (value) => value != null && value.isNotEmpty,
    //     otherwise: (value) => true,
    //     message: 'ID do deudor é obrigatório');
    //
    // // Validación general
    // ruleFor((m) => m.description, key: 'description')
    //     .notEmpty(message: 'Descrição é obrigatória');
  }
}
