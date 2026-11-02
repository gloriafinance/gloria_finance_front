import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/recurring_payment_form/widgets/recurring_payment_form_view.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/recurring_payment_list/widgets/recurring_payment_list_view.dart';
import 'package:gloria_finance/features/erp/recurring_payments/service/recurring_payment_service.dart';
import 'package:gloria_finance/features/erp/recurring_payments/state/recurring_payment_options_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_list_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_options_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/visual_harness.dart';

const _symbol = 'R\$';

/// Genera las capturas del entregable de UI/UX de Pagamentos Recorrentes y
/// valida que las pantallas rendericen sin excepciones en los tres tamaños.
///
/// Sin `--dart-define=GENERATE_SCREENSHOTS=true` solo corre como smoke test.
/// Con el flag escribe PNGs en `docs/pagamentos-recorrentes/`:
///
/// ```bash
/// flutter test --dart-define=GENERATE_SCREENSHOTS=true \
///   test/features/erp/recurring_payments/recurring_payments_visual_test.dart
/// ```
void main() {
  const generate = bool.fromEnvironment('GENERATE_SCREENSHOTS');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Las vistas consultan la iglesia de la sesión (`AuthPersistence`).
    SharedPreferences.setMockInitialValues({});
    await loadAppFonts();
  });

  group('listado', () {
    testWidgets('desktop 1440x900 con recurrencias', (tester) async {
      await _pumpList(tester, size: const Size(1440, 900), payments: _payments);
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/desktop-01-listado.png',
      );
      expect(find.text('Pagamentos recorrentes'), findsOneWidget);
      expect(find.text('Aluguel do templo'), findsOneWidget);
      expect(find.text('Valor variável'), findsWidgets);
    });

    testWidgets('desktop 1440x900 vazio', (tester) async {
      await _pumpList(tester, size: const Size(1440, 900), payments: const []);
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/desktop-02-vazio.png',
      );
      expect(
        find.text('Nenhum pagamento recorrente cadastrado'),
        findsOneWidget,
      );
    });

    testWidgets('tablet 834x1112', (tester) async {
      await _pumpList(tester, size: const Size(834, 1112), payments: _payments);
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/tablet-01-listado.png',
      );
      expect(find.text('Dia 10'), findsOneWidget);
    });

    testWidgets('mobile 390x844 con tarjetas', (tester) async {
      await _pumpList(tester, size: const Size(390, 844), payments: _payments);
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/mobile-01-cards.png',
      );
      expect(find.text('Dia 10'), findsOneWidget);
    });

    testWidgets('desktop 1440x900 busca sin resultados', (tester) async {
      await _pumpList(
        tester,
        size: const Size(1440, 900),
        payments: _payments,
        searchTerm: 'copa',
      );
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/desktop-05-sem-resultados.png',
      );
      expect(find.text('Nenhum resultado encontrado'), findsOneWidget);
    });

    testWidgets('mobile 390x844 busca sin resultados', (tester) async {
      await _pumpList(
        tester,
        size: const Size(390, 844),
        payments: _payments,
        searchTerm: 'copa',
      );
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/mobile-04-sem-resultados.png',
      );
      expect(find.text('Nenhum resultado encontrado'), findsOneWidget);
    });

    testWidgets('mobile 390x844 vazio', (tester) async {
      await _pumpList(tester, size: const Size(390, 844), payments: const []);
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/mobile-02-vazio.png',
      );
      expect(
        find.text('Criar primeiro pagamento'.toUpperCase()),
        findsOneWidget,
      );
    });
  });

  group('formulario', () {
    testWidgets('desktop · novo pagamento (valor fixo)', (tester) async {
      await _pumpForm(tester, size: const Size(1440, 1500));
      await tester.enterText(
        find.byType(TextFormField).first,
        'Aluguel do templo',
      );
      await tester.pumpAndSettle();
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/desktop-03-form-novo-fixo.png',
      );

      // Na criação não existe switch de situação: a recorrência nasce ativa.
      expect(find.text('SITUAÇÃO'), findsNothing);
      expect(find.textContaining('criada ativa'), findsOneWidget);
    });

    testWidgets('desktop · novo pagamento (valor variável + PIX)', (
      tester,
    ) async {
      await _pumpForm(tester, size: const Size(1440, 1560));
      await tester.tap(find.text('Variável'));
      await tester.pumpAndSettle();

      // Na criação o único switch é o do PIX reutilizável.
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Hierarquia: o tipo vem antes da chave (na mesma linha, à esquerda).
      expect(
        tester.getTopLeft(find.text('Tipo da chave')).dx,
        lessThan(tester.getTopLeft(find.text('Chave PIX')).dx),
      );

      // A máscara acompanha o tipo: o padrão é CNPJ.
      await tester.enterText(find.byType(TextFormField).last, '12345678000190');
      await tester.pumpAndSettle();
      expect(find.text('12.345.678/0001-90'), findsOneWidget);

      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/desktop-04-form-novo-variavel-pix.png',
      );
      expect(find.textContaining('Valor mensal'), findsNothing);
      expect(find.text('Destino reutilizável (opcional)'), findsOneWidget);
    });

    testWidgets('desktop · editar recorrencia (com situação)', (tester) async {
      await _pumpForm(
        tester,
        size: const Size(1440, 1500),
        payment: _fixedPayment,
      );
      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/desktop-06-form-editar.png',
      );

      // Editando, pausar/retomar existe e o texto explica quando usar.
      expect(find.text('SITUAÇÃO'), findsOneWidget);

      // Salvar usa o verde do ERP, não o púrpura da marca.
      final saveButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'SALVAR ALTERAÇÕES'),
      );
      expect(
        saveButton.style?.backgroundColor?.resolve(<WidgetState>{}),
        AppColors.green,
      );
      expect(find.textContaining('entra em todos os meses'), findsOneWidget);

      // O primeiro switch é o da situação (a seção 2 vem antes da seção de PIX).
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();
      expect(find.textContaining('pausa a recorrência'), findsOneWidget);
    });

    testWidgets('mobile · novo pagamento em uma coluna', (tester) async {
      await _pumpForm(tester, size: const Size(390, 1900));

      // Uma coluna: o tipo da chave fica acima da chave, com a máscara do tipo.
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Tipo da chave')).dy,
        lessThan(tester.getTopLeft(find.text('Chave PIX')).dy),
      );

      await captureIfNeeded(
        tester,
        generate,
        'docs/pagamentos-recorrentes/mobile-03-form.png',
      );
      expect(find.text('Informações básicas'), findsOneWidget);
      expect(find.text('SITUAÇÃO'), findsNothing);
    });
  });
}

