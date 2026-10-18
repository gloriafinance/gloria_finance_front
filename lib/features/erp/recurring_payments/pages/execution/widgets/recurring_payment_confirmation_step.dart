import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_bill_simulation.dart';
import '../../../store/recurring_payment_execution_store.dart';
import '../../../utils/recurring_payment_boleto.dart';
import 'recurring_payment_execution_field.dart';

/// Confirmação final. **Não** é um formulário: só revisa o que já se sabe.
///
/// PIX QR e boleto mostram los datos de la simulación antes de confirmar.
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
            label: l10n.recurringPaymentsExecution_qr_amount_label,
            value: CurrencyFormatter.formatCurrency(
              state.pixQrData!.amountInCents / 100,
              symbol: symbolFormatMoney,
            ),
            emphasized: true,
          ),
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_pix_destination_label,
            value: l10n.recurringPaymentsExecution_instrument_qr,
          ),
          if (state.isFixed)
            RecurringPaymentExecutionField(
              label: l10n.recurringPaymentsExecution_boleto_configured_value,
              value: CurrencyFormatter.formatCurrency(
                state.payment.amount ?? 0,
                symbol: symbolFormatMoney,
              ),
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
                style: TextButton.styleFrom(foregroundColor: AppColors.green),
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
        ],
        RecurringPaymentExecutionField(
          label: l10n.recurringPaymentsExecution_account_label,
          value: state.source!.name,
        ),
        const SizedBox(height: 12),
        RecurringPaymentExecutionNotice(
          text:
              isPix
                  ? l10n.recurringPaymentsExecution_pix_send_note
                  : l10n.recurringPaymentsExecution_boleto_send_note,
          icon: Icons.verified_user_outlined,
          color: AppColors.grey,
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
          disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
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

  String dateLabel(String value) => value.split('-').reversed.join('/');

  Widget moneyMetric(String label, int cents) => SizedBox(
    width: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 11.5,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          CurrencyFormatter.formatCurrency(
            cents / 100,
            symbol: symbolFormatMoney,
          ),
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13.5,
            color: Color(0xFF242126),
          ),
        ),
      ],
    ),
  );

  final details = <Widget>[
    if (bill.bank != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_bank,
        value: bill.bank!,
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
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_min_value,
        value: CurrencyFormatter.formatCurrency(
          bill.minValueInCents! / 100,
          symbol: symbolFormatMoney,
        ),
        dense: true,
      ),
    if (bill.maxValueInCents != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_max_value,
        value: CurrencyFormatter.formatCurrency(
          bill.maxValueInCents! / 100,
          symbol: symbolFormatMoney,
        ),
        dense: true,
      ),
    if (simulation.minimumScheduleDate != null)
      RecurringPaymentExecutionField(
        label: l10n.recurringPaymentsExecution_boleto_minimum_date,
        value: dateLabel(simulation.minimumScheduleDate!),
        dense: true,
      ),
    RecurringPaymentExecutionField(
      label: l10n.recurringPaymentsExecution_boleto_line_final,
      value:
          '•••• ${RecurringPaymentBoleto.lastDigits(bill.identificationField!)}',
      dense: true,
    ),
  ];

  return [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E6E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bill.beneficiaryName != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recurringPaymentsExecution_boleto_beneficiary,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 11.5,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bill.beneficiaryName!,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          if (bill.beneficiaryCpfCnpj != null) ...[
            const SizedBox(height: 2),
            Text(
              '${l10n.recurringPaymentsExecution_boleto_beneficiary_document}: '
              '${bill.beneficiaryCpfCnpj}',
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 11.5,
                color: AppColors.grey,
              ),
            ),
          ],
          if (bill.beneficiaryName != null || bill.beneficiaryCpfCnpj != null)
            const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (bill.valueInCents != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recurringPaymentsExecution_boleto_value,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 11.5,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.formatCurrency(
                          bill.valueInCents! / 100,
                          symbol: symbolFormatMoney,
                        ),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 23,
                          color: Color(0xFF242126),
                        ),
                      ),
                    ],
                  ),
                ),
              if (bill.dueDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.recurringPaymentsExecution_due_date_label,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 11.5,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateLabel(bill.dueDate!),
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
    if ([
      bill.originalValueInCents,
      simulation.feeInCents,
      bill.discountValueInCents,
      bill.interestValueInCents,
      bill.fineValueInCents,
      bill.totalDiscountValueInCents,
      bill.totalAdditionalValueInCents,
    ].any((value) => value != null))
      Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F6F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E6E9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.recurringPaymentsExecution_boleto_charges_section,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 13,
                color: Color(0xFF39353B),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (bill.originalValueInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_original_value,
                    bill.originalValueInCents!,
                  ),
                if (simulation.feeInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_fee,
                    simulation.feeInCents!,
                  ),
                if (bill.discountValueInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_discount,
                    bill.discountValueInCents!,
                  ),
                if (bill.interestValueInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_interest,
                    bill.interestValueInCents!,
                  ),
                if (bill.fineValueInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_fine,
                    bill.fineValueInCents!,
                  ),
                if (bill.totalDiscountValueInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_total_discount,
                    bill.totalDiscountValueInCents!,
                  ),
                if (bill.totalAdditionalValueInCents != null)
                  moneyMetric(
                    l10n.recurringPaymentsExecution_boleto_total_additional,
                    bill.totalAdditionalValueInCents!,
                  ),
              ],
            ),
          ],
        ),
      ),
    if (bill.isOverdue == true)
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: RecurringPaymentExecutionNotice(
          text: l10n.recurringPaymentsExecution_boleto_overdue,
          icon: Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      ),
    if (details.isNotEmpty)
      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Material(
          color: Colors.transparent,
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 8),
            title: Text(
              l10n.recurringPaymentsExecution_boleto_more_details,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12.5,
                color: AppColors.purple,
              ),
            ),
            children: details,
          ),
        ),
      ),
  ];
}
