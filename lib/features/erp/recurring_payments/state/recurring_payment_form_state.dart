import 'package:gloria_finance/core/utils/currency_formatter.dart';

import '../models/recurring_payment_model.dart';

/// Estado del formulario de creación/edición de una recurrencia.
class RecurringPaymentFormState {
  final bool makeRequest;

  /// Vacío en modo creación; completo en modo edición.
  final String recurringPaymentId;

  final String name;
  final String? financialConceptId;
  final String? costCenterId;
  final RecurringPaymentValueType type;
  final double? amount;

  /// Texto mostrado en el campo de valor (el input tiene máscara).
  final String amountText;

  final int? dayOfMonth;
  final RecurringPaymentStatus status;

  /// Sección PIX reutilizable: nace apagada y es totalmente opcional.
  final bool pixEnabled;
  final String pixKey;
  final PixKeyType pixKeyType;

  final String symbolFormatMoney;

  const RecurringPaymentFormState({
    required this.makeRequest,
    required this.recurringPaymentId,
    required this.name,
    required this.financialConceptId,
    required this.costCenterId,
    required this.type,
    required this.amount,
    required this.amountText,
    required this.dayOfMonth,
    required this.status,
    required this.pixEnabled,
    required this.pixKey,
    required this.pixKeyType,
    required this.symbolFormatMoney,
  });

  factory RecurringPaymentFormState.init({required String symbolFormatMoney}) {
    return RecurringPaymentFormState(
      makeRequest: false,
      recurringPaymentId: '',
      name: '',
      financialConceptId: null,
      costCenterId: null,
      type: RecurringPaymentValueType.FIXED,
      amount: null,
      amountText: '',
      dayOfMonth: null,
      status: RecurringPaymentStatus.ACTIVE,
      pixEnabled: false,
      pixKey: '',
      pixKeyType: PixKeyType.CNPJ,
      symbolFormatMoney: symbolFormatMoney,
    );
  }

  factory RecurringPaymentFormState.fromModel(
    RecurringPaymentModel model, {
    required String symbolFormatMoney,
  }) {
    final amount = model.amount;

    return RecurringPaymentFormState(
      makeRequest: false,
      recurringPaymentId: model.recurringPaymentId,
      name: model.name,
      financialConceptId: model.financialConceptId,
      costCenterId: model.costCenterId,
      type: model.type,
      amount: amount,
      amountText:
          amount == null
              ? ''
              : CurrencyFormatter.formatCurrency(
                amount,
                symbol: symbolFormatMoney,
              ),
      dayOfMonth: model.dayOfMonth,
      status: model.status,
      pixEnabled: model.hasPixDestination,
      pixKey: model.pixDestination?.pixKey ?? '',
      pixKeyType: model.pixDestination?.pixKeyType ?? PixKeyType.CNPJ,
      symbolFormatMoney: symbolFormatMoney,
    );
  }

  RecurringPaymentFormState copyWith({
    bool? makeRequest,
    String? recurringPaymentId,
    String? name,
    String? financialConceptId,
    String? costCenterId,
    RecurringPaymentValueType? type,
    double? amount,
    String? amountText,
    bool clearAmount = false,
    int? dayOfMonth,
    RecurringPaymentStatus? status,
    bool? pixEnabled,
    String? pixKey,
    PixKeyType? pixKeyType,
  }) {
    return RecurringPaymentFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
      name: name ?? this.name,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      costCenterId: costCenterId ?? this.costCenterId,
      type: type ?? this.type,
      amount: clearAmount ? null : (amount ?? this.amount),
      amountText: clearAmount ? '' : (amountText ?? this.amountText),
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      status: status ?? this.status,
      pixEnabled: pixEnabled ?? this.pixEnabled,
      pixKey: pixKey ?? this.pixKey,
      pixKeyType: pixKeyType ?? this.pixKeyType,
      symbolFormatMoney: symbolFormatMoney,
    );
  }

  bool get isLoading => makeRequest;

  bool get isEdit => recurringPaymentId.isNotEmpty;

  bool get isFixed => type == RecurringPaymentValueType.FIXED;

  /// Refleja las invariantes del agregado para no dejar guardar un payload que la
  /// API rechazaría (valor fijo obligatorio, clave PIX obligatoria si está activa).
  bool get isComplete {
    if (name.trim().isEmpty) return false;
    if (financialConceptId == null || costCenterId == null) return false;
    if (dayOfMonth == null) return false;
    if (isFixed && (amount == null || amount! <= 0)) return false;
    if (pixEnabled && pixKey.trim().isEmpty) return false;
    return true;
  }

  Map<String, dynamic> toConfigurationJson() {
    return RecurringPaymentConfigurationPayload.build(
      name: name.trim(),
      financialConceptId: financialConceptId ?? '',
      costCenterId: costCenterId ?? '',
      type: type,
      amount: amount,
      dayOfMonth: dayOfMonth ?? 0,
      status: status,
      pixDestination:
          pixEnabled && pixKey.trim().isNotEmpty
              ? RecurringPixDestination(
                pixKey: pixKey.trim(),
                pixKeyType: pixKeyType,
              )
              : null,
    );
  }
}
