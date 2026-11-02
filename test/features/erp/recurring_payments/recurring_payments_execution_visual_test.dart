import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/auth/pages/login/state/auth_session_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_bill_simulation.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_month.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_pay_result.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_pix_qr_data.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/execution/recurring_payment_execution_sheet.dart';
import 'package:gloria_finance/features/erp/recurring_payments/service/recurring_payment_execution_service.dart';
import 'package:gloria_finance/features/erp/recurring_payments/state/recurring_payment_monthly_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/state/recurring_payment_options_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_monthly_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_options_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/state/availability_accounts_list_state.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/visual_harness.dart';

const _symbol = 'R\$';
const _dir = 'docs/pagamentos-recorrentes-execucao';

/// Genera las capturas del entregable de EJECUCIÓN MENSUAL y valida que cada
/// pantalla renderice sin excepciones en los tres tamaños.
///
/// ```bash
/// flutter test --dart-define=GENERATE_SCREENSHOTS=true \
///   test/features/erp/recurring_payments/recurring_payments_execution_visual_test.dart
/// ```
void main() {
  const generate = bool.fromEnvironment('GENERATE_SCREENSHOTS');
  final previousScannerPlatform = MobileScannerPlatform.instance;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    MobileScannerPlatform.instance = _VisualScannerPlatform();
    SharedPreferences.setMockInitialValues({});
    await loadAppFonts();
  });

  tearDownAll(() {
    MobileScannerPlatform.instance = previousScannerPlatform;
  });

  group('desktop payment flow', () {
    testWidgets('starts by selecting the Asaas availability account', (
      tester,
    ) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        selectAvailabilityAccount: false,
      );
      await _capture(tester, generate, 'desktop-01-selecao-conta.png');
      expect(
        find.text('De qual conta será feito o pagamento?'),
        findsOneWidget,
      );
      expect(find.text('Conta Asaas'), findsOneWidget);
      expect(find.text('Banco Itaú'), findsWidgets);
    });

    testWidgets('shows the PIX or boleto choice after selecting Asaas', (
      tester,
    ) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await _capture(tester, generate, 'desktop-02-asaas-instrumento.png');
      expect(find.text('Como deseja pagar?'), findsOneWidget);
      expect(find.text('PIX QR'), findsOneWidget);
      expect(find.text('BOLETO'), findsOneWidget);
    });

    testWidgets('shows the decoded QR amount before enabling payment', (
      tester,
    ) async {
      final service = _VisualExecutionService();
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Energia elétrica', type: 'VARIABLE'),
        service: service,
      );
      await _openPixPaste(tester);
      await _pastePix(tester);
      await _capture(tester, generate, 'desktop-04-qr-preview.png');
      expect(find.text('R\$ 150,00'), findsOneWidget);
      expect(find.text('CONFIRMAR PIX'), findsOneWidget);
      expect(service.payCalls, 0);
    });

    testWidgets(
      'simulates the boleto and shows the provider amount before payment',
      (tester) async {
        final service = _VisualExecutionService();
        await _pumpSheet(
          tester,
          size: _desktop,
          item: _item(name: 'Energia elétrica', type: 'VARIABLE'),
          service: service,
        );
        await _openBoletoLine(tester);
        await tester.enterText(
          find.byType(TextFormField),
          '00190000090123456789012345678901234567890123456',
        );
        await tester.pump();
        await tester.tap(find.text('CONSULTAR BOLETO'));
        await tester.pumpAndSettle();
        expect(service.simulateCalls, 1);
        await _capture(tester, generate, 'desktop-03-boleto-preview.png');
        expect(find.text('PAGAR BOLETO'), findsOneWidget);
        expect(find.text('R\$ 3.750,00'), findsWidgets);
        expect(service.payCalls, 0);
      },
    );
  });

  group('mobile payment flow', () {
    testWidgets('selects the Asaas account before the payment method', (
      tester,
    ) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        selectAvailabilityAccount: false,
      );
      await _capture(tester, generate, 'mobile-01-selecao-conta.png');
      expect(find.text('Confirmar pagamento PIX'), findsNothing);
      expect(
        find.text('De qual conta será feito o pagamento?'),
        findsOneWidget,
      );
      await _selectAvailabilityAccount(tester);
      expect(find.text('Como deseja pagar?'), findsOneWidget);
    });

    testWidgets('offers camera and copy-paste Pix input', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('PIX QR'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-03-asaas-instrumento.png');
      expect(find.text('Escanear QR Code'), findsOneWidget);
      expect(find.text('Pix copia e cola'), findsOneWidget);
    });

    testWidgets('opens the QR camera scanner with a paste fallback', (
      tester,
    ) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('PIX QR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Escanear QR Code'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-06-qr-scanner.png');
      expect(
        find.text('Posicione o QR Code dentro da área indicada.'),
        findsOneWidget,
      );
      expect(find.text('PIX COPIA E COLA'), findsOneWidget);
    });

    testWidgets('shows the decoded QR amount before payment confirmation', (
      tester,
    ) async {
      final service = _VisualExecutionService();
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        service: service,
      );
      await _openPixPaste(tester);
      await _pastePix(tester);
      await _capture(tester, generate, 'mobile-07-qr-preview.png');
      expect(find.text('R\$ 150,00'), findsOneWidget);
      expect(find.text('R\$ 3.500,00'), findsOneWidget);
      expect(find.text('CONFIRMAR PIX'), findsOneWidget);
      expect(service.payCalls, 0);
    });

    testWidgets('captures the boleto camera and typed-line entry', (
      tester,
    ) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('BOLETO'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('LER COM A CÂMERA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-05-boleto-camera.png');
      expect(find.text('Ler boleto'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DIGITAR LINHA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-04-boleto-linha.png');
      expect(find.text('Informe a linha digitável'), findsOneWidget);
    });

    testWidgets(
      'shows the simulated boleto amount before payment confirmation',
      (tester) async {
        final service = _VisualExecutionService();
        await _pumpSheet(
          tester,
          size: _mobile,
          item: _item(name: 'Energia elétrica', type: 'VARIABLE'),
          service: service,
        );
        await _openBoletoLine(tester);
        await tester.enterText(
          find.byType(TextFormField),
          '00190000090123456789012345678901234567890123456',
        );
        await tester.pump();
        await tester.tap(find.text('CONSULTAR BOLETO'));
        await tester.pumpAndSettle();
        expect(service.simulateCalls, 1);
        await _capture(tester, generate, 'mobile-08-boleto-preview.png');
        expect(find.text('PAGAR BOLETO'), findsOneWidget);
        expect(find.text('R\$ 3.750,00'), findsWidgets);
        expect(service.payCalls, 0);
      },
    );

    testWidgets('cash registration does not ask for a voucher', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        hasBanking: false,
        selectAvailabilityAccount: false,
      );
      await tester.tap(find.text('Dinheiro').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONTINUAR'));
      await tester.pumpAndSettle();
      await _capture(
        tester,
        generate,
        'mobile-08-registro-cash-sem-comprovante.png',
      );
      expect(find.text('Comprovante'), findsNothing);
    });

    testWidgets('bank registration requires a voucher', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        hasBanking: false,
        selectAvailabilityAccount: false,
      );
      await tester.tap(find.text('Banco Itaú').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONTINUAR'));
      await tester.pumpAndSettle();
      expect(find.text('Comprovante'), findsOneWidget);
      expect(find.text('Anexe o comprovante do pagamento.'), findsOneWidget);
    });
  });
}

