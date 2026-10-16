import '../models/recurring_payment_competence_model.dart';
import '../models/recurring_payment_execution_model.dart';
import '../models/recurring_payment_execution_payload.dart';
import '../models/recurring_payment_model.dart';
import '../models/recurring_payment_pay_result.dart';
import '../utils/recurring_payment_boleto.dart';

/// Casos de la matriz de ejecución, derivados de la configuración y de si la
/// iglesia tiene banca conectada.
enum RecurringPaymentExecutionCase {
  /// Sin Asaas: Glória no mueve dinero, solo registra el hecho.
  manualFixed,
  manualVariable,

  /// Con Asaas y destino PIX guardado: se confirma, no se vuelve a pedir nada.
  bankFixedWithDestination,

  /// Con Asaas y sin destino: el pagador elige PIX o boleto.
  bankFixedWithoutDestination,

  /// Con Asaas, valor variable y destino PIX guardado.
  bankVariableWithDestination,

  /// Con Asaas, valor variable y sin destino.
  bankVariableWithoutDestination,
}

extension RecurringPaymentExecutionCaseExtension
    on RecurringPaymentExecutionCase {
  bool get isManual =>
      this == RecurringPaymentExecutionCase.manualFixed ||
      this == RecurringPaymentExecutionCase.manualVariable;

  bool get hasSavedPixDestination =>
      this == RecurringPaymentExecutionCase.bankFixedWithDestination ||
      this == RecurringPaymentExecutionCase.bankVariableWithDestination;
}

/// Datos que el usuario informa **para esta ejecución**. Todo lo demás se hereda
/// de la configuración y se muestra como solo lectura.
class RecurringPaymentExecutionState {
  final RecurringPaymentCompetenceModel item;
  final bool hasBanking;
  final RecurringPaymentMethodType method;
  final String amountText;
  final String pixKey;
  final PixKeyType? pixKeyType;
  final String boletoLine;
  final bool makeRequest;
  final RecurringPaymentPayResult? result;

  const RecurringPaymentExecutionState({
    required this.item,
    required this.hasBanking,
    required this.method,
    required this.amountText,
    required this.pixKey,
    required this.pixKeyType,
    required this.boletoLine,
    required this.makeRequest,
    required this.result,
  });

  factory RecurringPaymentExecutionState.start(
    RecurringPaymentCompetenceModel item, {
    required bool hasBanking,
  }) {
    return RecurringPaymentExecutionState(
      item: item,
      hasBanking: hasBanking,
      // PIX viene preseleccionado: con destino guardado es el camino directo y
      // sin él sigue siendo la opción más usada; el usuario puede cambiarlo.
      method: RecurringPaymentMethodType.PIX,
      amountText: '',
      pixKey: '',
      pixKeyType: null,
      boletoLine: '',
      makeRequest: false,
      result: null,
    );
  }

  RecurringPaymentExecutionState copyWith({
    RecurringPaymentMethodType? method,
    String? amountText,
    String? pixKey,
    PixKeyType? pixKeyType,
    bool clearPixKeyType = false,
    String? boletoLine,
    bool? makeRequest,
    RecurringPaymentPayResult? result,
  }) {
    return RecurringPaymentExecutionState(
      item: item,
      hasBanking: hasBanking,
      method: method ?? this.method,
      amountText: amountText ?? this.amountText,
      pixKey: pixKey ?? this.pixKey,
      pixKeyType: clearPixKeyType ? null : (pixKeyType ?? this.pixKeyType),
      boletoLine: boletoLine ?? this.boletoLine,
      makeRequest: makeRequest ?? this.makeRequest,
      result: result ?? this.result,
    );
  }

  RecurringPaymentModel get payment => item.recurringPayment;

  bool get isVariable => payment.type == RecurringPaymentValueType.VARIABLE;

  bool get isFixed => payment.type == RecurringPaymentValueType.FIXED;

  bool get isPix => method == RecurringPaymentMethodType.PIX;

  bool get isLoading => makeRequest;

