import 'package:lucid_validation/lucid_validation.dart';

import '../../../state/form_login_state.dart';

class FormLoginValidator extends LucidValidator<FormLoginState> {
  FormLoginValidator() {
    ruleFor((m) => m.email, key: 'email')
        .notEmpty(message: 'Informe um e-mail válido')
        .validEmail(message: 'Informe um e-mail válido');

    ruleFor((m) => m.password, key: 'password')
        .notEmpty(message: 'Informe a senha');
  }
}
