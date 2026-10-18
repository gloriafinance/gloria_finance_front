import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/recurring_payment_competence_model.dart';
import '../models/recurring_payment_bill_simulation.dart';
import '../models/recurring_payment_execution_model.dart';
import '../models/recurring_payment_pay_result.dart';
import '../models/recurring_payment_source_ui_model.dart';
import '../service/recurring_payment_execution_service.dart';
import '../state/recurring_payment_execution_state.dart';
import '../utils/recurring_payment_boleto.dart';

/// Estado del flujo de ejecución de **una** competencia.
///
/// Solo guarda lo que el usuario informa para esa ejecución; todo lo demás sale
/// de la configuración (`state.item.recurringPayment`).
class RecurringPaymentExecutionStore extends ChangeNotifier {
  RecurringPaymentExecutionStore({
    required RecurringPaymentCompetenceModel item,
    required bool hasBanking,
    RecurringPaymentExecutionService? service,
  }) : service = service ?? RecurringPaymentExecutionService(),
       state = RecurringPaymentExecutionState.start(
         item,
         hasBanking: hasBanking,
       );

  final RecurringPaymentExecutionService service;

  RecurringPaymentExecutionState state;

  void setAvailabilityAccountId(String accountId) {
    state = state.copyWith(availabilityAccountId: accountId);
    notifyListeners();
  }

  void setSource(RecurringPaymentSourceUiModel source) {
    state = state.copyWith(
      source: source,
      availabilityAccountId: source.availabilityAccountId,
      method: RecurringPaymentMethodType.PIX_QR,
      boletoLine: '',
      clearBillSimulation: true,
      clearBillSimulationError: true,
      clearPixQrData: true,
      pixQrPayload: '',
      amountText: '',
    );
    notifyListeners();
  }

  void setMethod(RecurringPaymentMethodType method) {
    if (method == state.method) return;
    // Cambiar de método descarta la entrada del instrumento anterior.
    state = state.copyWith(
      method: method,
      amountText: '',
      boletoLine: '',
      clearBillSimulation: true,
      clearBillSimulationError: true,
      clearPixQrData: true,
      pixQrPayload: '',
    );
    notifyListeners();
  }

  void setAmountText(String value) {
    state = state.copyWith(amountText: value);
    notifyListeners();
  }

  Future<bool> decodePixQr(String payload) async {
    final availabilityAccountId = state.availabilityAccountId;
    if (availabilityAccountId == null || payload.isEmpty) return false;
    state = state.copyWith(
      isDecodingPixQr: true,
      clearPixQrData: true,
      pixQrPayload: '',
    );
    notifyListeners();
    try {
      final decoded = await service.decodePixQr(
        state.item.id,
        availabilityAccountId,
        payload,
      );
      state = state.copyWith(
        isDecodingPixQr: false,
        pixQrPayload: payload,
        pixQrData: decoded,
        amountText: decoded.amountInCents.toString(),
      );
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('ERROR decode recurring payment PIX QR: $error');
      state = state.copyWith(isDecodingPixQr: false);
      notifyListeners();
      return false;
    }
  }

  void setBoletoLine(String value) {
    state = state.copyWith(
      boletoLine: RecurringPaymentBoleto.onlyDigits(value),
      clearBillSimulation: true,
      clearBillSimulationError: true,
    );
    notifyListeners();
  }

  void clearBillSimulation() {
    state = state.copyWith(
      clearBillSimulation: true,
      clearBillSimulationError: true,
    );
    notifyListeners();
  }

  Future<bool> simulateBill(
    RecurringPaymentBillSimulationInput input, {
    required String sourceValue,
  }) async {
    if (state.isSimulatingBill || state.makeRequest || sourceValue.isEmpty) {
      return false;
    }

    state = state.copyWith(
      boletoLine: RecurringPaymentBoleto.onlyDigits(sourceValue),
      clearBillSimulation: true,
      clearBillSimulationError: true,
      isSimulatingBill: true,
    );
    notifyListeners();

    try {
      final simulation = await service.simulateBill(state.item.id, input);
      final usable =
          simulation.bankSlip?.identificationField?.isNotEmpty == true &&
          (!state.isVariable || (simulation.bankSlip?.valueInCents ?? 0) > 0);
      state = state.copyWith(
        isSimulatingBill: false,
        billSimulation: usable ? simulation : null,
        clearBillSimulation: !usable,
        billSimulationError:
            usable ? null : RecurringPaymentBillSimulationError.generic,
      );
      notifyListeners();
      return usable;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      state = state.copyWith(
        isSimulatingBill: false,
        billSimulationError:
            status == 400 || status == 422
                ? RecurringPaymentBillSimulationError.invalid
                : status == null || status >= 500
                ? RecurringPaymentBillSimulationError.unavailable
                : RecurringPaymentBillSimulationError.generic,
      );
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('ERROR simulate recurring payment bill: $e');
      state = state.copyWith(
        isSimulatingBill: false,
        billSimulationError: RecurringPaymentBillSimulationError.generic,
      );
      notifyListeners();
      return false;
    }
  }

  /// Envía la ejecución bancaria. Devuelve el resultado del banco o `null` si la
  /// llamada no llegó a responder.
  Future<RecurringPaymentPayResult?> submit() async {
    if (!state.isComplete || state.isSimulatingBill || state.makeRequest) {
      return null;
    }

    state = state.copyWith(makeRequest: true, result: null);
    notifyListeners();

    try {
      final result =
          state.isPixQr
              ? await service.payPixQr(state.item.id, state.payPayload)
              : await service.pay(state.item.id, state.payPayload);
      state = state.copyWith(makeRequest: false, result: result);
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('ERROR submit recurring payment: $e');
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return null;
    }
  }

  Future<RecurringPaymentPayResult?> reconcilePixQr() async {
    if (!state.isPixQr ||
        state.pixQrPayload.isEmpty ||
        state.makeRequest ||
        state.result?.outcome != RecurringPaymentPayOutcome.PROCESSING) {
      return null;
    }

    state = state.copyWith(makeRequest: true);
    notifyListeners();
    try {
      final result = await service.reconcilePixQr(
        state.item.id,
        competence: state.item.month.competence,
      );
      state = state.copyWith(makeRequest: false, result: result);
      notifyListeners();
      return result;
    } catch (error) {
      debugPrint('ERROR reconcile recurring payment PIX QR: $error');
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return null;
    }
  }

  /// Registra el pago hecho fuera de Glória. El comprovante es obligatorio.
  Future<bool> submitManual({
    required String paymentDate,
    required String availabilityAccountId,
    MultipartFile? voucher,
  }) async {
    if (!state.isComplete ||
        state.usesAsaas ||
        (state.requiresVoucher && voucher == null)) {
      return false;
    }

    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      await service.registerManually(
        recurringPaymentId: state.item.id,
        payload: state.manualPayload(
          paymentDate: paymentDate,
          availabilityAccountId: availabilityAccountId,
        ),
        voucher: voucher,
      );
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('ERROR register manual recurring payment: $e');
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