const _desktop = Size(1440, 1000);
const _mobile = Size(390, 900);

Future<void> _pumpSheet(
  WidgetTester tester, {
  required Size size,
  required RecurringPaymentCompetenceModel item,
  bool hasBanking = true,
  bool selectAvailabilityAccount = true,
  RecurringPaymentExecutionService? service,
}) async {
  _setSurface(tester, size);

  final sheet = RecurringPaymentExecutionSheet(
    item: item,
    hasBanking: hasBanking,
    symbolFormatMoney: _symbol,
    service: service,
  );
  final isDesktop = size.width >= 768;
  final modal =
      isDesktop
          ? Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: sheet,
            ),
          )
          : sheet;

  await tester.pumpWidget(
    _wrap(
      child: modal,
      monthly: _monthlyStore(),
      hasBanking: hasBanking,
      executionModal: true,
      desktopModal: isDesktop,
    ),
  );
  await tester.pumpAndSettle();
  if (selectAvailabilityAccount) {
    await _selectAvailabilityAccount(tester);
  }
}

Future<void> _selectAvailabilityAccount(WidgetTester tester) async {
  await tester.tap(find.text('Conta Asaas').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('CONTINUAR'));
  await tester.pumpAndSettle();
}

Future<void> _openPixPaste(WidgetTester tester) async {
  await tester.tap(find.text('PIX QR'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Pix copia e cola'));
  await tester.pumpAndSettle();
}

Future<void> _pastePix(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '000201-pix-qr-original');
  await tester.pumpAndSettle();
  await tester.tap(find.text('CONTINUAR'));
  await tester.pumpAndSettle();
}

Future<void> _openBoletoLine(WidgetTester tester) async {
  await tester.tap(find.text('BOLETO'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('DIGITAR LINHA'));
  await tester.pumpAndSettle();
}

Widget _wrap({
  required Widget child,
  required RecurringPaymentMonthlyStore monthly,
  required bool hasBanking,
  bool executionModal = false,
  bool desktopModal = false,
}) {
  // `AuthSessionStore` recarga la sesión desde persistencia al construirse, así
  // que la sesión de prueba se siembra donde él la busca.
  SharedPreferences.setMockInitialValues({
    'session': jsonEncode({
      'roles': ['admin'],
      'token': 'token',
      'refreshToken': 'refresh',
      'name': 'Tesouraria',
      'email': 'tesouraria@igreja.org',
      'createdAt': '2026-01-01T00:00:00.000Z',
      'isActive': true,
      'userId': 'user-1',
      'church': {
        'churchId': 'church-1',
        'name': 'Igreja Central',
        'lang': 'pt-BR',
        'country': 'BR',
      },
      'isSuperUser': false,
      'asaasConnect': hasBanking,
    }),
  });

  final auth =
      AuthSessionStore()
        ..state = AuthSessionState(
          session: AuthSessionModel.empty().copyWith(
            churchId: 'church-1',
            token: 'token',
            refreshToken: 'refresh',
            country: 'BR',
            symbolFormatMoney: _symbol,
            asaasConnect: hasBanking,
          ),
        );

  final options =
      RecurringPaymentOptionsStore()
        ..state = RecurringPaymentOptionsState(
          makeRequest: false,
          expenseConcepts: _concepts,
          costCenters: _costCenters,
          loadedChurchId: 'church-1',
        );

  final accounts =
      AvailabilityAccountsListStore()
        ..state = AvailabilityAccountsListState(
          makeRequest: false,
          availabilityAccounts: _accounts,
        );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthSessionStore>.value(value: auth),
      ChangeNotifierProvider<RecurringPaymentMonthlyStore>.value(
        value: monthly,
      ),
      ChangeNotifierProvider<RecurringPaymentOptionsStore>.value(
        value: options,
      ),
      ChangeNotifierProvider<AvailabilityAccountsListStore>.value(
        value: accounts,
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.compact,
        useMaterial3: true,
      ),
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder:
            (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(0.90)),
              child: Scaffold(
                backgroundColor: Colors.white,
                body: RepaintBoundary(
                  key: const ValueKey('recurring-payments-capture'),
                  child:
                      executionModal
                          ? Stack(
                            fit: StackFit.expand,
                            children: [
                              const ColoredBox(color: Colors.white),
                              const ColoredBox(color: Color(0x99000000)),
                              if (desktopModal)
                                Center(child: child)
                              else
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                ),
                            ],
                          )
                          : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              child: child,
                            ),
                          ),
                ),
              ),
            ),
      ),
    ),
  );
}

