import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
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
  });

  final VoidCallback onConfirm;
  final String symbolFormatMoney;

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
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_field_method,
            value: l10n.recurringPaymentsExecution_method_bill,
          ),
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_boleto_line_final,
            value:
                '•••• ${RecurringPaymentBoleto.lastDigits(state.boletoLine)}',
          ),
          if (state.isFixed)
            RecurringPaymentExecutionField(
              label: l10n.recurringPaymentsExecution_boleto_expected_value,
              value: CurrencyFormatter.formatCurrency(
                state.payment.amount ?? 0,
                symbol: symbolFormatMoney,
              ),
              emphasized: true,
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
          onPressed: state.isLoading ? null : onConfirm,
        ),
      ],
    );
  }
}
