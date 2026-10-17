import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../models/recurring_payment_bill_simulation.dart';
import '../../../store/recurring_payment_execution_store.dart';
import '../../../utils/recurring_payment_boleto.dart';
import 'recurring_payment_execution_field.dart';

/// Confirmação final. **Não** é um formulário: só revisa o que já se sabe.
///
/// PIX mostra o destino herdado (quando existe); boleto mostra a linha final e
/// explica que o valor vem do próprio boleto.
class RecurringPaymentConfirmationStep extends StatelessWidget {
  const RecurringPaymentConfirmationStep({
    super.key,
    required this.onConfirm,
    required this.symbolFormatMoney,
    this.onEditBoleto,
  });

  final VoidCallback onConfirm;
  final String symbolFormatMoney;
  final VoidCallback? onEditBoleto;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentExecutionStore>();
    final state = store.state;
    final l10n = context.l10n;
    final isPix = state.isPix;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RecurringPaymentExecutionField(
          label: l10n.recurringPaymentsExecution_period_label,
          value: state.item.month.slashLabel,
        ),
        if (isPix) ...[
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_field_value,
            value: CurrencyFormatter.formatCurrency(
              state.amount ?? 0,
              symbol: symbolFormatMoney,
            ),
            emphasized: true,
          ),
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_pix_destination_label,
            value:
                '${state.effectivePixKeyType?.apiValue ?? ''} · '
                '${state.effectivePixKey}',
            note:
                state.savedPixKey != null
                    ? l10n.recurringPaymentsExecution_pix_destination_note
                    : null,
          ),
        ] else ...[
          ..._billReviewFields(
            context,
            state.billSimulation!,
            symbolFormatMoney,
          ),
          if (onEditBoleto != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onEditBoleto,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: Text(l10n.recurringPaymentsExecution_boleto_edit),
              ),
            ),
          if (state.isFixed &&
              state.billSimulation!.bankSlip?.valueInCents != null)
            RecurringPaymentExecutionField(
              label: l10n.recurringPaymentsExecution_boleto_configured_value,
              value: CurrencyFormatter.formatCurrency(
                state.payment.amount ?? 0,
                symbol: symbolFormatMoney,
              ),
            ),
          if (state.isFixed &&
              state.payment.amount != null &&
              state.billSimulation!.bankSlip?.valueInCents != null &&
              (state.payment.amount! * 100).round() !=
                  state.billSimulation!.bankSlip!.valueInCents)
            RecurringPaymentExecutionNotice(
              text:
                  l10n.recurringPaymentsExecution_boleto_configured_difference,
              icon: Icons.info_outline,
              color: AppColors.mustard,
            ),
          if (state.billSimulation!.bankSlip?.isOverdue == true)
            RecurringPaymentExecutionNotice(
              text: l10n.recurringPaymentsExecution_boleto_overdue,
              icon: Icons.warning_amber_outlined,
              color: Colors.red,
            ),
        ],
        RecurringPaymentExecutionField(
          label: l10n.recurringPaymentsExecution_account_label,
          value: l10n.recurringPaymentsExecution_account_asaas,
        ),
        const SizedBox(height: 12),
        RecurringPaymentExecutionNotice(
          text:
              isPix
                  ? l10n.recurringPaymentsExecution_pix_send_note
                  : l10n.recurringPaymentsExecution_boleto_send_note,
          icon: Icons.verified_user_outlined,
          color: AppColors.blue,
        ),
        if (isPix) ...[
          const SizedBox(height: 10),
          RecurringPaymentExecutionNotice(
            text: l10n.recurringPaymentsExecution_pix_review_note,
          ),
        ],
        const SizedBox(height: 20),
        CustomButton(
          text:
              isPix
                  ? l10n.recurringPaymentsExecution_pix_confirm_action
                  : l10n.recurringPaymentsExecution_boleto_pay_action,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.check,
          onPressed: !state.isComplete || state.isLoading ? null : onConfirm,
        ),
      ],
    );
  }
}

List<Widget> _billReviewFields(
  BuildContext context,
  RecurringPaymentBillSimulation simulation,
  String symbolFormatMoney,
) {
  final l10n = context.l10n;
  final bill = simulation.bankSlip!;

  Widget? money(String label, int? cents, {bool emphasized = false}) {
    if (cents == null) return null;
    return RecurringPaymentExecutionField(
      label: label,
      value: CurrencyFormatter.formatCurrency(
        cents / 100,
        symbol: symbolFormatMoney,
      ),
      emphasized: emphasized,
      dense: true,
    );
  }

  return [
    if (bill.beneficiaryName != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_beneficiary,
        value: bill.beneficiaryName!,
        emphasized: true,
      ),
    if (bill.beneficiaryCpfCnpj != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_beneficiary_document,
        value: bill.beneficiaryCpfCnpj!,
        dense: true,
      ),
    if (bill.valueInCents != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_value,
        value: CurrencyFormatter.formatCurrency(
          bill.valueInCents! / 100,
          symbol: symbolFormatMoney,
        ),
        emphasized: true,
      ),
    if (bill.originalValueInCents != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_original_value,
        value: CurrencyFormatter.formatCurrency(
          bill.originalValueInCents! / 100,
          symbol: symbolFormatMoney,
        ),
        dense: true,
      ),
    if (bill.dueDate != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_due_date_label,
        value: bill.dueDate!.split('-').reversed.join('/'),
      ),
    if (simulation.feeInCents != null)
      money(l10n.recurringPaymentsExecution_boleto_fee, simulation.feeInCents)!,
    if (bill.discountValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_discount,
        bill.discountValueInCents,
      )!,
    if (bill.interestValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_interest,
        bill.interestValueInCents,
      )!,
    if (bill.fineValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_fine,
        bill.fineValueInCents,
      )!,
    if (bill.totalDiscountValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_total_discount,
        bill.totalDiscountValueInCents,
      )!,
    if (bill.totalAdditionalValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_total_additional,
        bill.totalAdditionalValueInCents,
      )!,
    if (bill.bank != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_bank,
        value: bill.bank!,
        dense: true,
      ),
    if (bill.isOverdue == false)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_status,
        value: l10n.recurringPaymentsExecution_boleto_not_overdue,
        dense: true,
      ),
    if (bill.allowChangeValue != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_value_change,
        value:
            bill.allowChangeValue!
                ? l10n.recurringPaymentsExecution_boleto_value_change_allowed
                : l10n
                    .recurringPaymentsExecution_boleto_value_change_not_allowed,
        dense: true,
      ),
    if (bill.minValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_min_value,
        bill.minValueInCents,
      )!,
    if (bill.maxValueInCents != null)
      money(
        l10n.recurringPaymentsExecution_boleto_max_value,
        bill.maxValueInCents,
      )!,
    if (simulation.minimumScheduleDate != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_minimum_date,
        value: simulation.minimumScheduleDate!.split('-').reversed.join('/'),
        dense: true,
      ),
    RecurringPaymentExecutionField(
      label: l10n.recurringPaymentsExecution_boleto_line_final,
      value:
          '•••• ${RecurringPaymentBoleto.lastDigits(bill.identificationField!)}',
      dense: true,
    ),
  ];
}