RecurringPaymentMonthlyStore _monthlyStore() {
  return RecurringPaymentMonthlyStore()
    ..state = RecurringPaymentMonthlyState(
      makeRequest: false,
      month: _month,
      items: _items(),
      loadedChurchId: 'church-1',
      loadedCompetence: '2026-10',
    );
}

const _month = RecurringPaymentMonth(year: 2026, month: 10);

RecurringPaymentPayResult _paid() {
  return RecurringPaymentPayResult(
    outcome: RecurringPaymentPayOutcome.PAID,
    competence: '2026-10',
    amount: 3500,
    providerValueInCents: null,
    failureCode: null,
  );
}

class _VisualExecutionService extends RecurringPaymentExecutionService {
  _VisualExecutionService();

  int payCalls = 0;
  int simulateCalls = 0;

  @override
  Future<RecurringPaymentPixQrData> decodePixQr(
    String recurringPaymentId,
    String availabilityAccountId,
    String payload,
  ) async => const RecurringPaymentPixQrData(amountInCents: 15000);

  @override
  Future<RecurringPaymentPayResult> payPixQr(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) async {
    payCalls++;
    return _paid();
  }

  @override
  Future<RecurringPaymentBillSimulation> simulateBill(
    String recurringPaymentId,
    RecurringPaymentBillSimulationInput input,
  ) async {
    simulateCalls++;
    return const RecurringPaymentBillSimulation(
      minimumScheduleDate: '2026-10-17',
      feeInCents: 250,
      bankSlip: RecurringPaymentBankSlip(
        identificationField: '00190000090123456789012345678901234567890123',
        valueInCents: 375000,
        originalValueInCents: 375000,
        dueDate: '2026-10-10',
        companyName: 'Energia da Cidade S.A.',
        bank: 'Banco Exemplo',
        beneficiaryCpfCnpj: '19.540.550/0001-21',
        beneficiaryName: 'Energia da Cidade S.A.',
        allowChangeValue: false,
        minValueInCents: 100,
        maxValueInCents: 500000,
        discountValueInCents: 100,
        interestValueInCents: 250,
        fineValueInCents: 500,
        totalDiscountValueInCents: 100,
        totalAdditionalValueInCents: 750,
        isOverdue: true,
      ),
    );
  }
}

