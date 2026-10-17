import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import 'package:gloria_finance/features/erp/financial_records/finance_record_service.dart';

import '../models/recurring_payment_month.dart';
import '../service/recurring_payment_execution_service.dart';
import '../state/recurring_payment_monthly_state.dart';

/// Lista de compromisos de una competencia y las operaciones del mes.
class RecurringPaymentMonthlyStore extends ChangeNotifier {
  RecurringPaymentMonthlyStore({
    RecurringPaymentMonth? month,
    RecurringPaymentExecutionService? service,
    FinanceRecordService? financeRecordService,
  }) : service = service ?? RecurringPaymentExecutionService(),
       financeRecordService = financeRecordService ?? FinanceRecordService(),
       state = RecurringPaymentMonthlyState.empty(
         month: month ?? RecurringPaymentMonth.current(),
       );

  final RecurringPaymentExecutionService service;

  /// Cancelar un registro manual es una operación del asiento contable, no de la
  /// recurrencia: por eso se reutiliza el servicio de financial records.
  final FinanceRecordService financeRecordService;

  RecurringPaymentMonthlyState state;

  /// `true` cuando hay que pedir de nuevo: no hay datos, son de otra iglesia o
  /// son de otro mes. Los stores viven en `StoreManager`, así que sobreviven al
  /// logout y al cambio de competencia.
  Future<bool> needsLoad({String? churchId}) async {
    if (state.isLoading) return false;

    if (!state.hasItems) return true;

    final currentChurchId = churchId ?? await _sessionChurchId();
    return state.loadedChurchId != currentChurchId ||
        state.loadedCompetence != state.month.competence;
  }

  Future<void> load({String? churchId, bool force = false}) async {
    if (!force && !await needsLoad(churchId: churchId)) return;

    final competence = state.month.competence;
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final currentChurchId = churchId ?? await _sessionChurchId();
      final items = await service.listCompetence(competence);

      state = state.copyWith(
        makeRequest: false,
        items: items,
        loadedChurchId: currentChurchId,
        loadedCompetence: competence,
      );
    } catch (e) {
      debugPrint('ERROR load recurring payments month: $e');
      state = state.copyWith(makeRequest: false);
    }

    notifyListeners();
  }

  void selectMonth(RecurringPaymentMonth month) {
    if (month.competence == state.month.competence) return;
    state = state.copyWith(month: month, items: const []);
    notifyListeners();
  }

  void previousMonth() => selectMonth(
    RecurringPaymentMonth(
      year: state.month.year,
      month: state.month.month,
    ).previous,
  );

  void nextMonth() => selectMonth(
    RecurringPaymentMonth(
      year: state.month.year,
      month: state.month.month,
    ).next,
  );

  /// Anula el asiento manual y vuelve a leer el mes: la competencia queda
  /// PENDING otra vez porque el histórico sale del asiento, no de la
  /// configuración.
  Future<bool> cancelRecord(String financialRecordId) async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await financeRecordService.cancelFinanceRecord(financialRecordId);
      await load(force: true);
      return true;
    } catch (e) {
      debugPrint('ERROR cancel recurring payment record: $e');
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  Future<String> _sessionChurchId() async {
    final session = await AuthPersistence().restore();
    return session.churchId;
  }
}
