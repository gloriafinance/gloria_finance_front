import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_availability_state.dart';

class FormAvailabilityValidator extends LucidValidator<FormAvailabilityState> {
  FormAvailabilityValidator() {
    ruleFor((m) => m.accountName, key: 'accountName').notEmpty();
    ruleFor((m) => m.accountType, key: 'accountType').notEmpty();
  }
}
