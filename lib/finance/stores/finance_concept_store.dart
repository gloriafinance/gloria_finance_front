import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../services/finance_service.dart';
import '../states/financial_concept_state.dart';

class FinancialConceptStore extends ChangeNotifier {
  final service = FinanceService();
  var state = FinancialConceptState.init();

  searchFinancialConcepts() async {
    print("BUSCARNDO FINANCIAL CONCEPTS");
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
