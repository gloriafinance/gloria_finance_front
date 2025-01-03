import 'package:lucid_validation/lucid_validation.dart';

import '../state/finance_record_state.dart';

class FormFinancialRecordValidator
    extends LucidValidator<FormFinanceRecordState> {
  FormFinancialRecordValidator() {
    ruleFor((m) => m.amount, key: 'amount').greaterThan(0);
    ruleFor((m) => m.date, key: 'date')
        .notEmpty()
        .matchesPattern(r'^\d{2}/\d{2}/\d{4}$');
    ruleFor((m) => m.financialConceptId, key: 'financialConceptId').notEmpty();
    ruleFor((m) => m.moneyLocation, key: 'moneyLocation').notEmpty();
    ruleFor((m) => m.description, key: 'description').notEmpty();
  }
}
