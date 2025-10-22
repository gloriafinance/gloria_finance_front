import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../../../financial_concept_service.dart';
import '../../../models/financial_concept_model.dart';
import '../state/financial_concept_form_state.dart';

class FinancialConceptFormStore extends ChangeNotifier {
  final FinancialConceptService service;
  FinancialConceptFormState state;

  FinancialConceptFormStore({FinancialConceptModel? concept})
      : service = FinancialConceptService(),
        state = concept != null
            ? FinancialConceptFormState.fromModel(concept)
            : FinancialConceptFormState.init();

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setType(FinancialConceptType type) {
    state = state.copyWith(type: type);
    notifyListeners();
  }

  void setStatementCategory(StatementCategory category) {
    state = state.copyWith(statementCategory: category);
    notifyListeners();
  }

  void setActive(bool value) {
    state = state.copyWith(active: value);
    notifyListeners();
  }

  Future<bool> submit() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      service.tokenAPI = session.token;

      await service.saveFinancialConcept(state.toPayload());

      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      debugPrint('ERROR saveFinancialConcept: $e');
      return false;
    }
  }
}
