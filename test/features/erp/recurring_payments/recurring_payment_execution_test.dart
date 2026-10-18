import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_bill_simulation.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_status.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_execution_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_month.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_pay_result.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_pix_qr_data.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_source_ui_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_settlement_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/state/recurring_payment_execution_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_execution_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/service/recurring_payment_execution_service.dart';
import 'package:gloria_finance/features/erp/recurring_payments/utils/recurring_payment_boleto.dart';

/// A execução mensal: estado por competência, matriz de casos e regras do
/// payload. O que o backend decidiu não se recalcula aqui.
void main() {
  group('RecurringPaymentMonth', () {
    test('usa o mês de São Paulo, não o do dispositivo', () {
      // 02:00 UTC de 1º de outubro ainda é setembro em São Paulo (UTC-3).
      expect(
        RecurringPaymentMonth.current(DateTime.utc(2026, 10, 1, 2)).competence,
        '2026-09',
      );
      expect(
        RecurringPaymentMonth.current(DateTime.utc(2026, 10, 1, 12)).competence,
        '2026-10',
      );
    });

    test('navega entre meses virando o ano', () {
      const december = RecurringPaymentMonth(year: 2026, month: 12);
      expect(december.next.competence, '2027-01');
      expect(december.previous.competence, '2026-11');
    });

    test('recusa competência fora do contrato', () {
      expect(RecurringPaymentMonth.tryParse('2026-13'), isNull);
      expect(RecurringPaymentMonth.tryParse('26-10'), isNull);
      expect(RecurringPaymentMonth.tryParse('2026-10')?.competence, '2026-10');
    });

    test('limita o vencimento ao último dia do mês, como o backend', () {
      // Dia 31 em fevereiro vale 28 (2026 não é bissexto).
      const february = RecurringPaymentMonth(year: 2026, month: 2);
      expect(february.dueDate(31).day, 28);
      expect(february.dueDate(10).day, 10);
    });
  });

  group('estado da competência', () {
    test('reconhece os sete estados do contrato e nada mais', () {
      expect(
        RecurringPaymentCompetenceStatusExtension.tryFromApiValue('PENDING'),
        RecurringPaymentCompetenceStatus.PENDING,
      );
      expect(
        RecurringPaymentCompetenceStatusExtension.tryFromApiValue('PAID'),
        RecurringPaymentCompetenceStatus.PAID,
      );
      expect(
        RecurringPaymentCompetenceStatusExtension.tryFromApiValue('DONE'),
        isNull,
      );
      expect(
        RecurringPaymentCompetenceStatusExtension.tryFromApiValue(null),
        isNull,
      );
    });

    test('só pendente e a vencer permitem pagar; bloqueado não reintenta', () {
      expect(RecurringPaymentCompetenceStatus.PENDING.canExecute, isTrue);
      expect(RecurringPaymentCompetenceStatus.UPCOMING.canExecute, isTrue);
      expect(RecurringPaymentCompetenceStatus.PROCESSING.canExecute, isFalse);
      expect(RecurringPaymentCompetenceStatus.BLOCKED.canRetry, isFalse);
      expect(RecurringPaymentCompetenceStatus.FAILED.canRetry, isTrue);
      expect(RecurringPaymentCompetenceStatus.PAID.isPaid, isTrue);
    });
  });

  group('RecurringPaymentCompetenceModel', () {
    test('lê o detalhe da execução e o resumo do asiento', () {
      final item = RecurringPaymentCompetenceModel.fromJson({
        'recurringPaymentId': 'rp-1',
        'churchId': 'church-1',
        'name': 'Aluguel do templo',
        'financialConceptId': 'concept-1',
        'costCenterId': 'cc-1',
        'type': 'FIXED',
        'amount': 3500.0,
        'dayOfMonth': 10,
        'status': 'ACTIVE',
        'competence': '2026-10',
        'competenceStatus': 'PAID',
        'currentPayment': {
          'competence': '2026-10',
          'externalReference': 'urn:recurringPayment:rp-1:2026-10',
          'amount': 3500.0,
          'paymentMethod': 'BILL',
          'status': 'FAILED',
          'updatedAt': '2026-10-01T12:00:00.000Z',
        },
        'settlement': {
          'financialRecordId': 'record-1',
          'amount': 3500.0,
          'date': '2026-10-10T00:00:00.000Z',
          'status': 'RECONCILED',
          'availabilityAccountId': 'account-1',
          'voucher': 'https://storage/receipt.pdf',
        },
      });

      expect(item.status, RecurringPaymentCompetenceStatus.PAID);
      expect(item.isPaid, isTrue);
      // Histórico manda: pago continua pago mesmo com execução antiga falhada.
      expect(item.dueDate.day, 10);
      expect(item.settlement?.origin, RecurringPaymentSettlementOrigin.BANK);
      // Débito bancário confirmado não se cancela.
      expect(item.settlement?.canBeCancelled, isFalse);
    });

    test(
      'um registro manual pode ser cancelado; um status desconhecido não',
      () {
        final manual = RecurringPaymentSettlementModel.fromJson({
          'financialRecordId': 'record-1',
          'amount': 10,
          'status': 'CLEARED',
        });
        expect(manual.canBeCancelled, isTrue);

        final desconhecido = RecurringPaymentSettlementModel.fromJson({
          'financialRecordId': 'record-2',
          'amount': 10,
          'status': 'PARTIAL',
        });
        expect(desconhecido.origin, RecurringPaymentSettlementOrigin.UNKNOWN);
        expect(desconhecido.canBeCancelled, isFalse);
      },
    );

    test('estado desconhecido nunca libera pagamento', () {
      final item = _item(json: {'type': 'FIXED', 'amount': 10}, status: 'DONE');
      expect(item.status, isNull);
      expect(item.canExecute, isFalse);
      expect(item.canRetry, isFalse);
    });
  });

  group('PIX QR', () {
    test(
      'PIX variável usa o valor decodificado e preserva o payload original',
      () async {
        final store = RecurringPaymentExecutionStore(
          item: _item(json: const {'type': 'VARIABLE', 'pixDestination': _pix}),
          hasBanking: true,
          service: _ExecutionServiceStub(
            decodedPixQr: const RecurringPaymentPixQrData(amountInCents: 74283),
          ),
        );
        store.setSource(
          const RecurringPaymentSourceUiModel(
            id: 'availability-1',
            name: 'Conta Asaas',
            subtitle: 'Conta conectada',
            capability: RecurringPaymentSourceCapability.asaas,
            availabilityAccountId: 'availability-1',
          ),
        );

        final decoded = await store.decodePixQr('000201-copy-paste-raw');
        expect(decoded, isTrue);
        expect(store.state.requiresAmount, isFalse);
        expect(store.state.amount, 742.83);
        expect(store.state.isComplete, isTrue);
        expect(store.state.payPayload.containsKey('amount'), isFalse);
        expect(store.state.payPayload['payment'], {
          'type': 'PIX_QR',
          'payload': '000201-copy-paste-raw',
        });
      },
    );
  });

  group('registro manual', () {
    test('só envia valor cuando é variável', () {
      final fixed = _state(const {
        'type': 'FIXED',
        'amount': 3500,
      }, hasBanking: false);
      expect(
        fixed
            .manualPayload(
              paymentDate: '2026-10-10',
              availabilityAccountId: 'a-1',
            )
            .containsKey('amount'),
        isFalse,
      );

      final variable = _state(
        const {'type': 'VARIABLE'},
        hasBanking: false,
        setup: (store) => store.setAmountText('74283'),
      );
      expect(
        variable.manualPayload(
          paymentDate: '2026-10-10',
          availabilityAccountId: 'a-1',
        )['amount'],
        742.83,
      );
    });
  });

  group('formatação de boleto', () {
    test('remove caracteres visuais sem decidir se a linha é válida', () {
      expect(RecurringPaymentBoleto.onlyDigits('001.90 000-09'), '0019000009');
      expect(RecurringPaymentBoleto.onlyDigits('123'), '123');
    });

    test('mostra só o final na confirmação', () {
      expect(
        RecurringPaymentBoleto.lastDigits(
          '00190.00009 01234.567890 12345.678901 8 99990000350000',
        ),
        '0000',
      );
    });
  });

  group('resultado do banco', () {
    test('lê o valor informado pelo contrato da execução', () {
      final result = RecurringPaymentPayResult.fromJson({
        'status': 'FAILED',
        'competence': '2026-10',
        'amount': 742.83,
        'providerValueInCents': 78243,
      });

      expect(result.outcome, RecurringPaymentPayOutcome.FAILED);
      expect(result.providerAmount, 782.43);
    });

    test('um estado desconhecido não vira "enviado"', () {
      final result = RecurringPaymentPayResult.fromJson({
        'status': 'QUEUED',
        'competence': '2026-10',
      });

      expect(result.outcome, isNull);
    });

    test('reconhece PAID como confirmação imediata', () {
      final result = RecurringPaymentPayResult.fromJson({
        'status': 'PAID',
        'competence': '2026-10',
      });
      expect(result.outcome, RecurringPaymentPayOutcome.PAID);
    });
  });

  group('simulação do boleto', () {
    test('preserva null e campos omitidos do contrato', () {
      final omitted = RecurringPaymentBillSimulation.fromJson({});
      expect(omitted.minimumScheduleDate, isNull);
      expect(omitted.feeInCents, isNull);
      expect(omitted.bankSlip, isNull);

      final explicitNull = RecurringPaymentBillSimulation.fromJson({
        'minimumScheduleDate': null,
        'feeInCents': null,
        'bankSlip': null,
      });
      expect(explicitNull.bankSlip, isNull);
    });

    test('mantém centavos e os campos opcionais retornados', () {
      final simulation = RecurringPaymentBillSimulation.fromJson({
        'minimumScheduleDate': '2026-10-17',
        'feeInCents': 250,
        'bankSlip': {
          'identificationField': 'normalized-line',
          'valueInCents': 74283,
          'beneficiaryName': null,
          'allowChangeValue': true,
        },
      });
      expect(simulation.feeInCents, 250);
      expect(simulation.bankSlip?.valueInCents, 74283);
      expect(simulation.bankSlip?.beneficiaryName, isNull);
      expect(simulation.bankSlip?.allowChangeValue, isTrue);
    });

    test(
      'a successful simulation is required and becomes pay authority',
      () async {
        final service = _ExecutionServiceStub(
          simulation: const RecurringPaymentBillSimulation(
            feeInCents: 10,
            bankSlip: RecurringPaymentBankSlip(
              identificationField: 'normalized-from-provider',
              valueInCents: 74283,
            ),
          ),
        );
        final store = RecurringPaymentExecutionStore(
          item: _item(json: const {'type': 'VARIABLE'}),
          hasBanking: true,
          service: service,
        );
        _selectAsaasAccount(store);
        store.setMethod(RecurringPaymentMethodType.BILL);
        store.setBoletoLine('raw-input');
        expect(store.state.isComplete, isFalse);

        final success = await store.simulateBill(
          const RecurringPaymentBillSimulationInput.identificationField(
            'raw-input',
          ),
          sourceValue: 'raw-input',
        );
        expect(success, isTrue);
        expect(store.state.isComplete, isTrue);
        expect(store.state.payPayload['amount'], 742.83);
        expect(
          (store.state.payPayload['payment'] as Map)['identificationField'],
          'normalized-from-provider',
        );
        expect(service.input?.toJson(), {'identificationField': 'raw-input'});
      },
    );

    test(
      'FIXED shows simulated amount and omits pay amount when values differ',
      () async {
        final service = _ExecutionServiceStub(
          simulation: const RecurringPaymentBillSimulation(
            bankSlip: RecurringPaymentBankSlip(
              identificationField: 'normalized-line',
              valueInCents: 101235,
            ),
          ),
        );
        final store = RecurringPaymentExecutionStore(
          item: _item(json: const {'type': 'FIXED', 'amount': 1000}),
          hasBanking: true,
          service: service,
        );
        _selectAsaasAccount(store);
        store.setMethod(RecurringPaymentMethodType.BILL);
        await store.simulateBill(
          const RecurringPaymentBillSimulationInput.barCode('barcode'),
          sourceValue: 'barcode',
        );
        expect(store.state.billSimulation?.bankSlip?.valueInCents, 101235);
        expect(store.state.isComplete, isTrue);
        expect(store.state.payPayload.containsKey('amount'), isFalse);
      },
    );

    test('editing the line and switching to PIX clear the snapshot', () async {
      final store = RecurringPaymentExecutionStore(
        item: _item(json: const {'type': 'FIXED', 'amount': 100}),
        hasBanking: true,
        service: _ExecutionServiceStub(
          simulation: const RecurringPaymentBillSimulation(
            bankSlip: RecurringPaymentBankSlip(
              identificationField: 'normalized-line',
            ),
          ),
        ),
      );
      store.setMethod(RecurringPaymentMethodType.BILL);
      await store.simulateBill(
        const RecurringPaymentBillSimulationInput.identificationField('old'),
        sourceValue: 'old',
      );
      store.setBoletoLine('new');
      expect(store.state.billSimulation, isNull);
      await store.simulateBill(
        const RecurringPaymentBillSimulationInput.identificationField('new'),
        sourceValue: 'new',
      );
      store.setMethod(RecurringPaymentMethodType.PIX_QR);
      expect(store.state.billSimulation, isNull);
    });

    test('422 is invalid and 503 stays retryable as unavailable', () async {
      for (final entry in [
        (422, RecurringPaymentBillSimulationError.invalid),
        (503, RecurringPaymentBillSimulationError.unavailable),
      ]) {
        final store = RecurringPaymentExecutionStore(
          item: _item(json: const {'type': 'FIXED', 'amount': 100}),
          hasBanking: true,
          service: _ExecutionServiceStub(
            error: DioException(
              requestOptions: RequestOptions(path: '/simulate'),
              response: Response(
                requestOptions: RequestOptions(path: '/simulate'),
                statusCode: entry.$1,
              ),
            ),
          ),
        );
        store.setMethod(RecurringPaymentMethodType.BILL);
        final success = await store.simulateBill(
          const RecurringPaymentBillSimulationInput.barCode('barcode'),
          sourceValue: 'barcode',
        );
        expect(success, isFalse);
        expect(store.state.billSimulationError, entry.$2);
        expect(store.state.isSimulatingBill, isFalse);
      }
    });

    test(
      'does not pay before simulation or duplicate an in-flight payment',
      () async {
        final payResult = RecurringPaymentPayResult.fromJson({
          'status': 'PROCESSING',
          'competence': '2026-10',
        });
        final service = _ExecutionServiceStub(
          simulation: const RecurringPaymentBillSimulation(
            bankSlip: RecurringPaymentBankSlip(
              identificationField: 'normalized-line',
              valueInCents: 74283,
            ),
          ),
          payResult: payResult,
          waitForPay: true,
        );
        final store = RecurringPaymentExecutionStore(
          item: _item(json: const {'type': 'VARIABLE'}),
          hasBanking: true,
          service: service,
        );
        _selectAsaasAccount(store);
        store.setMethod(RecurringPaymentMethodType.BILL);
        store.setBoletoLine('raw-line');
        expect(await store.submit(), isNull);
        expect(service.payCalls, 0);

        await store.simulateBill(
          const RecurringPaymentBillSimulationInput.identificationField(
            'raw-line',
          ),
          sourceValue: 'raw-line',
        );
        final first = store.submit();
        expect(await store.submit(), isNull);
        expect(service.payCalls, 1);
        service.completePay(payResult);
        expect((await first)?.outcome, RecurringPaymentPayOutcome.PROCESSING);
      },
    );
  });
}

