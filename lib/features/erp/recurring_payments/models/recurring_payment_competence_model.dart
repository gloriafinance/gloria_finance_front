import 'recurring_payment_competence_status.dart';
import 'recurring_payment_execution_model.dart';
import 'recurring_payment_model.dart';
import 'recurring_payment_month.dart';
import 'recurring_payment_settlement_model.dart';

/// Una fila de la vista mensual: la configuración de una recurrencia más su
/// estado **en la competencia consultada**.
///
/// La configuración se reutiliza tal cual ([RecurringPaymentModel]), así que el
/// parseo estricto de sus enums es uno solo.
class RecurringPaymentCompetenceModel {
  final RecurringPaymentModel configuration;
  final RecurringPaymentMonth month;
  final RecurringPaymentCompetenceStatus? status;
  final RecurringPaymentExecutionModel? execution;
  final RecurringPaymentSettlementModel? settlement;

  const RecurringPaymentCompetenceModel({
    required this.configuration,
    required this.month,
    required this.status,
    required this.execution,
    required this.settlement,
  });

  factory RecurringPaymentCompetenceModel.fromJson(Map<String, dynamic> json) {
    final rawExecution = json['currentPayment'];
    final rawSettlement = json['settlement'];

    return RecurringPaymentCompetenceModel(
      configuration: RecurringPaymentModel.fromJson(json),
      month:
          RecurringPaymentMonth.tryParse(json['competence'] as String?) ??
          RecurringPaymentMonth.current(),
      status: RecurringPaymentCompetenceStatusExtension.tryFromApiValue(
        json['competenceStatus'] as String?,
      ),
      execution:
          rawExecution is Map
              ? RecurringPaymentExecutionModel.fromJson(
                Map<String, dynamic>.from(rawExecution),
              )
              : null,
      settlement:
          rawSettlement is Map
              ? RecurringPaymentSettlementModel.fromJson(
                Map<String, dynamic>.from(rawSettlement),
              )
              : null,
    );
  }

  RecurringPaymentModel get recurringPayment => configuration;

  bool get isPaid => status?.isPaid ?? false;

  bool get isInFlight => status?.isInFlight ?? false;

  bool get isBlocked => status?.isBlocked ?? false;

  bool get isFailed => status?.isFailed ?? false;

  /// Solo PENDING/UPCOMING permiten ejecutar; un estado desconocido nunca
  /// habilita un pago.
  bool get canExecute => status?.canExecute ?? false;

  bool get canRetry => status?.canRetry ?? false;

  DateTime get dueDate => month.dueDate(configuration.dayOfMonth);

  /// PAGO histórico de una recurrencia ya desactivada: la competencia sigue
  /// pagada, pero la configuración no genera meses nuevos.
  bool get isPaidButInactive =>
      status == RecurringPaymentCompetenceStatus.PAID &&
      configuration.status == RecurringPaymentStatus.INACTIVE;

  /// Nombre del centro de costo se resuelve en la capa de opciones; acá se
  /// expone el id para no acoplar el modelo a la UI.
  String get id => configuration.recurringPaymentId;
}
