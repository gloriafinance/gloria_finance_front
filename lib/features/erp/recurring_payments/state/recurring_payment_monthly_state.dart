import '../models/recurring_payment_competence_model.dart';
import '../models/recurring_payment_competence_status.dart';
import '../models/recurring_payment_model.dart';
import '../models/recurring_payment_month.dart';

/// Estado de la vista mensual: una competencia y sus compromisos.
class RecurringPaymentMonthlyState {
  final bool makeRequest;
  final RecurringPaymentMonth month;
  final List<RecurringPaymentCompetenceModel> items;

  /// Iglesia y competencia de los datos cargados: si cambia cualquiera de las
  /// dos, lo que hay en memoria deja de ser válido.
  final String? loadedChurchId;
  final String? loadedCompetence;

  const RecurringPaymentMonthlyState({
    required this.makeRequest,
    required this.month,
    required this.items,
    required this.loadedChurchId,
    required this.loadedCompetence,
  });

  factory RecurringPaymentMonthlyState.empty({
    required RecurringPaymentMonth month,
  }) {
    return RecurringPaymentMonthlyState(
      makeRequest: false,
      month: month,
      items: const [],
      loadedChurchId: null,
      loadedCompetence: null,
    );
  }

  RecurringPaymentMonthlyState copyWith({
    bool? makeRequest,
    RecurringPaymentMonth? month,
    List<RecurringPaymentCompetenceModel>? items,
    String? loadedChurchId,
    String? loadedCompetence,
  }) {
    return RecurringPaymentMonthlyState(
      makeRequest: makeRequest ?? this.makeRequest,
      month: month ?? this.month,
      items: items ?? this.items,
      loadedChurchId: loadedChurchId ?? this.loadedChurchId,
      loadedCompetence: loadedCompetence ?? this.loadedCompetence,
    );
  }

  bool get isLoading => makeRequest;

  bool get hasItems => items.isNotEmpty;

  int get pendingCount => items.where((item) => item.canExecute).length;

  int get paidCount => items.where((item) => item.isPaid).length;

  /// Compromisos pendientes con valor variable: su importe solo se conoce al
  /// pagar, así que no puede sumarse de antemano.
  int get variablePendingCount =>
      items
          .where(
            (item) =>
                item.canExecute &&
                item.recurringPayment.type ==
                    RecurringPaymentValueType.VARIABLE,
          )
          .length;

  /// Total **solo** de los pendientes con valor fijo.
  double get fixedPendingTotal => items
      .where((item) => item.canExecute)
      .map((item) => item.recurringPayment.amount ?? 0)
      .fold(0, (total, amount) => total + amount);

  /// Operación viva en el mes: mientras exista, no se inicia otra.
  RecurringPaymentCompetenceModel? get inFlight {
    for (final item in items) {
      if (item.status == RecurringPaymentCompetenceStatus.PROCESSING) {
        return item;
      }
    }
    return null;
  }
}
