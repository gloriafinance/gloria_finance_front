import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_login_state.dart';

class FormLoginValidator extends LucidValidator<FormLoginState> {
  FormLoginValidator({
    required String invalidEmailMessage,
    required String requiredPasswordMessage,
  }) {
    ruleFor((m) => m.email, key: 'email')
        .notEmpty(message: invalidEmailMessage)
        .validEmail(message: invalidEmailMessage);

    ruleFor((m) => m.password, key: 'password')
        .notEmpty(message: requiredPasswordMessage);
  }
}