class _ExecutionServiceStub extends RecurringPaymentExecutionService {
  _ExecutionServiceStub({
    this.simulation,
    this.decodedPixQr,
    this.error,
    this.payResult,
    this.waitForPay = false,
  });

  final RecurringPaymentBillSimulation? simulation;
  final RecurringPaymentPixQrData? decodedPixQr;
  final DioException? error;
  final RecurringPaymentPayResult? payResult;
  final bool waitForPay;
  final Completer<RecurringPaymentPayResult> _payCompleter = Completer();
  int payCalls = 0;
  RecurringPaymentBillSimulationInput? input;

  @override
  Future<RecurringPaymentPixQrData> decodePixQr(
    String recurringPaymentId,
    String availabilityAccountId,
    String payload,
  ) async => decodedPixQr!;

  void completePay(RecurringPaymentPayResult result) =>
      _payCompleter.complete(result);

  @override
  Future<RecurringPaymentBillSimulation> simulateBill(
    String recurringPaymentId,
    RecurringPaymentBillSimulationInput input,
  ) async {
    this.input = input;
    if (error != null) throw error!;
    return simulation!;
  }

  @override
  Future<RecurringPaymentPayResult> pay(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) {
    payCalls++;
    return waitForPay ? _payCompleter.future : Future.value(payResult!);
  }
}

