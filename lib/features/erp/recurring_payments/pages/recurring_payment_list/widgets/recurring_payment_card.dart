import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_options_store.dart';
import '../../../utils/recurring_payment_lookup.dart';
import 'recurring_payment_actions_menu.dart';
import 'recurring_payment_pill.dart';
import 'recurring_payment_status_action.dart';
import 'recurring_payment_type_tag.dart';
import 'recurring_payment_value.dart';

/// Tarjeta de recurrencia (mobile, < 768 px).
///
/// Reemplaza la fila de tabla: metadatos rotulados, valor destacado y acciones de
/// ancho completo, sin scroll horizontal.
class RecurringPaymentCard extends StatelessWidget {
  const RecurringPaymentCard({
    super.key,
    required this.payment,
    required this.symbolFormatMoney,
  });

  final RecurringPaymentModel payment;
  final String symbolFormatMoney;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = context.watch<RecurringPaymentOptionsStore>().state;
    final concepts = options.expenseConcepts;
    final costCenters = options.costCenters;
    final isActive = payment.isActive;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0x80EEECEC),
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  payment.name,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RecurringPaymentPill(
                label:
                    payment.status?.friendlyName(l10n) ??
                    l10n.recurringPayments_status_unknown,
                color:
                    payment.status == null
                        ? AppColors.grey
                        : (isActive ? AppColors.green : Colors.red),
              ),
              RecurringPaymentActionsMenu(payment: payment),
            ],
          ),
          const SizedBox(height: 10),
          _MetaRow(
            label: l10n.recurringPayments_table_concept,
            value: financialConceptName(concepts, payment.financialConceptId),
          ),
          _MetaRow(
            label: l10n.recurringPayments_table_cost_center,
            value: costCenterName(costCenters, payment.costCenterId),
          ),
          _MetaRow(
            label: l10n.recurringPayments_table_due_day,
            value: l10n.recurringPayments_due_day(payment.dayOfMonth),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                RecurringPaymentTypeTag(type: payment.type),
                const Spacer(),
                RecurringPaymentValue(
                  payment: payment,
                  symbolFormatMoney: symbolFormatMoney,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child:
                payment.hasPixDestination
                    ? RecurringPaymentPill(
                      label: l10n.recurringPayments_pix_configured,
                      color: AppColors.blue,
                    )
                    : Text(
                      l10n.recurringPayments_pix_not_configured,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 12.5,
                        color: AppColors.grey,
                      ),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: ButtonActionTable(
                    color: AppColors.blue,
                    text: l10n.common_edit,
                    icon: Icons.edit_outlined,
                    onPressed: () => _goToEdit(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonActionTable(
                    color: isActive ? Colors.red : AppColors.green,
                    text:
                        isActive
                            ? l10n.recurringPayments_deactivate_action
                            : l10n.recurringPayments_activate_action,
                    icon: Icons.power_settings_new,
                    onPressed:
                        () => toggleRecurringPaymentStatus(context, payment),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToEdit(BuildContext context) {
    context.go(
      '/recurring-payments/edit/${payment.recurringPaymentId}',
      extra: payment,
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 11.5,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
