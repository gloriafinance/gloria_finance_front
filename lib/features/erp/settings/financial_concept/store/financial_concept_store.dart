import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../financial_concept_service.dart';
import '../models/financial_concept_model.dart';
import '../state/financial_concept_state.dart';

class FinancialConceptStore extends ChangeNotifier {
  final service = FinancialConceptService();
  var state = FinancialConceptState.init();

  Future<void> searchFinancialConcepts([FinancialConceptType? type]) async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    final session = await AuthPersistence().restore();
    service.tokenAPI = session.token;

    try {
      final selectedType = type ?? state.selectedType;
      final financialConcepts = await service.searchFinancialConcepts(
        session.churchId,
        selectedType,
      );
      state = state.copyWith(
        financialConcepts: financialConcepts,
        isLoading: false,
        selectedType: selectedType,
        updateSelectedType: true,
      );
      notifyListeners();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      notifyListeners();
      debugPrint('ERROR searchFinancialConcepts: $e');
    }
  }

  Future<void> clearFilter() async {
    state = state.copyWith(selectedType: null, updateSelectedType: true);
    await searchFinancialConcepts(null);
  }

  Future<void> filterByType(FinancialConceptType? type) async {
    await searchFinancialConcepts(type);
  }
}
