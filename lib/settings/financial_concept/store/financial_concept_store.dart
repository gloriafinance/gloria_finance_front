import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../financial_concept_service.dart';
import '../states/financial_concept_state.dart';

class FinancialConceptStore extends ChangeNotifier {
  final service = FinancialConceptService();
  var state = FinancialConceptState.init();

  searchFinancialConcepts() async {
    final session = await AuthPersistence().restore();
    service.tokenAPI = session.token;

    try {
      final financialConcepts =
          await service.searchFinancialConcepts(session.churchId, null);
      state = state.copyWith(financialConcepts: financialConcepts);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
