import 'recurring_payment_model.dart';

/// Filtros de la listado de recurrencias.
///
/// Vive en `models/` porque es un contrato de lectura puro y testeable: la pantalla
/// solo dibuja el resultado de [matches].
class RecurringPaymentFilterModel {
  final String searchTerm;
  final RecurringPaymentStatus? status;
  final RecurringPaymentValueType? type;

  const RecurringPaymentFilterModel({
    this.searchTerm = '',
    this.status,
    this.type,
  });

  factory RecurringPaymentFilterModel.empty() {
    return const RecurringPaymentFilterModel();
  }

  bool get isEmpty =>
      searchTerm.trim().isEmpty && status == null && type == null;

  bool get isNotEmpty => !isEmpty;

  RecurringPaymentFilterModel copyWith({
    String? searchTerm,
    RecurringPaymentStatus? status,
    RecurringPaymentValueType? type,
    bool clearStatus = false,
    bool clearType = false,
  }) {
    return RecurringPaymentFilterModel(
      searchTerm: searchTerm ?? this.searchTerm,
      status: clearStatus ? null : (status ?? this.status),
      type: clearType ? null : (type ?? this.type),
    );
  }

  bool matches(RecurringPaymentModel payment) {
    final normalizedTerm = searchTerm.trim().toLowerCase();
    if (normalizedTerm.isNotEmpty &&
        !payment.name.toLowerCase().contains(normalizedTerm)) {
      return false;
    }

    if (status != null && payment.status != status) {
      return false;
    }

    if (type != null && payment.type != type) {
      return false;
    }

    return true;
  }
}
