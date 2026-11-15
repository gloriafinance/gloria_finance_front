import 'package:gloria_finance/l10n/app_localizations.dart';

/// Estado de una recurrencia **dentro de una competencia** (un mes).
///
/// Lo calcula el backend (`ListRecurringPayments.competenceStatus`) y esta capa
/// solo lo interpreta: el histórico manda sobre la configuración, así que una
/// competencia pagada sigue siendo PAID aunque la recurrencia se haya
/// desactivado después.
enum RecurringPaymentCompetenceStatus {
  PENDING,
  UPCOMING,
  PROCESSING,
  BLOCKED,
  FAILED,
  PAID,
  INACTIVE,
}

extension RecurringPaymentCompetenceStatusExtension
    on RecurringPaymentCompetenceStatus {
  String get apiValue => toString().split('.').last;

  /// `null` cuando el valor no pertenece al contrato: se muestra como estado
  /// desconocido en lugar de asumir "Pendente" y habilitar un pago que quizá no
  /// corresponda.
  static RecurringPaymentCompetenceStatus? tryFromApiValue(String? value) {
    for (final element in RecurringPaymentCompetenceStatus.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }

  String friendlyName(AppLocalizations l10n) {
    switch (this) {
      case RecurringPaymentCompetenceStatus.PENDING:
        return l10n.recurringPaymentsExecution_status_pending;
      case RecurringPaymentCompetenceStatus.UPCOMING:
        return l10n.recurringPaymentsExecution_status_upcoming;
      case RecurringPaymentCompetenceStatus.PROCESSING:
        return l10n.recurringPaymentsExecution_status_processing;
      case RecurringPaymentCompetenceStatus.BLOCKED:
        return l10n.recurringPaymentsExecution_status_blocked;
      case RecurringPaymentCompetenceStatus.FAILED:
        return l10n.recurringPaymentsExecution_status_failed;
      case RecurringPaymentCompetenceStatus.PAID:
        return l10n.recurringPaymentsExecution_status_paid;
      case RecurringPaymentCompetenceStatus.INACTIVE:
        return l10n.recurringPaymentsExecution_status_inactive;
    }
  }

  bool get isPaid => this == RecurringPaymentCompetenceStatus.PAID;

  /// Hay una operación bancaria viva: no se inicia otra.
  bool get isInFlight => this == RecurringPaymentCompetenceStatus.PROCESSING;

  /// BLOCKED es **no terminal**: el banco sigue resolviendo. No se reintenta ni
  /// se crea una segunda operación; solo se consulta el estado.
  bool get isBlocked => this == RecurringPaymentCompetenceStatus.BLOCKED;

  /// FAILED sí es terminal para ese intento: el siguiente es una ejecución nueva.
  bool get isFailed => this == RecurringPaymentCompetenceStatus.FAILED;

  /// PENDING y UPCOMING son los únicos que permiten ejecutar el pago.
  bool get canExecute =>
      this == RecurringPaymentCompetenceStatus.PENDING ||
      this == RecurringPaymentCompetenceStatus.UPCOMING;

  /// Solo un intento fallido puede repetirse.
  bool get canRetry => isFailed;

  /// El estado no permite ninguna acción de pago.
  bool get isClosed =>
      this == RecurringPaymentCompetenceStatus.PAID ||
      this == RecurringPaymentCompetenceStatus.INACTIVE;
}
