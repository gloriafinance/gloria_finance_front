import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';

/// Opciones que el formulario ofrece en sus dropdowns.
///
/// Se cargan aparte del store global de conceptos porque ese store guarda el
/// resultado del último filtro aplicado en la pantalla de configuración: si el
/// tesorero filtró "Entrada" allí, el formulario de pagos recurrentes se quedaría
/// sin opciones.
class RecurringPaymentOptionsState {
  final bool makeRequest;

  /// Conceptos de gasto (`OUTGO`) activos.
  final List<FinancialConceptModel> expenseConcepts;

  /// Centros de costo activos.
  final List<CostCenterModel> costCenters;

  const RecurringPaymentOptionsState({
    required this.makeRequest,
    required this.expenseConcepts,
    required this.costCenters,
  });

  factory RecurringPaymentOptionsState.empty() {
    return const RecurringPaymentOptionsState(
      makeRequest: false,
      expenseConcepts: [],
      costCenters: [],
    );
  }

  RecurringPaymentOptionsState copyWith({
    bool? makeRequest,
    List<FinancialConceptModel>? expenseConcepts,
    List<CostCenterModel>? costCenters,
  }) {
    return RecurringPaymentOptionsState(
      makeRequest: makeRequest ?? this.makeRequest,
      expenseConcepts: expenseConcepts ?? this.expenseConcepts,
      costCenters: costCenters ?? this.costCenters,
    );
  }

  bool get isLoading => makeRequest;

  bool get hasExpenseConcepts => expenseConcepts.isNotEmpty;

  bool get hasCostCenters => costCenters.isNotEmpty;
}
