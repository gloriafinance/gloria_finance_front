import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_record_offerings_state.dart';

class FormRecordOfferingsValidator
    extends LucidValidator<FormRecordOfferingState> {
  FormRecordOfferingsValidator(AppLocalizations l10n) {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: l10n.member_contribution_validator_amount_required);

    ruleFor((m) => m.financialConceptId, key: 'financialConceptId')
        .notEmpty(
            message: l10n.member_contribution_validator_financial_concept_required);

    ruleFor((m) => m.availabilityAccountId, key: 'moneyLocation')
        .notEmpty(
            message: l10n.member_contribution_validator_account_required);
  }
}
