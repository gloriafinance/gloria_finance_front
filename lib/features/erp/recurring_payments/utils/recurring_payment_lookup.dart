import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';

const String _unknownLabel = '—';

/// Resuelve el nombre de un concepto financiero a partir del id guardado en la recurrencia.
///
/// La configuración guarda ids; la lectura humana ocurre aquí para que la tabla,
/// la tabla compacta y las tarjetas muestren exactamente lo mismo.
String financialConceptName(
  List<FinancialConceptModel> concepts,
  String financialConceptId,
) {
  for (final concept in concepts) {
    if (concept.financialConceptId == financialConceptId) {
      return concept.name;
    }
  }
  return _unknownLabel;
}

/// Resuelve el nombre de un centro de costo a partir del id guardado en la recurrencia.
String costCenterName(List<CostCenterModel> costCenters, String costCenterId) {
  for (final costCenter in costCenters) {
    if (costCenter.costCenterId == costCenterId) {
      return costCenter.name;
    }
  }
  return _unknownLabel;
}

/// Conceptos elegibles para un pago recurrente: **solo gastos**.
///
/// Regla del contrato, no una preferencia de UI: el backend exige un concepto
/// `active` de tipo `OUTGO` al crear o actualizar la recurrencia
/// (`CreateOrUpdateRecurringPayment.assertImputation`, `ConceptType.OUTGO`), y
/// está documentado en `gloria_finance_api/docs/recurring-payments.md` §3:
/// "Debe ser un concepto de tipo `OUTGO` activo de la iglesia".
///
/// Por eso quedan fuera `INCOME` (entradas), `PURCHASE` (compras, que tienen su
/// propio módulo y el backend rechazaría) y `REVERSAL` (reversiones), además de
/// los conceptos inactivos.
List<FinancialConceptModel> expenseFinancialConcepts(
  List<FinancialConceptModel> concepts,
) {
  return concepts
      .where(
        (concept) =>
            concept.active &&
            concept.type == FinancialConceptType.OUTGO.apiValue,
      )
      .toList();
}

/// Centros de costo disponibles para asignar el gasto.
List<CostCenterModel> selectableCostCenters(List<CostCenterModel> costCenters) {
  return costCenters.where((costCenter) => costCenter.active).toList();
}

/// Etiqueta actual de un concepto ya guardado, para preseleccionar el dropdown en
/// edición. Devuelve `null` cuando el concepto no está en la lista ofrecida.
String? financialConceptLabelFor(
  List<FinancialConceptModel> concepts,
  String? financialConceptId,
) {
  if (financialConceptId == null || financialConceptId.isEmpty) return null;

  for (final concept in concepts) {
    if (concept.financialConceptId == financialConceptId) {
      return concept.name;
    }
  }
  return null;
}

/// Etiqueta actual de un centro de costo ya guardado, para preseleccionar el dropdown.
String? costCenterLabelFor(
  List<CostCenterModel> costCenters,
  String? costCenterId,
) {
  if (costCenterId == null || costCenterId.isEmpty) return null;

  for (final costCenter in costCenters) {
    if (costCenter.costCenterId == costCenterId) {
      return costCenter.name;
    }
  }
  return null;
}
