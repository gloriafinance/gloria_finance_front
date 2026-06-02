import 'package:lucid_validation/lucid_validation.dart';

import '../state/member_registration_form_state.dart';

class MemberRegistrationValidator
    extends LucidValidator<MemberRegistrationFormState> {
  MemberRegistrationValidator({
    required String requiredFullNameMessage,
    required String requiredPhoneMessage,
    required String requiredLgpdMessage,
    required String invalidEmailMessage,
  }) {
    ruleFor((m) => m.fullName, key: 'fullName')
        .notEmpty(message: requiredFullNameMessage);

    ruleFor((m) => m.phone, key: 'phone')
        .notEmpty(message: requiredPhoneMessage);

    ruleFor((m) => m.email, key: 'email')
        .validEmail(message: invalidEmailMessage)
        .when((m) => m.email != null && m.email!.isNotEmpty);

    ruleFor((m) => m.lgpdConsentAccepted, key: 'lgpdConsentAccepted')
        .must(
          (value) => value == true,
          'lgpd_required',
          requiredLgpdMessage,
        );
  }
}