const Map<String, dynamic> _pix = {
  'pixKey': '12345678000190',
  'pixKeyType': 'CNPJ',
};

RecurringPaymentCompetenceModel _item({
  required Map<String, dynamic> json,
  String status = 'PENDING',
}) {
  return RecurringPaymentCompetenceModel.fromJson({
    'recurringPaymentId': 'rp-1',
    'churchId': 'church-1',
    'name': 'Aluguel do templo',
    'financialConceptId': 'concept-1',
    'costCenterId': 'cc-1',
    'dayOfMonth': 10,
    'status': 'ACTIVE',
    'competence': '2026-10',
    'competenceStatus': status,
    ...json,
  });
}

RecurringPaymentExecutionState _state(
  Map<String, dynamic> config, {
  bool hasBanking = true,
  void Function(RecurringPaymentExecutionStore store)? setup,
}) {
  final store = RecurringPaymentExecutionStore(
    item: _item(json: config),
    hasBanking: hasBanking,
  );
  setup?.call(store);
  return store.state;
}

void _selectAsaasAccount(RecurringPaymentExecutionStore store) {
  store.setSource(
    const RecurringPaymentSourceUiModel(
      id: 'account-1',
      name: 'Conta Asaas',
      subtitle: 'Conta conectada',
      capability: RecurringPaymentSourceCapability.asaas,
      availabilityAccountId: 'account-1',
    ),
  );
}
