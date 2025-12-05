import 'package:church_finance_bk/l10n/app_localizations.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_tithes_state.dart';

class FormTithesValidator extends LucidValidator<FormTitheState> {
  FormTithesValidator(AppLocalizations l10n) {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: l10n.member_contribution_validator_amount_required);

    ruleFor((m) => m.month, key: 'month')
        .notEmpty(message: l10n.member_contribution_validator_month_required);

    ruleFor((m) => m.availabilityAccountId, key: 'moneyLocation')
        .notEmpty(
            message: l10n.member_contribution_validator_account_required);
  }
}