// --- datos de ejemplo -------------------------------------------------------

final _fixedPayment = RecurringPaymentModel(
  recurringPaymentId: 'rp-1',
  churchId: 'church-1',
  name: 'Aluguel do templo',
  financialConceptId: 'concept-rent',
  costCenterId: 'cc-temple',
  type: RecurringPaymentValueType.FIXED,
  amount: 3500,
  dayOfMonth: 10,
  status: RecurringPaymentStatus.ACTIVE,
  pixDestination: const RecurringPixDestination(
    pixKey: '12.345.678/0001-90',
    pixKeyType: PixKeyType.CNPJ,
  ),
);

final _variablePaymentWithPix = RecurringPaymentModel(
  recurringPaymentId: 'rp-2',
  churchId: 'church-1',
  name: 'Energia elétrica',
  financialConceptId: 'concept-energy',
  costCenterId: 'cc-temple',
  type: RecurringPaymentValueType.VARIABLE,
  amount: null,
  dayOfMonth: 15,
  status: RecurringPaymentStatus.ACTIVE,
  pixDestination: const RecurringPixDestination(
    pixKey: '(11) 98888-7777',
    pixKeyType: PixKeyType.PHONE,
  ),
);

final _payments = <RecurringPaymentModel>[
  _fixedPayment,
  _variablePaymentWithPix,
  RecurringPaymentModel(
    recurringPaymentId: 'rp-3',
    churchId: 'church-1',
    name: 'Água',
    financialConceptId: 'concept-water',
    costCenterId: 'cc-temple',
    type: RecurringPaymentValueType.VARIABLE,
    amount: null,
    dayOfMonth: 20,
    status: RecurringPaymentStatus.ACTIVE,
    pixDestination: null,
  ),
  RecurringPaymentModel(
    recurringPaymentId: 'rp-4',
    churchId: 'church-1',
    name: 'Internet',
    financialConceptId: 'concept-internet',
    costCenterId: 'cc-admin',
    type: RecurringPaymentValueType.FIXED,
    amount: 249.90,
    dayOfMonth: 5,
    status: RecurringPaymentStatus.ACTIVE,
    pixDestination: null,
  ),
  RecurringPaymentModel(
    recurringPaymentId: 'rp-5',
    churchId: 'church-1',
    name: 'Dízimo dos dízimos',
    financialConceptId: 'concept-tithe',
    costCenterId: 'cc-headquarters',
    type: RecurringPaymentValueType.VARIABLE,
    amount: null,
    dayOfMonth: 28,
    status: RecurringPaymentStatus.ACTIVE,
    pixDestination: null,
  ),
  RecurringPaymentModel(
    recurringPaymentId: 'rp-6',
    churchId: 'church-1',
    name: 'Oferta de missões',
    financialConceptId: 'concept-missions',
    costCenterId: 'cc-missions',
    type: RecurringPaymentValueType.FIXED,
    amount: 1200,
    dayOfMonth: 25,
    status: RecurringPaymentStatus.INACTIVE,
    pixDestination: const RecurringPixDestination(
      pixKey: 'financeiro@igreja.org',
      pixKeyType: PixKeyType.EMAIL,
    ),
  ),
];

