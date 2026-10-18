import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import '../models/recurring_payment_filter_model.dart';
import '../models/recurring_payment_model.dart';
import '../service/recurring_payment_service.dart';
import '../state/recurring_payment_list_state.dart';

/// Estado de la listado de recurrencias.
///
/// La lista es pequeña y de configuración, así que se carga de una vez y se
/// filtra localmente; por eso el filtro aplicado vive aquí y no en una query
/// remota.
class RecurringPaymentListStore extends ChangeNotifier {
  RecurringPaymentListStore({RecurringPaymentService? service})
    : service = service ?? RecurringPaymentService();

  final RecurringPaymentService service;

  RecurringPaymentListState state = RecurringPaymentListState.empty();

  /// `true` cuando hay que volver a pedir: no hay datos o son de otra iglesia.
  ///
  /// Los stores viven en `StoreManager`, así que sobreviven a un logout. Sin esta
  /// comprobación, entrar con otra iglesia mostraba los pagos de la anterior.
  Future<bool> needsLoad({String? churchId}) async {
    if (state.isLoading) return false;

    final currentChurchId = churchId ?? await _sessionChurchId();
    if (!state.hasPayments) return true;
    return state.loadedChurchId != currentChurchId;
  }

  Future<void> searchRecurringPayments({String? churchId}) async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final currentChurchId = churchId ?? await _sessionChurchId();
      final payments = await service.searchRecurringPayments();
      state = state.copyWith(
        makeRequest: false,
        payments: payments,
        loadedChurchId: currentChurchId,
      );
    } catch (e) {
      debugPrint('ERROR searchRecurringPayments: $e');
      state = state.copyWith(makeRequest: false);
    }

    notifyListeners();
  }

  Future<String> _sessionChurchId() async {
    final session = await AuthPersistence().restore();
    return session.churchId;
  }

  void setSearchTerm(String value) {
    state = state.copyWith(filters: state.filters.copyWith(searchTerm: value));
    notifyListeners();
  }

  void setStatusFilter(RecurringPaymentStatus? status) {
    state = state.copyWith(
      filters:
          status == null
              ? state.filters.copyWith(clearStatus: true)
              : state.filters.copyWith(status: status),
    );
    notifyListeners();
  }

  void setTypeFilter(RecurringPaymentValueType? type) {
    state = state.copyWith(
      filters:
          type == null
              ? state.filters.copyWith(clearType: true)
              : state.filters.copyWith(type: type),
    );
    notifyListeners();
  }

  void applyFilters() {
    state = state.copyWith(appliedFilters: state.filters);
    notifyListeners();
  }

  void clearFilters() {
    state = state.copyWith(
      filters: RecurringPaymentFilterModel.empty(),
      appliedFilters: RecurringPaymentFilterModel.empty(),
    );
    notifyListeners();
  }

  /// Activa/desactiva una recurrencia.
  ///
  /// Desactivar es el ciclo de vida de la configuración (la API no expone borrado).
  /// Después de guardar, la lista se recarga para reflejar la verdad del servidor.
  Future<bool> toggleStatus(RecurringPaymentModel payment) async {
    final currentStatus = payment.status;

    // Sin un estado reconocido no se inventa el contrario: el botón ni siquiera
    // se ofrece en la fila, y aquí queda el seguro.
    if (currentStatus == null) return false;

    try {
      final updated = payment.copyWith(status: currentStatus.flipped);

      await service.updateRecurringPayment(
        payment.recurringPaymentId,
        updated.toConfigurationJson(),
      );

      await searchRecurringPayments();
      return true;
    } catch (e) {
      debugPrint('ERROR toggleStatus: $e');
      return false;
    }
  }
}
