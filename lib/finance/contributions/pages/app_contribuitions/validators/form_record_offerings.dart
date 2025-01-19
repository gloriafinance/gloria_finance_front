import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_record_offerings_state.dart';

class FormRecordOfferingsValidator
    extends LucidValidator<FormRecordOfferingState> {
  FormRecordOfferingsValidator() {
    ruleFor((m) => m.amount, key: 'amount')
        .greaterThan(0, message: 'Informe o valor');

    ruleFor((m) => m.financialConceptId, key: 'financialConceptId')
        .notEmpty(message: 'Selecione um conceito financeiro');
  }
}
