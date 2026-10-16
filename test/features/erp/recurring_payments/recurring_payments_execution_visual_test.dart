import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/auth/pages/login/state/auth_session_state.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/execution/recurring_payment_execution_sheet.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_monthly_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:gloria_finance/features/erp/settings/banks/state/bank_state.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/state/availability_accounts_list_state.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/visual_harness.dart';

const _mobile = Size(390, 844);
const _desktop = Size(1440, 900);
const _symbol = 'R\$';
const _dir = 'docs/pagamentos-recorrentes-execucao';

void main() {
  const generate = bool.fromEnvironment('GENERATE_SCREENSHOTS');
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.steenbakker.mobile_scanner/scanner/method'),
          (_) async => null,
        );
    for (final channel in [
      'dev.steenbakker.mobile_scanner/scanner/event',
      'dev.steenbakker.mobile_scanner/scanner/deviceOrientation',
    ]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
            EventChannel(channel),
            MockStreamHandler.inline(onListen: (_, _) {}, onCancel: (_) {}),
          );
    }
    SharedPreferences.setMockInitialValues({});
    await loadAppFonts();
  });

  group('journeys mobile', () {
    testWidgets('seleção de conta', (tester) async {
      await _pump(tester, _mobile);
      await _capture(tester, generate, 'mobile-01-selecao-conta.png');
      expect(
        find.text('De qual conta será feito o pagamento?'),
        findsOneWidget,
      );
      expect(find.text('Conta Asaas'), findsOneWidget);
      expect(find.text('Itaú'), findsOneWidget);
    });

    testWidgets('registro manual', (tester) async {
      await _pump(tester, _mobile);
      await _select(tester, 'Itaú');
      await _capture(tester, generate, 'mobile-02-registro-manual.png');
      expect(find.text('Conta utilizada'), findsOneWidget);
      expect(find.text('Comprovante'), findsOneWidget);
      expect(find.text('PIX QR'), findsNothing);
      expect(find.text('BOLETO'), findsNothing);
    });

    testWidgets('conta CASH registra sem comprovante', (tester) async {
      await _pump(tester, _mobile, extraAccountType: 'CASH');
      await _select(tester, 'Fundo fixo');
      await _capture(
        tester,
        generate,
        'mobile-08-registro-cash-sem-comprovante.png',
      );
      expect(find.text('Comprovante'), findsNothing);
      expect(
        find.text(
          'Este pagamento foi realizado fora da Glória. Registre o gasto na conta selecionada.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('conta WALLET continua exigindo comprovante', (tester) async {
      await _pump(tester, _mobile, extraAccountType: 'WALLET');
      await _select(tester, 'Binance Dolar');
      expect(find.text('Comprovante'), findsOneWidget);
    });

    testWidgets('escolha Asaas Boleto e Pix QR', (tester) async {
      await _pumpAsaasInstrument(tester, _mobile);
      await _capture(tester, generate, 'mobile-03-asaas-instrumento.png');
      expect(find.text('PIX QR'), findsOneWidget);
      expect(find.text('BOLETO'), findsOneWidget);
    });

    testWidgets('linha digitável do boleto', (tester) async {
      await _pumpBoletoLine(tester, _mobile);
      await _capture(tester, generate, 'mobile-04-boleto-linha.png');
      expect(find.text('Linha digitável'), findsOneWidget);
    });

    testWidgets('preview do boleto', (tester) async {
      await _pumpBoletoPreview(tester, _mobile, amount: 487.32);
      await _capture(tester, generate, 'mobile-05-boleto-preview.png');
      expect(find.text('BOLETO VALIDADO'), findsOneWidget);
      expect(
        find.text('Pagamento simulado para demonstração.'),
        findsOneWidget,
      );
    });

    testWidgets('scanner QR', (tester) async {
      await _pumpAsaasInstrument(tester, _mobile);
      await _tapText(tester, 'PIX QR');
      await tester.pumpAndSettle();
      await _tapText(tester, 'LER QR CODE');
      await tester.pump();
      await _capture(tester, generate, 'mobile-06-qr-scanner.png');
      expect(
        find.text('Posicione o QR Code dentro da área indicada.'),
        findsOneWidget,
      );
      expect(find.text('COLAR PIX COPIA E COLA'), findsOneWidget);
    });

    testWidgets('preview QR por copia e cola', (tester) async {
      await _pumpQrPastePreview(
        tester,
        _mobile,
        variable: false,
        amount: 487.32,
      );
      await _capture(tester, generate, 'mobile-07-qr-preview.png');
      expect(find.text('PIX ENCONTRADO'), findsWidgets);
    });
  });

  group('journeys desktop', () {
    testWidgets('seleção de conta', (tester) async {
      await _pump(tester, _desktop);
      await _capture(tester, generate, 'desktop-01-selecao-conta.png');
      expect(
        find.text('De qual conta será feito o pagamento?'),
        findsOneWidget,
      );
    });

    testWidgets('escolha Asaas', (tester) async {
      await _pumpAsaasInstrument(tester, _desktop);
      await _capture(tester, generate, 'desktop-02-asaas-instrumento.png');
      expect(find.text('PIX QR'), findsOneWidget);
      expect(find.text('BOLETO'), findsOneWidget);
    });

    testWidgets('registro manual com comprovante compacto', (tester) async {
      await _pump(tester, _desktop, extraAccountType: 'WALLET');
      await _select(tester, 'Binance Dolar');
      await _capture(tester, generate, 'desktop-06-registro-manual-wallet.png');
      expect(find.text('Comprovante'), findsOneWidget);
      expect(find.text('SELECIONAR ARQUIVO'), findsOneWidget);
    });

    testWidgets('preview boleto', (tester) async {
      await _pumpBoletoPreview(tester, _desktop, amount: 487.32);
      await _capture(tester, generate, 'desktop-03-boleto-preview.png');
      expect(find.text('BOLETO VALIDADO'), findsOneWidget);
    });

    testWidgets('preview QR', (tester) async {
      await _pumpQrPastePreview(
        tester,
        _desktop,
        variable: false,
        amount: 487.32,
      );
      await _capture(tester, generate, 'desktop-04-qr-preview.png');
      expect(find.text('PIX ENCONTRADO'), findsWidgets);
    });
  });

  group('UI states', () {
    testWidgets(
      'sem Asaas seleciona conta normal e só oferece registro manual',
      (tester) async {
        await _pump(tester, _desktop, asaas: false);
        expect(find.text('Conta Asaas'), findsNothing);
        await _select(tester, 'Itaú');
        expect(find.text('Comprovante'), findsOneWidget);
        expect(find.text('PIX QR'), findsNothing);
        expect(find.text('BOLETO'), findsNothing);
      },
    );

    testWidgets(
      'com Asaas e bancos, Itaú volta ao seletor e Asaas abre instrumentos',
      (tester) async {
        await _pump(tester, _desktop);
        await _select(tester, 'Itaú');
        expect(find.text('Comprovante'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        await _select(tester, 'Conta Asaas');
        expect(find.text('PIX QR'), findsOneWidget);
        expect(find.text('BOLETO'), findsOneWidget);
      },
    );

    testWidgets('conta vinculada a banco ASAAS substitui a opção sintética', (
      tester,
    ) async {
      await _pump(tester, _desktop, asaasAccount: true);
      await _capture(
        tester,
        const bool.fromEnvironment('GENERATE_SCREENSHOTS'),
        'desktop-05-conta-asaas-vinculada.png',
      );
      expect(find.text('Conta Asaas'), findsNothing);
      expect(find.text('Conta Principal / Asaas'), findsOneWidget);
      await _select(tester, 'Conta Principal / Asaas');
      expect(find.text('PIX QR'), findsOneWidget);
      expect(find.text('Comprovante'), findsNothing);
    });

    testWidgets('boleto aceita 44, 47 e 48 dígitos e abre preview', (
      tester,
    ) async {
      for (final count in [44, 47, 48]) {
        await _pumpBoletoLine(tester, _desktop);
        await tester.enterText(find.byType(TextFormField), '7' * count);
        await tester.pumpAndSettle();
        await _pressFirstButton(tester);
        await tester.pumpAndSettle();
        expect(find.text('BOLETO VALIDADO'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });

    testWidgets('QR variável com valor embutido não pede valor', (
      tester,
    ) async {
      await _pumpQrPastePreview(
        tester,
        _desktop,
        variable: true,
        amount: 487.32,
      );
      expect(find.text('PIX ENCONTRADO'), findsWidgets);
      expect(find.text('Valor pago'), findsNothing);
      expect(find.textContaining('487,32'), findsWidgets);
    });

    testWidgets('QR variável sem valor pede valor após leitura', (
      tester,
    ) async {
      await _pumpAsaasInstrument(tester, _desktop, variable: true);
      await _tapText(tester, 'PIX QR');
      await tester.pumpAndSettle();
      await _tapText(tester, 'COLAR PIX COPIA E COLA');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'FIXTURE_SEM_VALOR');
      await tester.pumpAndSettle();
      await _pressFirstButton(tester);
      await tester.pumpAndSettle();
      expect(find.text('Valor pago'), findsWidgets);
    });

    testWidgets('boleto FIXED com divergência não permite confirmar', (
      tester,
    ) async {
      await _pumpBoletoPreview(tester, _desktop, amount: 450);
      expect(find.text('VALORES DIFERENTES'), findsOneWidget);
      final confirm = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton).first,
      );
      expect(confirm.onPressed, isNull);
    });

    testWidgets('QR FIXED com divergência não permite confirmar', (
      tester,
    ) async {
      await _pumpQrPastePreview(tester, _desktop, variable: false, amount: 450);
      expect(find.text('VALORES DIFERENTES'), findsOneWidget);
      expect(find.text('REVISAR PIX'), findsOneWidget);
    });

    testWidgets('manual FIXED mostra valor somente leitura', (tester) async {
      await _pump(tester, _desktop, asaas: false, variable: false);
      await _select(tester, 'Itaú');
      expect(
        find.text('Definido na configuração da recorrência'),
        findsOneWidget,
      );
      expect(find.text('Valor pago'), findsNothing);
    });

    testWidgets('manual VARIABLE permite informar valor', (tester) async {
      await _pump(tester, _desktop, asaas: false, variable: true);
      await _select(tester, 'Itaú');
      expect(find.text('Valor pago'), findsWidgets);
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('chave PIX cadastrada continua disponível como atalho', (
      tester,
    ) async {
      await _pumpAsaasInstrument(tester, _desktop, savedPix: true);
      expect(find.text('Destino PIX'), findsOneWidget);
      await _tapText(tester, 'Destino PIX');
      expect(find.text('Chave PIX'), findsNothing);
      expect(find.text('Como deseja pagar?'), findsOneWidget);
      expect(find.text('Boleto'), findsWidgets);
    });
  });
}

Future<void> _pumpAsaasInstrument(
  WidgetTester tester,
  Size size, {
  bool variable = false,
  double amount = 487.32,
  bool savedPix = false,
}) async {
  await _pump(
    tester,
    size,
    variable: variable,
    amount: amount,
    savedPix: savedPix,
  );
  await _select(tester, 'Conta Asaas');
}

Future<void> _pumpBoletoLine(
  WidgetTester tester,
  Size size, {
  double amount = 487.32,
}) async {
  await _pumpAsaasInstrument(tester, size, amount: amount);
  await _tapText(tester, 'BOLETO');
  await tester.pumpAndSettle();
  await _tapText(tester, 'DIGITAR LINHA');
  await tester.pumpAndSettle();
}

Future<void> _pumpBoletoPreview(
  WidgetTester tester,
  Size size, {
  required double amount,
}) async {
  await _pumpBoletoLine(tester, size, amount: amount);
  await tester.enterText(find.byType(TextFormField), '7' * 47);
  await tester.pumpAndSettle();
  await _pressNamedButton(tester, 'VALIDAR BOLETO');
  await tester.pumpAndSettle();
}

Future<void> _pumpQrPastePreview(
  WidgetTester tester,
  Size size, {
  required bool variable,
  required double amount,
}) async {
  await _pumpAsaasInstrument(tester, size, variable: variable, amount: amount);
  await _tapText(tester, 'PIX QR');
  await tester.pumpAndSettle();
  await _tapText(tester, 'COLAR PIX COPIA E COLA');
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField), 'FIXTURE_COM_VALOR');
  await tester.pumpAndSettle();
  await _pressFirstButton(tester);
  await tester.pumpAndSettle();
}

Future<void> _pump(
  WidgetTester tester,
  Size size, {
  bool asaas = true,
  bool asaasAccount = false,
  String? extraAccountType,
  bool variable = false,
  double amount = 487.32,
  bool savedPix = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  SharedPreferences.setMockInitialValues({});
  final auth =
      AuthSessionStore()
        ..state = AuthSessionState(
          session: AuthSessionModel.empty().copyWith(
            churchId: 'church-1',
            token: 'token',
            refreshToken: 'refresh',
            symbolFormatMoney: _symbol,
            asaasConnect: asaas,
          ),
        );
  final accounts =
      AvailabilityAccountsListStore()
        ..state = AvailabilityAccountsListState(
          makeRequest: false,
          availabilityAccounts: [
            AvailabilityAccountModel(
              churchId: 'church-1',
              availabilityAccountId: 'account-itau',
              accountName: 'Itaú',
              balance: 5000,
              active: true,
              accountType: 'BANK',
              source: null,
              symbol: _symbol,
            ),
            if (extraAccountType != null)
              AvailabilityAccountModel(
                churchId: 'church-1',
                availabilityAccountId: 'account-extra',
                accountName:
                    extraAccountType == 'CASH' ? 'Fundo fixo' : 'Binance Dolar',
                balance: 250,
                active: true,
                accountType: extraAccountType,
                source: null,
                symbol: _symbol,
              ),
            if (asaasAccount)
              AvailabilityAccountModel(
                churchId: 'church-1',
                availabilityAccountId: 'account-asaas',
                accountName: 'Conta Principal / Asaas',
                balance: 1070.92,
                active: true,
                accountType: 'BANK',
                source: {
                  'bankId': 'asaas-bank',
                  'bankInstruction': {
                    'codeBank': '461',
                    'agency': '0001',
                    'account': '8062510-6',
                  },
                },
                symbol: _symbol,
              ),
          ],
        );
  final banks =
      BankStore()
        ..state = BankState(
          banks:
              asaasAccount
                  ? [
                    BankModel.fromJson({
                      'accountType': 'CURRENT',
                      'active': true,
                      'bankId': 'asaas-bank',
                      'provider': 'ASAAS',
                      'name': 'Asaas',
                      'tag': 'Conta Principal / Asaas',
                      'addressInstancePayment': '',
                      'bankInstruction': {
                        'codeBank': '461',
                        'agency': '0001',
                        'account': '8062510-6',
                      },
                      'churchId': 'church-1',
                    }),
                  ]
                  : [],
          makeRequest: false,
        );
  final item = RecurringPaymentCompetenceModel.fromJson({
    'recurringPaymentId': 'rp-1',
    'churchId': 'church-1',
    'name': 'Energia elétrica',
    'financialConceptId': 'concept-1',
    'costCenterId': 'cc-1',
    'type': variable ? 'VARIABLE' : 'FIXED',
    if (!variable) 'amount': amount,
    if (savedPix)
      'pixDestination': {'pixKey': '12345678000190', 'pixKeyType': 'CNPJ'},
    'dayOfMonth': 15,
    'status': 'ACTIVE',
    'competence': '2026-10',
    'competenceStatus': 'PENDING',
  });
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthSessionStore>.value(value: auth),
        ChangeNotifierProvider<RecurringPaymentMonthlyStore>.value(
          value: RecurringPaymentMonthlyStore(),
        ),
        ChangeNotifierProvider<AvailabilityAccountsListStore>.value(
          value: accounts,
        ),
        ChangeNotifierProvider<BankStore>.value(value: banks),
      ],
      child: MaterialApp(
        locale: const Locale('pt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RepaintBoundary(
            key: const ValueKey('recurring-payments-capture'),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: RecurringPaymentExecutionSheet(
                  item: item,
                  asaasAvailable: asaas,
                  symbolFormatMoney: _symbol,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> _pressFirstButton(WidgetTester tester) async {
  final button = tester.widget<ElevatedButton>(
    find.byType(ElevatedButton).first,
  );
  expect(button.onPressed, isNotNull);
  button.onPressed!.call();
  await tester.pumpAndSettle();
}

Future<void> _pressNamedButton(WidgetTester tester, String label) async {
  final button = find.ancestor(
    of: find.text(label),
    matching: find.byType(ElevatedButton),
  );
  final widget = tester.widget<ElevatedButton>(button.first);
  expect(widget.onPressed, isNotNull);
  widget.onPressed!.call();
  await tester.pumpAndSettle();
}

Future<void> _select(WidgetTester tester, String name) async {
  await tester.tap(find.text(name).first);
  await tester.pumpAndSettle();
  await _tapText(tester, 'CONTINUAR');
  await tester.pumpAndSettle();
}

Future<void> _capture(WidgetTester tester, bool enabled, String name) async {
  if (!enabled) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('recurring-payments-capture')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$_dir/$name')..createSync(recursive: true);
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}
