import 'package:lucid_validation/lucid_validation.dart';

import '../state/change_password_state.dart';

class ChangePasswordValidator extends LucidValidator<ChangePasswordState> {
  ChangePasswordValidator() {
    ruleFor(
      (m) => m.oldPassword,
      key: 'oldPassword',
    ).notEmpty(message: 'Informe a senha antiga');

    ruleFor((m) => m.newPassword, key: 'newPassword')
        .notEmpty(message: 'Informe a nova senha')
        .minLength(8, message: 'A senha deve ter no mínimo 8 caracteres')
        .mustHaveLowercase(
          message: 'A senha deve ter no mínimo uma letra minúscula',
        )
        .mustHaveUppercase(
          message: 'A senha deve ter no mínimo uma letra maiúscula',
        )
        .mustHaveNumber(message: 'A senha deve ter no mínimo um número');
  }
}