class _VisualScannerPlatform extends MobileScannerPlatform {
  @override
  Stream<BarcodeCapture?> get barcodesStream => const Stream.empty();

  @override
  Stream<TorchState> get torchStateStream => const Stream.empty();

  @override
  Stream<double> get zoomScaleStateStream => const Stream.empty();

  @override
  Widget buildCameraView() => const ColoredBox(color: Color(0xFF1F1F1F));

  @override
  Future<MobileScannerViewAttributes> start(StartOptions options) async =>
      MobileScannerViewAttributes(
        cameraDirection: options.cameraDirection,
        currentTorchMode: TorchState.off,
        numberOfCameras: 1,
        size: const Size(640, 480),
      );

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

List<RecurringPaymentCompetenceModel> _items() => [
  _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500, pix: true),
  _item(name: 'Energia elétrica', type: 'VARIABLE'),
  _item(
    name: 'Internet',
    type: 'FIXED',
    amount: 299.9,
    status: 'PAID',
    settlement: 'RECONCILED',
  ),
  _item(name: 'Água', type: 'FIXED', amount: 180.5, status: 'UPCOMING'),
  _item(
    name: 'Manutenção do som',
    type: 'VARIABLE',
    status: 'PROCESSING',
    execution: 'PROCESSING',
  ),
];