  RecurringPaymentExecutionCase get executionCase {
    if (!hasBanking) {
      return isVariable
          ? RecurringPaymentExecutionCase.manualVariable
          : RecurringPaymentExecutionCase.manualFixed;
    }
    if (isVariable) {
      return payment.hasPixDestination
          ? RecurringPaymentExecutionCase.bankVariableWithDestination
          : RecurringPaymentExecutionCase.bankVariableWithoutDestination;
    }
    return payment.hasPixDestination
        ? RecurringPaymentExecutionCase.bankFixedWithDestination
        : RecurringPaymentExecutionCase.bankFixedWithoutDestination;
  }

  /// Destino PIX guardado en la recurrencia (se muestra, no se vuelve a pedir).
  String? get savedPixKey => payment.pixDestination?.pixKey;

  PixKeyType? get savedPixKeyType => payment.pixDestination?.pixKeyType;

  /// Clave con la que se pagará: la guardada o la que el usuario informó.
  String get effectivePixKey => savedPixKey ?? pixKey.trim();

  PixKeyType? get effectivePixKeyType => savedPixKeyType ?? pixKeyType;

  double? get amount {
    if (isFixed) return payment.amount;

    final normalized = amountText.replaceAll(RegExp(r'[^\d]'), '');
    if (normalized.isEmpty) return null;

    // El campo usa el formateador de moneda del ERP (centavos al final).
    return double.parse(normalized) / 100;
  }

  /// El importe se pide solo cuando el pagador tiene que declararlo: un valor
  /// fijo pertenece a la configuración y un boleto trae el suyo de la línea.
  /// Whether the payer has to inform the amount.
  ///
  /// The instrument decides, not the recurrence type: a boleto defines the debt,
  /// so a variable recurrence paid with one never asks (and a fixed one is
  /// compared against the configuration as a protection). A PIX key identifies a
  /// recipient, not an amount, so a variable recurrence paid by key does ask.
  /// A PIX QR / copia e cola carrying its own amount joins [instrumentAmounts]
  /// without touching the recurrence.
  bool get requiresAmount {
    if (!isVariable) return false; // monto de la configuración
    if (!hasBanking) return true; // registro manual: lo informa el usuario
    return !instrumentAmounts;
  }

  /// Whether the chosen instrument brings the amount by itself.
  bool get instrumentAmounts => method == RecurringPaymentMethodType.BILL;

  /// Sin destino guardado, la clave PIX pertenece a esta ejecución.
  bool get requiresPixKey =>
      hasBanking && isPix && (savedPixKey == null || savedPixKey!.isEmpty);

  bool get requiresBoletoLine =>
      hasBanking && method == RecurringPaymentMethodType.BILL;

  /// El paso de valor/método solo responde por lo suyo: la chave PIX y la línea
  /// del boleto se piden en su propio paso, así que exigirlas acá dejaría al
  /// usuario sin forma de avanzar.
  bool get isAmountAndMethodComplete {
    if (requiresAmount && (amount == null || amount! <= 0)) return false;
    return true;
  }

  bool get isComplete {
    if (requiresAmount && (amount == null || amount! <= 0)) return false;
    if (requiresPixKey &&
        (pixKey.trim().isEmpty || effectivePixKeyType == null)) {
      return false;
    }
    if (requiresBoletoLine && !RecurringPaymentBoleto.isValid(boletoLine)) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> get payPayload => RecurringPaymentExecutionPayload.build(
    competence: item.month.competence,
    type: payment.type,
    amount: amount,
    method:
        isPix
            ? RecurringPaymentPayMethod.pix(
              pixKey: effectivePixKey,
              pixKeyType: effectivePixKeyType!,
            )
            : RecurringPaymentPayMethod.bill(
              identificationField: RecurringPaymentBoleto.onlyDigits(
                boletoLine,
              ),
            ),
  );

  /// Payload del registro manual: el importe solo viaja si es variable (en un
  /// fijo el dominio prohíbe enviarlo porque pertenece a la configuración).
  Map<String, dynamic> manualPayload({
    required String paymentDate,
    required String availabilityAccountId,
  }) {
    return {
      'competence': item.month.competence,
      if (isVariable && amount != null) 'amount': amount,
      'paymentDate': paymentDate,
      'availabilityAccountId': availabilityAccountId,
    };
  }
}
