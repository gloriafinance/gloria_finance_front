import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:go_router/go_router.dart';

import '../../../models/recurring_payment_model.dart';
import 'recurring_payment_actions_menu.dart';
import 'recurring_payment_status_action.dart';

/// Acciones de una fila de la tabla.
class RecurringPaymentRowActions extends StatelessWidget {
  const RecurringPaymentRowActions({super.key, required this.payment});

  final RecurringPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final status = payment.status;
    final l10n = context.l10n;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: l10n.common_edit,
          icon: Icons.edit_outlined,
          onPressed: () => _goToEdit(context),
        ),
        // Estado fuera del contrato conocido: activar/desactivar enviaría un
        // valor inventado, así que la acción no se ofrece.
        if (status != null)
          ButtonActionTable(
            color: status.isActive ? Colors.red : AppColors.green,
            text:
                status.isActive
                    ? l10n.recurringPayments_deactivate_action
                    : l10n.recurringPayments_activate_action,
            icon: Icons.power_settings_new,
            onPressed: () => toggleRecurringPaymentStatus(context, payment),
          ),
        RecurringPaymentActionsMenu(payment: payment),
      ],
    );
  }

  void _goToEdit(BuildContext context) {
    context.go(
      '/recurring-payments/edit/${payment.recurringPaymentId}',
      extra: payment,
    );
  }
}
