import 'package:lucid_validation/lucid_validation.dart';

import '../state/change_password_state.dart';

class ChangePasswordValidator extends LucidValidator<ChangePasswordState> {
  ChangePasswordValidator({
    required String oldPasswordRequiredMessage,
    required String newPasswordRequiredMessage,
    required String minLengthMessage,
    required String lowercaseMessage,
    required String uppercaseMessage,
    required String numberMessage,
  }) {
    ruleFor(
      (m) => m.oldPassword,
      key: 'oldPassword',
    ).notEmpty(message: oldPasswordRequiredMessage);

    ruleFor((m) => m.newPassword, key: 'newPassword')
        .notEmpty(message: newPasswordRequiredMessage)
        .minLength(8, message: minLengthMessage)
        .mustHaveLowercase(message: lowercaseMessage)
        .mustHaveUppercase(message: uppercaseMessage)
        .mustHaveNumber(message: numberMessage);
  }
}
