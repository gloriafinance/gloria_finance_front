import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/auth/pages/login/state/auth_session_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_bill_simulation.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_execution_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_month.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_pay_result.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/execution/recurring_payment_execution_sheet.dart';
import 'package:gloria_finance/features/erp/recurring_payments/service/recurring_payment_execution_service.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/execution/widgets/recurring_payment_execution_result_step.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/monthly/recurring_payment_monthly_view.dart';
import 'package:gloria_finance/features/erp/recurring_payments/pages/monthly/widgets/recurring_payment_execution_detail_sheet.dart';
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

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await loadAppFonts();
  });

  group('desktop', () {
    testWidgets('vista mensual com Asaas', (tester) async {
      await _pumpMonthly(
        tester,
        size: _desktop,
        hasBanking: true,
        items: _itemsWithoutInFlight(),
      );
      await _capture(tester, generate, 'desktop-01-mes-asaas.png');
      expect(find.text('Aluguel do templo'), findsOneWidget);
      expect(find.text('Pendente'), findsWidgets);
    });

    testWidgets('vista mensual sem Asaas', (tester) async {
      await _pumpMonthly(
        tester,
        size: _desktop,
        hasBanking: false,
        items: _itemsWithoutInFlight(),
      );
      await _capture(tester, generate, 'desktop-02-mes-sem-asaas.png');
      expect(find.text('REGISTRAR PAGAMENTO'), findsWidgets);
    });

    testWidgets('registro manual de valor fixo', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        hasBanking: false,
      );
      await _capture(tester, generate, 'desktop-03-registro-manual-fixo.png');
      expect(find.text('Registrar pagamento'), findsOneWidget);
    });

    testWidgets('registro manual de valor variável', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Energia elétrica', type: 'VARIABLE'),
        hasBanking: false,
      );
      await _capture(
        tester,
        generate,
        'desktop-04-registro-manual-variavel.png',
      );
      expect(find.text('Valor pago'), findsOneWidget);
    });

    testWidgets('com operação viva, nenhuma outra linha oferece pagamento', (
      tester,
    ) async {
      await _pumpMonthly(tester, size: _desktop, hasBanking: true);
      // Há um PROCESSING no mês: as outras linhas só podem ser consultadas.
      expect(find.text('PAGAR'), findsNothing);
      expect(find.text('Ver detalhes'), findsWidgets);
    });

    testWidgets('fixo com destino PIX: confirmação direta', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          pix: true,
        ),
      );
      await _capture(tester, generate, 'desktop-05-pix-confirmacao-direta.png');
      expect(find.text('CONFIRMAR PIX'), findsOneWidget);
    });

    testWidgets('fixo sem destino: escolher método', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await _capture(
        tester,
        generate,
        'desktop-06-fixo-sem-destino-metodo.png',
      );
      expect(find.text('Como deseja pagar?'), findsOneWidget);
      expect(find.textContaining('destino PIX configurado'), findsOneWidget);
      expect(find.textContaining('linha digitável do boleto'), findsOneWidget);
    });

    testWidgets('variável com destino PIX', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Energia elétrica', type: 'VARIABLE', pix: true),
      );
      await _capture(tester, generate, 'desktop-07-variavel-com-destino.png');
      expect(find.text('Valor a pagar'), findsOneWidget);
    });

    testWidgets('variável sem destino', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Energia elétrica', type: 'VARIABLE'),
      );
      await _capture(tester, generate, 'desktop-08-variavel-sem-destino.png');
      expect(find.text('Valor a pagar'), findsOneWidget);
    });

    testWidgets('PIX sem chave guardada', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          pix: true,
          destination: false,
        ),
      );
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'desktop-09-pix-sem-chave.png');
      expect(find.text('Chave PIX'), findsWidgets);
      expect(find.text('Informe a chave PIX'), findsOneWidget);
      expect(find.text('Digite ou cole a chave PIX'), findsOneWidget);
    });

    testWidgets('boleto: escolha da entrada', (tester) async {
      await tester.pumpAndSettle();
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'desktop-10-boleto-entrada.png');
      expect(find.text('Como deseja informar o boleto?'), findsOneWidget);
    });

    testWidgets('boleto: digitar linha', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DIGITAR LINHA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'desktop-11-boleto-digitar-linha.png');
      expect(find.text('Linha digitável'), findsOneWidget);
      expect(find.text('Informe a linha digitável'), findsOneWidget);
      expect(find.text('Digite ou cole a linha digitável'), findsOneWidget);
    });

    testWidgets('resultado PAID imediato', (tester) async {
      await _pumpResult(
        tester,
        size: _desktop,
        result: _paid(),
        method: RecurringPaymentMethodType.BILL,
      );
      await _capture(tester, generate, 'desktop-12-pagamento-confirmado.png');
      expect(find.text('Pagamento confirmado.'), findsOneWidget);
    });

    testWidgets('processando', (tester) async {
      await _pumpDetail(
        tester,
        size: _desktop,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          execution: 'PROCESSING',
          status: 'PROCESSING',
        ),
      );
      await _capture(tester, generate, 'desktop-14-processing.png');
      expect(find.text('Pagamento em processamento'), findsOneWidget);
    });

    testWidgets('bloqueado', (tester) async {
      await _pumpDetail(
        tester,
        size: _desktop,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          execution: 'BLOCKED',
          status: 'BLOCKED',
        ),
      );
      await _capture(tester, generate, 'desktop-15-blocked.png');
      expect(find.text('Pagamento bloqueado'), findsOneWidget);
    });

    testWidgets('falhou', (tester) async {
      await _pumpDetail(
        tester,
        size: _desktop,
        item: _item(
          name: 'Energia elétrica',
          type: 'VARIABLE',
          execution: 'FAILED',
          status: 'FAILED',
        ),
      );
      await _capture(tester, generate, 'desktop-16-failed.png');
      expect(find.text('Pagamento não concluído'), findsOneWidget);
    });

    testWidgets('pago por registro manual', (tester) async {
      await _pumpDetail(
        tester,
        size: _desktop,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          status: 'PAID',
          settlement: 'CLEARED',
        ),
      );
      await _capture(tester, generate, 'desktop-17-pago-manual.png');
      expect(find.text('Registro manual'), findsWidgets);
    });

    testWidgets('pago por débito bancário', (tester) async {
      await _pumpDetail(
        tester,
        size: _desktop,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          status: 'PAID',
          settlement: 'RECONCILED',
        ),
      );
      await _capture(tester, generate, 'desktop-18-pago-asaas.png');
      expect(
        find.text('Um débito bancário confirmado não pode ser cancelado.'),
        findsOneWidget,
      );
    });

    testWidgets('câmera do boleto', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('LER COM A CÂMERA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'desktop-19-boleto-camera.png');
      expect(find.text('Ler boleto'), findsOneWidget);
    });

    testWidgets('confirmação final do boleto', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        service: _VisualExecutionService(),
      );
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DIGITAR LINHA'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField),
        '00190000090123456789012345678901234567890123456',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONSULTAR BOLETO'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'desktop-20-boleto-confirmacao.png');
      expect(find.text('PAGAR BOLETO'), findsOneWidget);
      expect(find.text('Beneficiário'), findsOneWidget);
      expect(find.text('Valor do boleto'), findsOneWidget);
      expect(find.text('Vencimento'), findsOneWidget);
      expect(find.text('Boleto vencido'), findsWidgets);
      expect(find.text('VALORES DIFERENTES'), findsNothing);
      expect(find.textContaining('Nada foi debitado'), findsNothing);
    });
  });

  group('ações do detalhe (cabeçalho do modal)', () {
    testWidgets('bloqueado só consulta e nunca reintenta', (tester) async {
      await _pumpDetailModal(
        tester,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          execution: 'BLOCKED',
          status: 'BLOCKED',
        ),
      );
      expect(find.text('ATUALIZAR STATUS'), findsOneWidget);
      expect(find.text('TENTAR NOVAMENTE'), findsNothing);
    });

    testWidgets('falhou oferece uma execução nova', (tester) async {
      await _pumpDetailModal(
        tester,
        item: _item(
          name: 'Energia elétrica',
          type: 'VARIABLE',
          execution: 'FAILED',
          status: 'FAILED',
        ),
      );
      expect(find.text('TENTAR NOVAMENTE'), findsOneWidget);
    });

    testWidgets('pago manual permite cancelar; conciliado não', (tester) async {
      await _pumpDetailModal(
        tester,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          status: 'PAID',
          settlement: 'CLEARED',
        ),
      );
      expect(find.text('CANCELAR REGISTRO'), findsOneWidget);

      await _pumpDetailModal(
        tester,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          status: 'PAID',
          settlement: 'RECONCILED',
        ),
      );
      expect(find.text('CANCELAR REGISTRO'), findsNothing);
    });
  });

  group('tablet', () {
    testWidgets('vista mensal em duas colunas', (tester) async {
      await _pumpMonthly(
        tester,
        size: _tablet,
        hasBanking: true,
        items: _itemsWithoutInFlight(),
      );
      await _capture(tester, generate, 'tablet-01-mes.png');
      expect(find.text('Compromissos do mês'), findsOneWidget);
    });

    testWidgets('execução PIX', (tester) async {
      await _pumpSheet(
        tester,
        size: _tablet,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          pix: true,
        ),
      );
      await _capture(tester, generate, 'tablet-02-pix.png');
      expect(find.text('CONFIRMAR PIX'), findsOneWidget);
    });

    testWidgets('execução boleto', (tester) async {
      await _pumpSheet(
        tester,
        size: _tablet,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DIGITAR LINHA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'tablet-03-boleto.png');
      expect(find.text('Linha digitável'), findsOneWidget);
    });

    testWidgets('processando e bloqueado', (tester) async {
      await _pumpDetail(
        tester,
        size: _tablet,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          execution: 'BLOCKED',
          status: 'BLOCKED',
        ),
      );
      await _capture(tester, generate, 'tablet-04-bloqueado.png');
      expect(find.text('Pagamento bloqueado'), findsOneWidget);
    });
  });

  group('mobile', () {
    testWidgets('vista mensal em tarjetas', (tester) async {
      await _pumpMonthly(
        tester,
        size: _mobile,
        hasBanking: true,
        items: _itemsWithoutInFlight(),
      );
      await _capture(tester, generate, 'mobile-01-mes.png');
      expect(find.text('Aluguel do templo'), findsOneWidget);
    });

    testWidgets('fixo com destino PIX', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          pix: true,
        ),
      );
      await _capture(tester, generate, 'mobile-02-pix-configurado.png');
      expect(find.text('Confirmar pagamento PIX'), findsOneWidget);
    });

    testWidgets('pagar começa pela conta de disponibilidade', (tester) async {
      await _pumpSheet(
        tester,
        size: _desktop,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          pix: true,
        ),
        selectAvailabilityAccount: false,
      );
      await _capture(tester, generate, 'desktop-21-conta-disponibilidade.png');
      expect(find.text('Selecione a conta de disponibilidade'), findsOneWidget);
      expect(find.text('Confirmar pagamento PIX'), findsNothing);
    });

    testWidgets('seleciona conta de disponibilidade antes de confirmar PIX', (
      tester,
    ) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          pix: true,
        ),
        selectAvailabilityAccount: false,
      );
      await _capture(tester, generate, 'mobile-16-conta-disponibilidade.png');
      expect(find.text('Selecione a conta de disponibilidade'), findsOneWidget);
      expect(find.text('Confirmar pagamento PIX'), findsNothing);

      await _selectAvailabilityAccount(tester);
      expect(find.text('Confirmar pagamento PIX'), findsOneWidget);
    });

    testWidgets('variável com destino PIX', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Energia elétrica', type: 'VARIABLE', pix: true),
      );
      await _capture(tester, generate, 'mobile-03-variavel-com-destino.png');
      expect(find.text('Valor a pagar'), findsOneWidget);
    });

    testWidgets('PIX sem chave configurada', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Internet', type: 'FIXED', amount: 299.9),
      );
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-04-pix-sem-chave.png');
      expect(find.text('Chave PIX'), findsWidgets);
    });

    testWidgets('escolha de método', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
      );
      await _capture(tester, generate, 'mobile-05-metodo.png');
      expect(find.text('Como deseja pagar?'), findsOneWidget);
    });

    testWidgets('entrada do boleto', (tester) async {
      await _pumpBoletoEntry(tester);
      await _capture(tester, generate, 'mobile-06-boleto-entrada.png');
      expect(find.text('Como deseja informar o boleto?'), findsOneWidget);
    });

    testWidgets('câmera do boleto', (tester) async {
      await _pumpBoletoEntry(tester);
      await tester.tap(find.text('LER COM A CÂMERA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-07-boleto-camera.png');
      expect(find.text('Ler boleto'), findsOneWidget);
    });

    testWidgets('digitar linha', (tester) async {
      await _pumpBoletoEntry(tester);
      await tester.tap(find.text('DIGITAR LINHA'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-08-boleto-digitar-linha.png');
      expect(find.text('Linha digitável'), findsOneWidget);
      expect(find.text('Informe a linha digitável'), findsOneWidget);
    });

    testWidgets('boleto validado', (tester) async {
      await _pumpResult(
        tester,
        size: _mobile,
        result: _accepted(),
        method: RecurringPaymentMethodType.BILL,
      );
      await _capture(tester, generate, 'mobile-09-pagamento-enviado.png');
      expect(find.text('Pagamento enviado'), findsOneWidget);
    });

    testWidgets('resultado PAID imediato', (tester) async {
      await _pumpResult(
        tester,
        size: _mobile,
        result: _paid(),
        method: RecurringPaymentMethodType.BILL,
      );
      await _capture(tester, generate, 'mobile-11-pagamento-confirmado.png');
      expect(find.text('Pagamento confirmado.'), findsOneWidget);
    });

    testWidgets('confirmação final', (tester) async {
      await _pumpSheet(
        tester,
        size: _mobile,
        item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
        service: _VisualExecutionService(),
      );
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DIGITAR LINHA'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField),
        '00190000090123456789012345678901234567890123456',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONSULTAR BOLETO'));
      await tester.pumpAndSettle();
      await _capture(tester, generate, 'mobile-10-boleto-confirmacao.png');
      expect(find.text('PAGAR BOLETO'), findsOneWidget);
      expect(find.text('Beneficiário'), findsOneWidget);
    });

    testWidgets('processando', (tester) async {
      await _pumpDetail(
        tester,
        size: _mobile,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          execution: 'PROCESSING',
          status: 'PROCESSING',
        ),
      );
      await _capture(tester, generate, 'mobile-12-processing.png');
      expect(find.text('Pagamento em processamento'), findsOneWidget);
    });

    testWidgets('bloqueado', (tester) async {
      await _pumpDetail(
        tester,
        size: _mobile,
        item: _item(
          name: 'Internet',
          type: 'FIXED',
          amount: 299.9,
          execution: 'BLOCKED',
          status: 'BLOCKED',
        ),
      );
      await _capture(tester, generate, 'mobile-13-blocked.png');
      expect(find.text('Pagamento bloqueado'), findsOneWidget);
    });

    testWidgets('falhou', (tester) async {
      await _pumpDetail(
        tester,
        size: _mobile,
        item: _item(
          name: 'Energia elétrica',
          type: 'VARIABLE',
          execution: 'FAILED',
          status: 'FAILED',
        ),
      );
      await _capture(tester, generate, 'mobile-14-failed.png');
      expect(find.text('Pagamento não concluído'), findsOneWidget);
    });

    testWidgets('pago', (tester) async {
      await _pumpDetail(
        tester,
        size: _mobile,
        item: _item(
          name: 'Aluguel do templo',
          type: 'FIXED',
          amount: 3500,
          status: 'PAID',
          settlement: 'CLEARED',
        ),
      );
      await _capture(tester, generate, 'mobile-15-pago.png');
      expect(find.text('Pago'), findsWidgets);
    });
  });
}

