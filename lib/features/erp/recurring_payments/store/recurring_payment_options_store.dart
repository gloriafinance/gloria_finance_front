import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/cost_center_service.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/financial_concept_service.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';

import '../state/recurring_payment_options_state.dart';
import '../utils/recurring_payment_lookup.dart';

/// Carga las opciones del módulo de pagos recurrentes: conceptos de **gasto**
/// (`OUTGO`) activos y centros de costo activos.
///
/// No reutiliza `FinancialConceptStore`/`CostCenterListStore` a propósito: esos
/// stores son compartidos y su lista refleja los filtros de sus pantallas, así
/// que el formulario podría quedarse sin conceptos de gasto.
class RecurringPaymentOptionsStore extends ChangeNotifier {
  RecurringPaymentOptionsStore({
    FinancialConceptService? financialConceptService,
    CostCenterService? costCenterService,
  }) : financialConceptService =
           financialConceptService ?? FinancialConceptService(),
       costCenterService = costCenterService ?? CostCenterService();

  final FinancialConceptService financialConceptService;
  final CostCenterService costCenterService;

  RecurringPaymentOptionsState state = RecurringPaymentOptionsState.empty();

  Future<void> searchOptions() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      financialConceptService.tokenAPI = session.token;
      costCenterService.tokenAPI = session.token;

      // El endpoint acepta el filtro por tipo; la regla se vuelve a aplicar en el
      // cliente (`expenseFinancialConcepts`) porque es el contrato del dominio y
      // no debe depender de lo que devuelva la red.
      final concepts = await financialConceptService.searchFinancialConcepts(
        session.churchId,
        FinancialConceptType.OUTGO,
        null,
      );
      final costCenters = await costCenterService.searchCostCenters();

      state = state.copyWith(
        makeRequest: false,
        expenseConcepts: expenseFinancialConcepts(concepts),
        costCenters: selectableCostCenters(costCenters),
      );
    } catch (e) {
      debugPrint('ERROR searchRecurringPaymentOptions: $e');
      state = state.copyWith(makeRequest: false);
    }

    notifyListeners();
  }
}
