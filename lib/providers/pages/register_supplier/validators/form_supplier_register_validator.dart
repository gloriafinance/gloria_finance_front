import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_supplier_state.dart';

class FormSupplierValidator extends LucidValidator<FormSupplierState> {
  FormSupplierValidator() {
    ruleFor((m) => m.dni, key: 'dni')
        .notEmpty(message: 'CPF/CNPJ é obrigatório');

    ruleFor((m) => m.name, key: 'name').notEmpty(message: 'Nome é obrigatório');

    ruleFor((m) => m.street, key: 'street')
        .notEmpty(message: 'Rua é obrigatório');

    ruleFor((m) => m.number, key: 'number')
        .notEmpty(message: 'Número é obrigatório');

    ruleFor((m) => m.city, key: 'city')
        .notEmpty(message: 'Cidade é obrigatório');

    ruleFor((m) => m.state, key: 'state')
        .notEmpty(message: 'Estado é obrigatório');

    ruleFor((m) => m.zipCode, key: 'zipCode')
        .notEmpty(message: 'CEP é obrigatório');

    ruleFor((m) => m.phone, key: 'phone')
        .notEmpty(message: 'Telefone é obrigatório');

    ruleFor((m) => m.email, key: 'email')
        .notEmpty(message: 'Email é obrigatório')
        .validEmail(message: 'Email inválido');

    ruleFor((m) => m.type, key: 'type')
        .notEmpty(message: 'Tipo de fornecedor é obrigatório');
  }
}
