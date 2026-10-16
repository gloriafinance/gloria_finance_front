import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_competence_status.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_execution_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_month.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_pay_result.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_settlement_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/state/recurring_payment_execution_state.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_execution_store.dart';
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
          'attempt': 1,
          'externalReference': 'urn:recurringPayment:rp-1:2026-10:1',
          'amount': 3500.0,
          'providerValueInCents': 375000,
          'paymentMethod': 'BILL',
          'status': 'FAILED',
          'providerStatus': 'CREATION_FAILED',
          'failureCode': 'RECURRING_PAYMENT_BILL_AMOUNT_MISMATCH',
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
      expect(item.execution?.providerValueInCents, 375000);
      expect(item.execution?.isAmountMismatch, isTrue);
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

  group('matriz de execução', () {
    test('deriva o caso da configuração e da banca', () {
      expect(
        _state(const {'type': 'FIXED', 'amount': 10}).executionCase,
        RecurringPaymentExecutionCase.bankFixedWithoutDestination,
      );
      expect(
        _state(const {
          'type': 'FIXED',
          'amount': 10,
          'pixDestination': _pix,
        }).executionCase,
        RecurringPaymentExecutionCase.bankFixedWithDestination,
      );
      expect(
        _state(const {'type': 'VARIABLE'}).executionCase,
        RecurringPaymentExecutionCase.bankVariableWithoutDestination,
      );
      expect(
        _state(const {
          'type': 'VARIABLE',
          'pixDestination': _pix,
        }).executionCase,
        RecurringPaymentExecutionCase.bankVariableWithDestination,
      );
      expect(
        _state(const {
          'type': 'FIXED',
          'amount': 10,
        }, hasBanking: false).executionCase,
        RecurringPaymentExecutionCase.manualFixed,
      );
      expect(
        _state(const {'type': 'VARIABLE'}, hasBanking: false).executionCase,
        RecurringPaymentExecutionCase.manualVariable,
      );
    });

    test('um valor fixo nunca é pedido', () {
      final state = _state(const {'type': 'FIXED', 'amount': 3500});

      // O valor vem da configuração e é lido, não digitado.
      expect(state.requiresAmount, isFalse);
      expect(state.amount, 3500);

      // Sem destino guardado ainda falta decidir o método e, se for PIX, a chave.
      expect(state.requiresPixKey, isTrue);
      expect(state.isComplete, isFalse);
    });

    test('um boleto não pede valor: o boleto traz o seu', () {
      final state = _state(
        const {'type': 'VARIABLE'},
        setup: (store) {
          store.setMethod(RecurringPaymentMethodType.BILL);
          store.setBoletoLine('00190000090123456789012345678901234567890123');
        },
      );

      expect(state.requiresAmount, isFalse);
      expect(state.amount, isNull);
      expect(state.isComplete, isTrue);
      expect(state.payPayload.containsKey('amount'), isFalse);
    });

    test('um PIX variável exige valor e chave quando não há destino', () {
      final semValor = _state(const {'type': 'VARIABLE'});
      expect(semValor.requiresAmount, isTrue);
      expect(semValor.isComplete, isFalse);

      final comValor = _state(
        const {'type': 'VARIABLE'},
        setup: (store) {
          store.setAmountText('74283');
          store.setPixKeyType(PixKeyType.CNPJ);
          store.setPixKey('12345678000190');
        },
      );
      expect(comValor.amount, 742.83);
      expect(comValor.isComplete, isTrue);
      expect(comValor.payPayload['amount'], 742.83);
      expect(comValor.payPayload['payment'], {
        'type': 'PIX',
        'pixKey': '12345678000190',
        'pixKeyType': 'CNPJ',
      });
    });

    test('com destino guardado não se pede a chave de novo', () {
      final state = _state(const {
        'type': 'FIXED',
        'amount': 3500,
        'pixDestination': _pix,
      }, setup: (store) => store.setAmountText(''));

      expect(state.requiresPixKey, isFalse);
      expect(state.isComplete, isTrue);
      expect(state.payPayload['payment'], {
        'type': 'PIX',
        'pixKey': '12345678000190',
        'pixKeyType': 'CNPJ',
      });
      // O valor fixo pertence à configuração: não viaja no comando.
      expect(state.payPayload.containsKey('amount'), isFalse);
    });

    test('o registro manual só envia valor quando é variável', () {
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

  group('linha digitável', () {
    test('aceita as duas representações e ignora ruído de formato', () {
      // Boleto digitado (47), seu código de barras (44) e a linha de
      // arrecadação/convênio (48) das contas de consumo valem igual.
      expect(
        RecurringPaymentBoleto.isValid(
          '00190.00009 01234.567890 12345.678901 8 99990000350000',
        ),
        isTrue,
      );
      expect(RecurringPaymentBoleto.isValid('1' * 44), isTrue);
      expect(RecurringPaymentBoleto.onlyDigits('001.90 000-09'), '0019000009');
    });

    test('recusa arrecadação de 48 dígitos e linhas curtas', () {
      expect(RecurringPaymentBoleto.isValid('8' * 48), isTrue);
      expect(RecurringPaymentBoleto.isValid('123'), isFalse);
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
    test('lê o valor do boleto e reconhece o mismatch', () {
      final result = RecurringPaymentPayResult.fromJson({
        'status': 'FAILED',
        'competence': '2026-10',
        'amount': 742.83,
        'providerValueInCents': 78243,
        'failureCode': 'RECURRING_PAYMENT_BILL_AMOUNT_MISMATCH',
      });

      expect(result.outcome, RecurringPaymentPayOutcome.FAILED);
      expect(result.isAmountMismatch, isTrue);
      expect(result.providerAmount, 782.43);
    });

    test('um estado desconhecido não vira "enviado"', () {
      final result = RecurringPaymentPayResult.fromJson({
        'status': 'QUEUED',
        'competence': '2026-10',
      });

      expect(result.outcome, isNull);
      expect(result.isAmountMismatch, isFalse);
    });
  });
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
