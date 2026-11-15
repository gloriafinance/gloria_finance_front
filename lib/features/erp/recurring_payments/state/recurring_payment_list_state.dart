import '../models/recurring_payment_filter_model.dart';
import '../models/recurring_payment_model.dart';

/// Estado de la listado de pagos recurrentes.
///
/// Mantiene dos filtros: [filters] es lo que el usuario arma en la barra y
/// [appliedFilters] es lo que la lista está mostrando realmente. Esa separación
/// preserva el patrón "Aplicar filtros" ya usado en el ERP.
class RecurringPaymentListState {
  final bool makeRequest;
  final List<RecurringPaymentModel> payments;
  final RecurringPaymentFilterModel filters;
  final RecurringPaymentFilterModel appliedFilters;

  /// Iglesia de la que se cargaron [payments]. Si cambia la sesión (otra iglesia
  /// entra sin reiniciar la app), los datos dejan de ser válidos.
  final String? loadedChurchId;

  const RecurringPaymentListState({
    required this.makeRequest,
    required this.payments,
    required this.filters,
    required this.appliedFilters,
    required this.loadedChurchId,
  });

  factory RecurringPaymentListState.empty() {
    return RecurringPaymentListState(
      makeRequest: false,
      payments: const [],
      filters: RecurringPaymentFilterModel.empty(),
      appliedFilters: RecurringPaymentFilterModel.empty(),
      loadedChurchId: null,
    );
  }

  RecurringPaymentListState copyWith({
    bool? makeRequest,
    List<RecurringPaymentModel>? payments,
    RecurringPaymentFilterModel? filters,
    RecurringPaymentFilterModel? appliedFilters,
    String? loadedChurchId,
  }) {
    return RecurringPaymentListState(
      makeRequest: makeRequest ?? this.makeRequest,
      payments: payments ?? this.payments,
      filters: filters ?? this.filters,
      appliedFilters: appliedFilters ?? this.appliedFilters,
      loadedChurchId: loadedChurchId ?? this.loadedChurchId,
    );
  }

  bool get isLoading => makeRequest;

  bool get hasPayments => payments.isNotEmpty;

  List<RecurringPaymentModel> get visiblePayments =>
      payments.where(appliedFilters.matches).toList();

  int get totalCount => payments.length;

  int get activeCount => payments.where((payment) => payment.isActive).length;

  int get inactiveCount => totalCount - activeCount;

  /// Suma de los compromisos fijos activos. Es la única cifra de la pantalla y existe para
  /// responder "cuánto está comprometido por mes" en la configuración.
  double get activeFixedMonthlyTotal {
    return payments
        .where((payment) => payment.isActive && payment.isFixed)
        .fold<double>(0, (total, payment) => total + (payment.amount ?? 0));
  }

  /// La lista está vacía porque no existe ninguna recurrencia registrada.
  bool get isEmpty => !hasPayments;

  /// Existen recurrencias, pero los filtros aplicados no devuelven ninguna.
  bool get isFilteredWithoutResults =>
      hasPayments && visiblePayments.isEmpty && appliedFilters.isNotEmpty;
}
