import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/recurring_payment_competence_model.dart';
import '../models/recurring_payment_execution_model.dart';
import '../models/recurring_payment_model.dart';
import '../models/recurring_payment_pay_result.dart';
import '../service/recurring_payment_execution_service.dart';
import '../state/recurring_payment_execution_state.dart';

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

  void setMethod(RecurringPaymentMethodType method) {
    if (method == state.method) return;
    // Cambiar de método descarta lo que era propio del anterior (la clave PIX o
    // la línea del boleto) para no enviar datos que ya no aplican.
    state = state.copyWith(
      method: method,
      pixKey: '',
      clearPixKeyType: true,
      boletoLine: '',
    );
    notifyListeners();
  }

  void setAmountText(String value) {
    state = state.copyWith(amountText: value);
    notifyListeners();
  }

  void setPixKey(String value) {
    state = state.copyWith(pixKey: value);
    notifyListeners();
  }

  void setPixKeyType(PixKeyType value) {
    state = state.copyWith(pixKeyType: value, pixKey: '');
    notifyListeners();
  }

  void setBoletoLine(String value) {
    state = state.copyWith(boletoLine: value);
    notifyListeners();
  }

  /// Envía la ejecución bancaria. Devuelve el resultado del banco o `null` si la
  /// llamada no llegó a responder.
  Future<RecurringPaymentPayResult?> submit() async {
    if (!state.isComplete) return null;

    state = state.copyWith(makeRequest: true, result: null);
    notifyListeners();

    try {
      final result = await service.pay(state.item.id, state.payPayload);
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

  /// Registra el pago hecho fuera de Glória. El comprovante es obligatorio.
  Future<bool> submitManual({
    required String paymentDate,
    required String availabilityAccountId,
    required MultipartFile voucher,
  }) async {
    if (!state.isComplete) return false;

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
