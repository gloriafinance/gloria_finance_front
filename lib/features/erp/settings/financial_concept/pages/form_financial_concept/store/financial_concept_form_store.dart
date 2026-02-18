import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../../../financial_concept_service.dart';
import '../../../models/financial_concept_assistance_model.dart';
import '../../../models/financial_concept_model.dart';
import '../state/financial_concept_form_state.dart';

class FinancialConceptFormStore extends ChangeNotifier {
  static const int maxAssistanceContextLength = 300;

  final FinancialConceptService service;
  FinancialConceptFormState state;
  bool requestingAssistance = false;
  FinancialConceptAssistanceModel? assistanceResponse;

  FinancialConceptFormStore({FinancialConceptModel? concept})
    : service = FinancialConceptService(),
      state =
          concept != null
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
    state = state.copyWith(affectsCashFlow: value, indicatorsEdited: true);
    notifyListeners();
  }

  void setAffectsResult(bool value) {
    state = state.copyWith(affectsResult: value, indicatorsEdited: true);
    notifyListeners();
  }

  void setAffectsBalance(bool value) {
    state = state.copyWith(affectsBalance: value, indicatorsEdited: true);
    notifyListeners();
  }

  void setIsOperational(bool value) {
    state = state.copyWith(isOperational: value, indicatorsEdited: true);
    notifyListeners();
  }

  bool get isSaveBlockedByAssistant {
    if (state.isEdit) return false;
    return assistanceResponse != null &&
        assistanceResponse!.needsCreate == false;
  }

  Future<FinancialConceptAssistanceModel?> requestAssistance(
    String context,
  ) async {
    final sanitizedContext = context.trim();
    if (sanitizedContext.isEmpty) return null;
    if (sanitizedContext.length > maxAssistanceContextLength) return null;

    requestingAssistance = true;
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      service.tokenAPI = session.token;

      final response = await service.getFinancialConceptAssistance(
        sanitizedContext,
      );
      assistanceResponse = response;

      if (response.needsCreate) {
        _applyAssistanceSuggestion(response.concept);
      }

      requestingAssistance = false;
      notifyListeners();
      return response;
    } catch (e) {
      requestingAssistance = false;
      notifyListeners();
      debugPrint('ERROR getFinancialConceptAssistance: $e');
      return null;
    }
  }

  Future<bool> submit() async {
    if (isSaveBlockedByAssistant) {
      return false;
    }

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

  void _applyAssistanceSuggestion(
    FinancialConceptAssistanceSuggestion concept,
  ) {
    final type = FinancialConceptType.values.firstWhere(
      (item) => item.apiValue == concept.type,
      orElse: () => FinancialConceptType.OUTGO,
    );

    final statementCategory = StatementCategory.values.firstWhere(
      (item) => item.apiValue == concept.statementCategory,
      orElse: () => StatementCategory.OTHER,
    );

    state = state.copyWith(
      name: concept.name,
      description: concept.description,
      type: type,
      statementCategory: statementCategory,
      affectsCashFlow: concept.affectsCashFlow,
      affectsResult: concept.affectsResult,
      affectsBalance: concept.affectsBalance,
      isOperational: concept.isOperational,
      indicatorsEdited: true,
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

      /// 🔹 Nueva categoría para Repasses e Contribuições Ministeriais
      case StatementCategory.MINISTRY_TRANSFERS:
        return const _IndicatorDefaults(
          affectsCashFlow: true, // sale dinero de caja
          affectsResult: true, // es despesa del período (va al DRE)
          affectsBalance: false, // no crea activo/pasivo directo
          isOperational: true, // es gasto operacional recurrente
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