RecurringPaymentCompetenceModel _item({
  required String name,
  required String type,
  double? amount,
  bool pix = false,
  bool destination = true,
  String status = 'PENDING',
  String? execution,
  String? settlement,
}) {
  return RecurringPaymentCompetenceModel.fromJson({
    'recurringPaymentId': 'rp-$name',
    'churchId': 'church-1',
    'name': name,
    'financialConceptId': 'concept-1',
    'costCenterId': 'cc-1',
    'type': type,
    if (amount != null) 'amount': amount,
    'dayOfMonth': type == 'VARIABLE' ? 15 : 10,
    'status': 'ACTIVE',
    if (pix) 'pixDestination': destination ? _pix : null,
    'competence': '2026-10',
    'competenceStatus': status,
    if (execution != null)
      'currentPayment': {
        'competence': '2026-10',
        'attempt': 1,
        'externalReference': 'urn:recurringPayment:rp-$name:2026-10:1',
        if (amount != null) 'amount': amount,
        'paymentMethod': pix ? 'PIX' : 'BILL',
        'status': execution,
        'providerStatus': execution == 'BLOCKED' ? 'BLOCKED' : 'PENDING',
        'updatedAt': '2026-10-01T12:00:00.000Z',
      },
    if (settlement != null)
      'settlement': {
        'financialRecordId': 'record-$name',
        'amount': amount ?? 742.83,
        'date': '2026-10-10T00:00:00.000Z',
        'status': settlement,
        'availabilityAccountId': 'account-1',
      },
  });
}

const _pix = {'pixKey': '12.345.678/0001-90', 'pixKeyType': 'CNPJ'};

final _concepts = <FinancialConceptModel>[
  FinancialConceptModel(
    financialConceptId: 'concept-1',
    name: 'Aluguel',
    description: 'Aluguel',
    active: true,
    type: 'OUTGO',
    statementCategory: 'OPEX',
    affectsCashFlow: true,
    affectsResult: true,
    affectsBalance: false,
    isOperational: true,
    createdAt: DateTime(2026, 1, 1),
    churchId: 'church-1',
  ),
];

final _costCenters = <CostCenterModel>[
  CostCenterModel(
    costCenterId: 'cc-1',
    name: 'Templo',
    description: 'Templo',
    category: CostCenterCategory.OPERATIONS,
    responsible: const CostCenterResponsible(
      name: 'Tesouraria',
      email: 'tesouraria@igreja.org',
      phone: '11999999999',
    ),
    responsibleMemberId: null,
    active: true,
    churchId: 'church-1',
  ),
];

final _accounts = <AvailabilityAccountModel>[
  AvailabilityAccountModel(
    churchId: 'church-1',
    availabilityAccountId: 'asaas-account',
    accountName: 'Conta Asaas',
    balance: 10000,
    active: true,
    accountType: 'BANK',
    source: {
      'accountType': 'CURRENT',
      'active': true,
      'bankId': 'asaas-bank',
      'name': 'Asaas',
      'tag': 'asaas',
      'addressInstancePayment': '',
      'bankInstruction': {'codeBank': '', 'agency': '', 'account': ''},
      'churchId': 'church-1',
    },
    symbol: _symbol,
  ),
  AvailabilityAccountModel(
    churchId: 'church-1',
    availabilityAccountId: 'itau-account',
    accountName: 'Banco Itaú',
    balance: 10000,
    active: true,
    accountType: 'BANK',
    source: {
      'accountType': 'CURRENT',
      'active': true,
      'bankId': 'itau-bank',
      'name': 'Itaú',
      'tag': 'itau',
      'addressInstancePayment': '',
      'bankInstruction': {'codeBank': '', 'agency': '', 'account': ''},
      'churchId': 'church-1',
    },
    symbol: _symbol,
  ),
  AvailabilityAccountModel(
    churchId: 'church-1',
    availabilityAccountId: 'wallet-account',
    accountName: 'Carteira digital',
    balance: 250,
    active: true,
    accountType: 'WALLET',
    source: null,
    symbol: _symbol,
  ),
  AvailabilityAccountModel(
    churchId: 'church-1',
    availabilityAccountId: 'cash-account',
    accountName: 'Dinheiro',
    balance: 500,
    active: true,
    accountType: 'CASH',
    source: null,
    symbol: _symbol,
  ),
];

Future<void> _capture(WidgetTester tester, bool generate, String fileName) =>
    captureIfNeeded(tester, generate, '$_dir/$fileName');

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
