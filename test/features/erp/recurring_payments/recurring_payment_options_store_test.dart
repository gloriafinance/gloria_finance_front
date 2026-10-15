import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_options_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/utils/recurring_payment_lookup.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/cost_center_service.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/financial_concept_service.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regra de negócio: o dropdown de conceitos do pagamento recorrente oferece
/// **somente conceitos de gasto** (`OUTGO`) ativos.
///
/// O backend exige exatamente isso (`CreateOrUpdateRecurringPayment.assertImputation`
/// → `ConceptType.OUTGO`, `active: true`) e devolve
/// `RECURRING_PAYMENT_FINANCIAL_CONCEPT_INVALID` para qualquer outro tipo.
void main() {
  setUp(() {
    // `RecurringPaymentOptionsStore` restaura a sessão (SharedPreferences).
    SharedPreferences.setMockInitialValues({});
  });

  group('expenseFinancialConcepts', () {
    test('mantém somente OUTGO ativo', () {
      final concepts = [
        _concept('outgo-active', 'Aluguel', type: 'OUTGO', active: true),
        _concept('outgo-inactive', 'Água', type: 'OUTGO', active: false),
        _concept('income', 'Dízimos', type: 'INCOME'),
        _concept('purchase', 'Compra de cadeiras', type: 'PURCHASE'),
        _concept('reversal', 'Estorno', type: 'REVERSAL'),
      ];

      final result = expenseFinancialConcepts(concepts);

      expect(result.map((concept) => concept.financialConceptId), [
        'outgo-active',
      ]);
    });

    test('lista vazia continua vazia', () {
      expect(expenseFinancialConcepts(const []), isEmpty);
    });
  });

  group('RecurringPaymentOptionsStore', () {
    test('pede OUTGO ao serviço e descarta qualquer outro tipo', () async {
      final conceptService = _FakeFinancialConceptService([
        _concept('outgo-active', 'Aluguel', type: 'OUTGO', active: true),
        _concept('outgo-active-2', 'Energia', type: 'OUTGO', active: true),
        _concept('outgo-inactive', 'Internet', type: 'OUTGO', active: false),
        _concept('income', 'Dízimos', type: 'INCOME'),
        _concept('purchase', 'Compra', type: 'PURCHASE'),
      ]);
      final costCenterService = _FakeCostCenterService([
        _costCenter('cc-1', 'Templo', active: true),
        _costCenter('cc-2', 'Sede', active: false),
      ]);

      final store = RecurringPaymentOptionsStore(
        financialConceptService: conceptService,
        costCenterService: costCenterService,
      );

      await store.searchOptions();

      expect(store.state.isLoading, isFalse);
      expect(
        store.state.expenseConcepts.map(
          (concept) => concept.financialConceptId,
        ),
        ['outgo-active', 'outgo-active-2'],
      );
      expect(store.state.hasExpenseConcepts, isTrue);

      // O filtro também vai na query, para o servidor não devolver entradas.
      expect(conceptService.requestedType, FinancialConceptType.OUTGO);
      expect(conceptService.requestedStatementCategory, isNull);
    });

    test('oferece somente centros de custo ativos', () async {
      final store = RecurringPaymentOptionsStore(
        financialConceptService: _FakeFinancialConceptService(const []),
        costCenterService: _FakeCostCenterService([
          _costCenter('cc-1', 'Templo', active: true),
          _costCenter('cc-2', 'Sede', active: false),
        ]),
      );

      await store.searchOptions();

      expect(store.state.costCenters.map((costCenter) => costCenter.name), [
        'Templo',
      ]);
      expect(store.state.hasCostCenters, isTrue);
    });

    test('não recarrega com a mesma igreja e sim com outra', () async {
      final store = RecurringPaymentOptionsStore(
        financialConceptService: _FakeFinancialConceptService([
          _concept('outgo-active', 'Aluguel', type: 'OUTGO', active: true),
        ]),
        costCenterService: _FakeCostCenterService([
          _costCenter('cc-1', 'Templo', active: true),
        ]),
      );

      await store.searchOptions(churchId: 'church-a');

      expect(await store.needsLoad(churchId: 'church-a'), isFalse);
      // Otra igreja entra sem reiniciar o app: as opções anteriores não valem.
      expect(await store.needsLoad(churchId: 'church-b'), isTrue);
    });

    test('não quebra quando o serviço falha', () async {
      final store = RecurringPaymentOptionsStore(
        financialConceptService: _ThrowingFinancialConceptService(),
        costCenterService: _FakeCostCenterService(const []),
      );

      await store.searchOptions();

      expect(store.state.isLoading, isFalse);
      expect(store.state.expenseConcepts, isEmpty);
    });
  });
}

FinancialConceptModel _concept(
  String id,
  String name, {
  required String type,
  bool active = true,
}) {
  return FinancialConceptModel(
    financialConceptId: id,
    name: name,
    description: name,
    active: active,
    type: type,
    statementCategory: 'OPEX',
    affectsCashFlow: true,
    affectsResult: true,
    affectsBalance: false,
    isOperational: true,
    createdAt: DateTime(2026, 1, 1),
    churchId: 'church-1',
  );
}

CostCenterModel _costCenter(String id, String name, {required bool active}) {
  return CostCenterModel(
    active: active,
    churchId: 'church-1',
    costCenterId: id,
    name: name,
    description: name,
    category: CostCenterCategory.OPERATIONS,
    responsible: null,
    responsibleMemberId: null,
  );
}

class _FakeFinancialConceptService extends FinancialConceptService {
  _FakeFinancialConceptService(this.concepts);

  final List<FinancialConceptModel> concepts;
  FinancialConceptType? requestedType;
  StatementCategory? requestedStatementCategory;

  @override
  Future<List<FinancialConceptModel>> searchFinancialConcepts(
    String churchId,
    FinancialConceptType? type,
    StatementCategory? statementCategory,
  ) async {
    requestedType = type;
    requestedStatementCategory = statementCategory;
    return concepts;
  }
}

class _ThrowingFinancialConceptService extends FinancialConceptService {
  @override
  Future<List<FinancialConceptModel>> searchFinancialConcepts(
    String churchId,
    FinancialConceptType? type,
    StatementCategory? statementCategory,
  ) async {
    throw Exception('network down');
  }
}

class _FakeCostCenterService extends CostCenterService {
  _FakeCostCenterService(this.costCenters);

  final List<CostCenterModel> costCenters;

  @override
  Future<List<CostCenterModel>> searchCostCenters() async => costCenters;
}
