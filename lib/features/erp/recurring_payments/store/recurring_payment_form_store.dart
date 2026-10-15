import 'package:flutter/material.dart';

import '../models/recurring_payment_model.dart';
import '../service/recurring_payment_service.dart';
import '../state/recurring_payment_form_state.dart';

/// Estado del formulario de recurrencia (creación y edición).
class RecurringPaymentFormStore extends ChangeNotifier {
  RecurringPaymentFormStore({
    RecurringPaymentModel? recurringPayment,
    String? recurringPaymentId,
    required String symbolFormatMoney,
    RecurringPaymentService? service,
  }) : _recurringPaymentId =
           recurringPaymentId ?? recurringPayment?.recurringPaymentId ?? '',
       _symbolFormatMoney = symbolFormatMoney,
       service = service ?? RecurringPaymentService(),
       state =
           recurringPayment != null
               ? RecurringPaymentFormState.fromModel(
                 recurringPayment,
                 symbolFormatMoney: symbolFormatMoney,
               )
               : RecurringPaymentFormState.init(
                 symbolFormatMoney: symbolFormatMoney,
               );

  final RecurringPaymentService service;
  final String _recurringPaymentId;
  final String _symbolFormatMoney;

  RecurringPaymentFormState state;

  /// Hidrata el formulario cuando la pantalla se abrió solo con el id (deep link).
  /// En modo edición con objeto en memoria, o en creación, no hace nada.
  Future<void> initialize() async {
    if (state.isEdit || _recurringPaymentId.isEmpty) return;

    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final payments = await service.searchRecurringPayments();
      final found = _findById(payments);

      state =
          found != null
              ? RecurringPaymentFormState.fromModel(
                found,
                symbolFormatMoney: _symbolFormatMoney,
              )
              : state.copyWith(makeRequest: false);
    } catch (e) {
      debugPrint('ERROR initialize: $e');
      state = state.copyWith(makeRequest: false);
    }

    notifyListeners();
  }

  void setName(String value) {
    state = state.copyWith(name: value.trim());
    notifyListeners();
  }

  void setFinancialConceptId(String? value) {
    state = state.copyWith(financialConceptId: value);
    notifyListeners();
  }

  void setCostCenterId(String? value) {
    state = state.copyWith(costCenterId: value);
    notifyListeners();
  }

  /// Cambiar a "Valor variável" limpia el valor permanente, porque el dominio
  /// prohíbe `amount` en `VARIABLE`.
  void setType(RecurringPaymentValueType type) {
    state = state.copyWith(
      type: type,
      clearAmount: type == RecurringPaymentValueType.VARIABLE,
    );
    notifyListeners();
  }

  void setAmount(double amount, String amountText) {
    state = state.copyWith(amount: amount, amountText: amountText);
    notifyListeners();
  }

  void setDayOfMonth(int? dayOfMonth) {
    state = state.copyWith(dayOfMonth: dayOfMonth);
    notifyListeners();
  }

  void setStatus(RecurringPaymentStatus status) {
    state = state.copyWith(status: status);
    notifyListeners();
  }

  void setPixEnabled(bool enabled) {
    state = state.copyWith(pixEnabled: enabled);
    notifyListeners();
  }

  void setPixKey(String value) {
    state = state.copyWith(pixKey: value.trim());
    notifyListeners();
  }

  /// Trocar o tipo da chave limpa o valor digitado: a máscara e o formato são
  /// específicos do tipo, então um CPF não pode continuar em um campo de CNPJ.
  void setPixKeyType(PixKeyType value) {
    state = state.copyWith(pixKeyType: value, pixKey: '');
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!state.isComplete) {
      debugPrint('ERROR submit: incomplete recurring payment configuration');
      return false;
    }

    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final payload = state.toConfigurationJson();

      if (state.isEdit) {
        await service.updateRecurringPayment(state.recurringPaymentId, payload);
      } else {
        await service.createRecurringPayment(payload);
      }

      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('ERROR submitRecurringPayment: $e');
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  RecurringPaymentModel? _findById(List<RecurringPaymentModel> payments) {
    for (final payment in payments) {
      if (payment.recurringPaymentId == _recurringPaymentId) {
        return payment;
      }
    }
    return null;
  }
}