const _desktop = Size(1440, 1000);
const _tablet = Size(834, 1112);
const _mobile = Size(390, 900);

Future<void> _pumpMonthly(
  WidgetTester tester, {
  required Size size,
  required bool hasBanking,
  List<RecurringPaymentCompetenceModel>? items,
}) async {
  _setSurface(tester, size);

  final monthly =
      RecurringPaymentMonthlyStore()
        ..state = RecurringPaymentMonthlyState(
          makeRequest: false,
          month: _month,
          items: items ?? _items(),
          loadedChurchId: 'church-1',
          loadedCompetence: '2026-10',
        );

  await tester.pumpWidget(
    _wrap(
      child: const RecurringPaymentMonthlyView(),
      monthly: monthly,
      hasBanking: hasBanking,
    ),
  );
  await tester.pumpAndSettle();
}

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
  if (hasBanking && selectAvailabilityAccount) {
    await _selectAvailabilityAccount(tester);
  }
}

Future<void> _selectAvailabilityAccount(WidgetTester tester) async {
  await tester.tap(find.text('Banco Itaú').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('CONTINUAR'));
  await tester.pumpAndSettle();
}

Future<void> _pumpBoletoEntry(WidgetTester tester) async {
  await _pumpSheet(
    tester,
    size: _mobile,
    item: _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500),
  );
  await tester.tap(find.text('Boleto'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('CONFIRMAR PAGAMENTO'));
  await tester.pumpAndSettle();
}