// --- helpers ---------------------------------------------------------------

Future<void> _pumpList(
  WidgetTester tester, {
  required Size size,
  required List<RecurringPaymentModel> payments,
  String? searchTerm,
}) async {
  _setSurface(tester, size);

  final listStore = RecurringPaymentListStore(
    service: _FakeRecurringPaymentService(payments),
  );
  await listStore.searchRecurringPayments();

  if (searchTerm != null) {
    listStore.setSearchTerm(searchTerm);
    listStore.applyFilters();
  }

  await tester.pumpWidget(
    _wrap(
      listStore: listStore,
      contentPadding: size.width < 768 ? 10 : 20,
      child: const RecurringPaymentListView(symbolFormatMoney: _symbol),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpForm(
  WidgetTester tester, {
  required Size size,
  RecurringPaymentModel? payment,
}) async {
  _setSurface(tester, size);

  await tester.pumpWidget(
    _wrap(
      contentPadding: size.width < 768 ? 10 : 20,
      listStore: RecurringPaymentListStore(
        service: _FakeRecurringPaymentService(const []),
      ),
      child: RecurringPaymentFormView(
        symbolFormatMoney: _symbol,
        recurringPayment: payment,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Widget _wrap({
  required RecurringPaymentListStore listStore,
  required Widget child,
  required double contentPadding,
}) {
  // El módulo carga sus propias opciones (solo conceptos de gasto); en el test
  // se inyectan ya resueltas para no depender de la red.
  final optionsStore =
      RecurringPaymentOptionsStore()
        ..state = RecurringPaymentOptionsState(
          makeRequest: false,
          expenseConcepts: _concepts,
          costCenters: _costCenters,
          // Coincide con la sesión simulada (vacía) para que la vista no intente
          // recargar por red durante el render.
          loadedChurchId: '',
        );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<RecurringPaymentListStore>.value(value: listStore),
      ChangeNotifierProvider<RecurringPaymentOptionsStore>.value(
        value: optionsStore,
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // Mismo theme base que app/my_app.dart.
      theme: ThemeData(
        visualDensity: VisualDensity.compact,
        useMaterial3: true,
      ),
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // La app escala el texto a 0.90 (my_app.dart); sin esto la captura no
      // representa lo que ve el usuario.
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(0.90)),
            child: child!,
          ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: RepaintBoundary(
          key: const ValueKey('recurring-payments-capture'),
          child: SingleChildScrollView(
            child: Padding(
              // Reproduce el padding que el shell del ERP aplica al contenido.
              padding: EdgeInsets.symmetric(
                horizontal: contentPadding,
                vertical: 14,
              ),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

final _concepts = <FinancialConceptModel>[
  _concept('concept-rent', 'Aluguel'),
  _concept('concept-energy', 'Energia elétrica'),
  _concept('concept-water', 'Água'),
  _concept('concept-internet', 'Internet'),
  _concept('concept-tithe', 'Dízimo dos dízimos'),
  _concept('concept-missions', 'Missões'),
];

FinancialConceptModel _concept(String id, String name) {
  return FinancialConceptModel(
    financialConceptId: id,
    name: name,
    description: name,
    active: true,
    type: 'OUTGO',
    statementCategory: 'OPEX',
    affectsCashFlow: true,
    affectsResult: true,
    affectsBalance: false,
    isOperational: true,
    createdAt: DateTime(2026, 1, 1),
    churchId: 'church-1',
  );
}

final _costCenters = <CostCenterModel>[
  _costCenter('cc-temple', 'Templo'),
  _costCenter('cc-admin', 'Administrativo'),
  _costCenter('cc-headquarters', 'Sede'),
  _costCenter('cc-missions', 'Missões'),
];

CostCenterModel _costCenter(String id, String name) {
  return CostCenterModel(
    active: true,
    churchId: 'church-1',
    costCenterId: id,
    name: name,
    description: name,
    category: CostCenterCategory.OPERATIONS,
    responsible: null,
    responsibleMemberId: null,
  );
}

class _FakeRecurringPaymentService extends RecurringPaymentService {
  _FakeRecurringPaymentService(this.payments);

  final List<RecurringPaymentModel> payments;

  @override
  Future<List<RecurringPaymentModel>> searchRecurringPayments() async =>
      payments;

  @override
  Future<void> createRecurringPayment(Map<String, dynamic> payload) async {}

  @override
  Future<void> updateRecurringPayment(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) async {}
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Carga las Poppins reales: sin esto el motor de test dibuja cajas.
