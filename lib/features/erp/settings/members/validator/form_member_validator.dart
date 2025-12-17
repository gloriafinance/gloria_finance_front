import 'package:church_finance_bk/l10n/app_localizations.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../pages/add_members/state/form_member_state.dart';

class FormMemberValidator extends LucidValidator<FormMemberState> {
  final AppLocalizations l10n;

  FormMemberValidator(this.l10n) {
    ruleFor(
      (m) => m.name,
      key: 'name',
    ).notEmpty(message: l10n.validation_required);
    ruleFor((m) => m.email, key: 'email')
        .notEmpty(message: l10n.validation_required)
        .validEmail(message: l10n.validation_invalid_email);
    ruleFor((m) => m.phone, key: 'phone')
        .notEmpty(message: l10n.validation_required)
        // Keep phone validation generic or specific?
        // If not 'pt', maybe we shouldn't enforce Brazilian mask?
        // For now, let's keep it strict only for PT to avoid blocking foreigners
        .must(
          (phone) {
            if (l10n.localeName != 'pt') return true;
            return RegExp(r'^\(\d{2}\) \d{5}-\d{4}$').hasMatch(phone);
          },
          'phone_format',
          l10n.validation_invalid_phone,
        );

    ruleFor(
      (m) => m.birthdate,
      key: 'birthDate',
    ).notEmpty(message: l10n.validation_required);

    // Conditional DNI validation
    if (l10n.localeName == 'pt') {
      ruleFor((m) => m.dni, key: 'dni')
          .matchesPattern(
            r'^\d{3}\.\d{3}\.\d{3}-\d{2}$',
            message: l10n.validation_invalid_cpf,
          )
          .notEmpty(message: l10n.validation_required);
    } else {
      ruleFor(
        (m) => m.dni,
        key: 'dni',
      ).notEmpty(message: l10n.validation_required);
    }

    ruleFor(
      (m) => m.conversionDate,
      key: 'conversionDate',
    ).notEmpty(message: l10n.validation_required);
    ruleFor(
      (m) => m.birthdate,
      key: 'birthdate',
    ).notEmpty(message: l10n.validation_required);
  }
}