Future<void> _pumpResult(
  WidgetTester tester, {
  required Size size,
  required RecurringPaymentPayResult result,
  required RecurringPaymentMethodType method,
}) async {
  _setSurface(tester, size);

  await tester.pumpWidget(
    _wrap(
      child: RecurringPaymentExecutionResultStep(
        result: result,
        method: method,
        symbolFormatMoney: _symbol,
        onClose: () {},
        onRetry: () {},
      ),
      monthly: _monthlyStore(),
      hasBanking: true,
    ),
  );
  await tester.pumpAndSettle();
}

/// Captura o corpo do detalhe. O modal (`ModalPage`) abre em um overlay, fora do
/// boundary de captura, então o enquadramento é o conteúdo; as ações do
/// cabeçalho são verificadas em `_pumpDetailModal`.
Future<void> _pumpDetail(
  WidgetTester tester, {
  required Size size,
  required RecurringPaymentCompetenceModel item,
}) async {
  _setSurface(tester, size);

  await tester.pumpWidget(
    _wrap(
      child: RecurringPaymentExecutionDetail(item: item),
      monthly: _monthlyStore(),
      hasBanking: true,
    ),
  );
  await tester.pumpAndSettle();
}

/// Abre o modal de verdade para conferir as ações do cabeçalho.
Future<void> _pumpDetailModal(
  WidgetTester tester, {
  required RecurringPaymentCompetenceModel item,
}) async {
  _setSurface(tester, const Size(1440, 900));

  await tester.pumpWidget(
    _wrap(
      child: _DetailLauncher(item: item),
      monthly: _monthlyStore(),
      hasBanking: true,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('ABRIR DETALHE'));
  await tester.pumpAndSettle();
}

class _DetailLauncher extends StatelessWidget {
  const _DetailLauncher({required this.item});

  final RecurringPaymentCompetenceModel item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed:
            () => showRecurringPaymentExecutionDetail(context, item: item),
        child: const Text('ABRIR DETALHE'),
      ),
    );
  }
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

RecurringPaymentPayResult _accepted() {
  return RecurringPaymentPayResult(
    outcome: RecurringPaymentPayOutcome.PROCESSING,
    competence: '2026-10',
    amount: 3500,
    providerValueInCents: null,
    failureCode: null,
  );
}

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

  @override
  Future<RecurringPaymentBillSimulation> simulateBill(
    String recurringPaymentId,
    RecurringPaymentBillSimulationInput input,
  ) async {
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

List<RecurringPaymentCompetenceModel> _itemsWithoutInFlight() => [
  _item(name: 'Aluguel do templo', type: 'FIXED', amount: 3500, pix: true),
  _item(name: 'Energia elétrica', type: 'VARIABLE'),
  _item(
    name: 'Internet',
    type: 'FIXED',
    amount: 299.9,
    status: 'PAID',
    settlement: 'RECONCILED',
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
    availabilityAccountId: 'account-1',
    accountName: 'Banco Itaú',
    balance: 10000,
    active: true,
    accountType: 'CURRENT',
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
