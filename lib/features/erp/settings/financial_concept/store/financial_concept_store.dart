import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../financial_concept_service.dart';
import '../models/financial_concept_model.dart';
import '../state/financial_concept_state.dart';

class FinancialConceptStore extends ChangeNotifier {
  final service = FinancialConceptService();
  var state = FinancialConceptState.init();

  Future<void> searchFinancialConcepts({
    FinancialConceptType? type,
    StatementCategory? statementCategory,
    bool updateSelectedType = false,
    bool updateSelectedStatementCategory = false,
  }) async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    final session = await AuthPersistence().restore();
    service.tokenAPI = session.token;

    try {
      final selectedType =
          updateSelectedType ? type : (type ?? state.selectedType);
      final selectedStatementCategory =
          updateSelectedStatementCategory
              ? statementCategory
              : (statementCategory ?? state.selectedStatementCategory);
      final financialConcepts = await service.searchFinancialConcepts(
        session.churchId,
        selectedType,
        selectedStatementCategory,
      );
      state = state.copyWith(
        financialConcepts: financialConcepts,
        isLoading: false,
        selectedType: selectedType,
        updateSelectedType: true,
        selectedStatementCategory: selectedStatementCategory,
        updateSelectedStatementCategory: true,
      );
      notifyListeners();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      notifyListeners();
      debugPrint('ERROR searchFinancialConcepts: $e');
    }
  }

  Future<void> clearFilter() async {
    state = state.copyWith(
      selectedType: null,
      updateSelectedType: true,
      selectedStatementCategory: null,
      updateSelectedStatementCategory: true,
    );
    await searchFinancialConcepts(
      type: null,
      statementCategory: null,
      updateSelectedType: true,
      updateSelectedStatementCategory: true,
    );
  }

  void setTypeFilter(FinancialConceptType? type) {
    state = state.copyWith(selectedType: type, updateSelectedType: true);
    notifyListeners();
  }

  void setStatementCategoryFilter(StatementCategory? statementCategory) {
    state = state.copyWith(
      selectedStatementCategory: statementCategory,
      updateSelectedStatementCategory: true,
    );
    notifyListeners();
  }

  Future<void> applyFilters() async {
    await searchFinancialConcepts(
      type: state.selectedType,
      statementCategory: state.selectedStatementCategory,
      updateSelectedType: true,
      updateSelectedStatementCategory: true,
    );
  }

  Future<void> filterByType(FinancialConceptType? type) async {
    await searchFinancialConcepts(type: type, updateSelectedType: true);
  }

  Future<void> filterByStatementCategory(
    StatementCategory? statementCategory,
  ) async {
    await searchFinancialConcepts(
      statementCategory: statementCategory,
      updateSelectedStatementCategory: true,
    );
  }
}
