import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';

import '../../../models/recurring_payment_competence_status.dart';
import '../../../models/recurring_payment_execution_model.dart';
import '../../recurring_payment_list/widgets/recurring_payment_pill.dart';

/// Estado da competência com cor própria.
///
/// As cores distinguem o que exige ação (pendente/a vencer), o que está com o
/// banco (processando/bloqueado), o que falhou e o histórico (pago/inativo).
class RecurringPaymentStatusChip extends StatelessWidget {
  const RecurringPaymentStatusChip({
    super.key,
    required this.status,
    required this.label,
    this.executionStatus,
  });

  final RecurringPaymentCompetenceStatus? status;
  final String label;

  /// Quando a competência tem uma execução, o estado bancário dela manda na cor:
  /// `competenceStatus` e `currentPayment.status` descrevem a mesma operação.
  final RecurringPaymentExecutionStatus? executionStatus;

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(status, executionStatus);

    return RecurringPaymentPill(label: label, color: color);
  }

  static Color _colorOf(
    RecurringPaymentCompetenceStatus? status,
    RecurringPaymentExecutionStatus? execution,
  ) {
    switch (execution) {
      case RecurringPaymentExecutionStatus.PROCESSING:
        return AppColors.blue;
      case RecurringPaymentExecutionStatus.BLOCKED:
        return AppColors.mustard;
      case RecurringPaymentExecutionStatus.FAILED:
        return Colors.red;
      case RecurringPaymentExecutionStatus.PAID:
        return AppColors.green;
      case null:
        break;
    }

    switch (status) {
      case RecurringPaymentCompetenceStatus.PENDING:
        return AppColors.purple;
      case RecurringPaymentCompetenceStatus.UPCOMING:
        return AppColors.blue;
      case RecurringPaymentCompetenceStatus.PROCESSING:
        return AppColors.blue;
      case RecurringPaymentCompetenceStatus.BLOCKED:
        return AppColors.mustard;
      case RecurringPaymentCompetenceStatus.FAILED:
        return Colors.red;
      case RecurringPaymentCompetenceStatus.PAID:
        return AppColors.green;
      case RecurringPaymentCompetenceStatus.INACTIVE:
      case null:
        return AppColors.grey;
    }
  }
}
