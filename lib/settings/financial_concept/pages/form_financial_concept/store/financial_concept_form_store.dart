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
    notifyListeners();
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
    notifyListeners();
  }

  void setType(FinancialConceptType type) {
    state = state.copyWith(type: type);
    state = _applyIndicatorDefaultsIfNeeded();
    notifyListeners();
  }

  void setStatementCategory(StatementCategory category) {
    state = state.copyWith(statementCategory: category);
    state = _applyIndicatorDefaultsIfNeeded();
    notifyListeners();
  }

  void setActive(bool value) {
    state = state.copyWith(active: value);
    notifyListeners();
  }

  void setAffectsCashFlow(bool value) {
    state = state.copyWith(
      affectsCashFlow: value,
      indicatorsEdited: true,
    );
    notifyListeners();
  }

  void setAffectsResult(bool value) {
    state = state.copyWith(
      affectsResult: value,
      indicatorsEdited: true,
    );
    notifyListeners();
  }

  void setAffectsBalance(bool value) {
    state = state.copyWith(
      affectsBalance: value,
      indicatorsEdited: true,
    );
    notifyListeners();
  }

  void setIsOperational(bool value) {
    state = state.copyWith(
      isOperational: value,
      indicatorsEdited: true,
    );
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

  FinancialConceptFormState _applyIndicatorDefaultsIfNeeded() {
    if (state.indicatorsEdited ||
        state.type == null ||
        state.statementCategory == null) {
      return state;
    }

    final defaults = _IndicatorDefaults.resolve(
      state.statementCategory!,
      state.type!,
    );

    return state.copyWith(
      affectsCashFlow: defaults.affectsCashFlow,
      affectsResult: defaults.affectsResult,
      affectsBalance: defaults.affectsBalance,
      isOperational: defaults.isOperational,
    );
  }
}

class _IndicatorDefaults {
  final bool affectsCashFlow;
  final bool affectsResult;
  final bool affectsBalance;
  final bool isOperational;

  const _IndicatorDefaults({
    required this.affectsCashFlow,
    required this.affectsResult,
    required this.affectsBalance,
    required this.isOperational,
  });

  static _IndicatorDefaults resolve(
    StatementCategory category,
    FinancialConceptType type,
  ) {
    switch (category) {
      case StatementCategory.REVENUE:
      case StatementCategory.OPEX:
      case StatementCategory.COGS:
        return const _IndicatorDefaults(
          affectsCashFlow: true,
          affectsResult: true,
          affectsBalance: false,
          isOperational: true,
        );
      case StatementCategory.CAPEX:
        return const _IndicatorDefaults(
          affectsCashFlow: true,
          affectsResult: false,
          affectsBalance: true,
          isOperational: false,
        );
      case StatementCategory.OTHER:
        switch (type) {
          case FinancialConceptType.REVERSAL:
            return const _IndicatorDefaults(
              affectsCashFlow: false,
              affectsResult: false,
              affectsBalance: false,
              isOperational: false,
            );
          case FinancialConceptType.PURCHASE:
            return const _IndicatorDefaults(
              affectsCashFlow: true,
              affectsResult: false,
              affectsBalance: true,
              isOperational: false,
            );
          case FinancialConceptType.INCOME:
          case FinancialConceptType.OUTGO:
            return const _IndicatorDefaults(
              affectsCashFlow: true,
              affectsResult: true,
              affectsBalance: false,
              isOperational: false,
            );
        }
    }
  }
}
