import '../models/recurring_payment_competence_model.dart';
import '../models/recurring_payment_bill_simulation.dart';
import '../models/recurring_payment_execution_model.dart';
import '../models/recurring_payment_execution_payload.dart';
import '../models/recurring_payment_model.dart';
import '../models/recurring_payment_pay_result.dart';
import '../models/recurring_payment_source_ui_model.dart';
import '../models/recurring_payment_pix_qr_data.dart';

/// Datos que el usuario informa **para esta ejecución**. Todo lo demás se hereda
/// de la configuración y se muestra como solo lectura.
class RecurringPaymentExecutionState {
  final RecurringPaymentCompetenceModel item;
  final bool hasBanking;
  final RecurringPaymentSourceUiModel? source;
  final RecurringPaymentPixQrData? pixQrData;
  final String pixQrPayload;
  final bool isDecodingPixQr;
  final String? availabilityAccountId;
  final RecurringPaymentMethodType method;
  final String amountText;
  final String boletoLine;
  final RecurringPaymentBillSimulation? billSimulation;
  final bool isSimulatingBill;
  final RecurringPaymentBillSimulationError? billSimulationError;
  final bool makeRequest;
  final RecurringPaymentPayResult? result;

  const RecurringPaymentExecutionState({
    required this.item,
    required this.hasBanking,
    required this.source,
    required this.pixQrData,
    required this.pixQrPayload,
    required this.isDecodingPixQr,
    required this.availabilityAccountId,
    required this.method,
    required this.amountText,
    required this.boletoLine,
    required this.billSimulation,
    required this.isSimulatingBill,
    required this.billSimulationError,
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
      source: null,
      pixQrData: null,
      pixQrPayload: '',
      isDecodingPixQr: false,
      availabilityAccountId: null,
      // PIX QR is the first instrument shown for a bank execution.
      method: RecurringPaymentMethodType.PIX_QR,
      amountText: '',
      boletoLine: '',
      billSimulation: null,
      isSimulatingBill: false,
      billSimulationError: null,
      makeRequest: false,
      result: null,
    );
  }

  RecurringPaymentExecutionState copyWith({
    RecurringPaymentSourceUiModel? source,
    bool clearSource = false,
    RecurringPaymentPixQrData? pixQrData,
    bool clearPixQrData = false,
    String? pixQrPayload,
    bool? isDecodingPixQr,
    String? availabilityAccountId,
    RecurringPaymentMethodType? method,
    String? amountText,
    String? boletoLine,
    RecurringPaymentBillSimulation? billSimulation,
    bool clearBillSimulation = false,
    bool? isSimulatingBill,
    RecurringPaymentBillSimulationError? billSimulationError,
    bool clearBillSimulationError = false,
    bool? makeRequest,
    RecurringPaymentPayResult? result,
  }) {
    return RecurringPaymentExecutionState(
      item: item,
      hasBanking: hasBanking,
      source: clearSource ? null : (source ?? this.source),
      pixQrData: clearPixQrData ? null : (pixQrData ?? this.pixQrData),
      pixQrPayload: pixQrPayload ?? this.pixQrPayload,
      isDecodingPixQr: isDecodingPixQr ?? this.isDecodingPixQr,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      method: method ?? this.method,
      amountText: amountText ?? this.amountText,
      boletoLine: boletoLine ?? this.boletoLine,
      billSimulation:
          clearBillSimulation ? null : (billSimulation ?? this.billSimulation),
      isSimulatingBill: isSimulatingBill ?? this.isSimulatingBill,
      billSimulationError:
          clearBillSimulationError
              ? null
              : (billSimulationError ?? this.billSimulationError),
      makeRequest: makeRequest ?? this.makeRequest,
      result: result ?? this.result,
    );
  }

  RecurringPaymentModel get payment => item.recurringPayment;

  bool get isVariable => payment.type == RecurringPaymentValueType.VARIABLE;

  bool get usesAsaas => source?.isAsaas ?? false;

  bool get requiresVoucher => source?.requiresVoucher ?? false;

  bool get isFixed => payment.type == RecurringPaymentValueType.FIXED;

  bool get isPix =>
      method == RecurringPaymentMethodType.PIX ||
      method == RecurringPaymentMethodType.PIX_QR;

  bool get isPixQr => method == RecurringPaymentMethodType.PIX_QR;

  bool get isLoading => makeRequest;

  double? get amount {
    if (isFixed) return payment.amount;
    if (isPixQr && pixQrData != null) return pixQrData!.amountInCents / 100;

    final normalized = amountText.replaceAll(RegExp(r'[^\d]'), '');
    if (normalized.isEmpty) return null;

    // El campo usa el formateador de moneda del ERP (centavos al final).
    return double.parse(normalized) / 100;
  }

  /// Manual VARIABLE uses the entered amount; bank amounts come from the
  /// selected instrument and FIXED uses its configured amount.
  bool get requiresAmount {
    if (!isVariable) return false; // monto de la configuración
    if (!usesAsaas) return true; // registro manual: lo informa el usuario
    return !instrumentAmounts;
  }

  /// Whether the chosen instrument supplies the amount after simulation.
  bool get instrumentAmounts =>
      method == RecurringPaymentMethodType.BILL || isPixQr;

  bool get requiresBoletoLine =>
      usesAsaas && method == RecurringPaymentMethodType.BILL;

  bool get isAmountAndMethodComplete {
    if (requiresAmount && (amount == null || amount! <= 0)) return false;
    return true;
  }

  bool get isComplete {
    if (source == null) return false;
    if (requiresAmount && (amount == null || amount! <= 0)) return false;
    if (!usesAsaas) return availabilityAccountId != null;
    if (availabilityAccountId == null) return false;
    if (isPixQr && (pixQrData == null || pixQrPayload.isEmpty)) return false;
    if (requiresBoletoLine &&
        billSimulation?.bankSlip?.identificationField?.isNotEmpty != true) {
      return false;
    }
    if (requiresBoletoLine &&
        isVariable &&
        (billSimulation?.bankSlip?.valueInCents == null ||
            billSimulation!.bankSlip!.valueInCents! <= 0)) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> get payPayload => RecurringPaymentExecutionPayload.build(
    competence: item.month.competence,
    type: payment.type,
    amount:
        isPixQr
            ? null
            : isVariable && method == RecurringPaymentMethodType.BILL
            ? (billSimulation?.bankSlip?.valueInCents ?? 0) / 100
            : amount,
    method:
        isPixQr
            ? RecurringPaymentPayMethod.pixQr(payload: pixQrPayload)
            : RecurringPaymentPayMethod.bill(
              identificationField:
                  billSimulation!.bankSlip!.identificationField!,
            ),
    availabilityAccountId: availabilityAccountId,
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
