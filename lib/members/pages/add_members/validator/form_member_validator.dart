import 'package:church_finance_bk/members/pages/add_members/state/form_member_state.dart';
import 'package:lucid_validation/lucid_validation.dart';

class FormMemberValidator extends LucidValidator<FormMemberState> {
  FormMemberValidator() {
    ruleFor((m) => m.name, key: 'name')
        .notEmpty(message: 'O campo é obrigatório');
    ruleFor((m) => m.email, key: 'email')
        .notEmpty(message: 'O campo é obrigatório')
        .validEmail(message: 'Email inválido');
    ruleFor((m) => m.phone, key: 'phone')
        .notEmpty(message: 'O campo é obrigatório')
        .matchesPattern(r'^\d{10,11}$');
    ruleFor((m) => m.birthdate, key: 'birthDate')
        .notEmpty(message: 'O campo é obrigatório');
    ruleFor((m) => m.dni, key: 'dni')
        .matchesPattern(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$', message: 'CPF inválido')
        .notEmpty(message: 'O campo é obrigatório');
    ruleFor((m) => m.conversionDate, key: 'conversionDate')
        .notEmpty(message: 'O campo é obrigatório');
    ruleFor((m) => m.birthdate, key: 'birthdate')
        .notEmpty(message: 'O campo é obrigatório');
  }
}
