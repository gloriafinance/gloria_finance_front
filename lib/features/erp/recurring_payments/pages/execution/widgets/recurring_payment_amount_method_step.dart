import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_execution_model.dart';
import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_execution_store.dart';
import 'recurring_payment_execution_field.dart';

/// Passo que reúne o que falta para esta execução: valor (quando o pagador
/// declara) e método (quando a configuração não decide sozinha).
///
/// Um valor FIXO nunca é pedido: vem da configuração e aparece como leitura.
class RecurringPaymentAmountMethodStep extends StatelessWidget {
  const RecurringPaymentAmountMethodStep({
    super.key,
    required this.onContinue,
    required this.symbolFormatMoney,
  });

  final VoidCallback onContinue;
  final String symbolFormatMoney;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentExecutionStore>();
    final state = store.state;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isFixed) ...[
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_field_value,
            value: CurrencyFormatter.formatCurrency(
              state.payment.amount ?? 0,
              symbol: symbolFormatMoney,
            ),
            note: l10n.recurringPaymentsExecution_value_from_configuration,
            emphasized: true,
          ),
          const SizedBox(height: 14),
        ],
        if (state.isVariable && state.isPix) ...[
          Input(
            label: l10n.recurringPaymentsExecution_amount_label,
            initialValue: state.amountText.isEmpty ? null : state.amountText,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyFormatter.getInputFormatters(symbolFormatMoney),
            ],
            icon: Icons.attach_money,
            onChanged: store.setAmountText,
          ),
          const SizedBox(height: 14),
        ],
        if (state.isVariable && !state.isPix) ...[
          RecurringPaymentExecutionNotice(
            text: l10n.recurringPaymentsExecution_amount_bill_note,
            icon: Icons.receipt_long,
            color: AppColors.blue,
          ),
          const SizedBox(height: 14),
        ],
        _MethodOption(
          icon: Icons.pix,
          label: l10n.recurringPaymentsExecution_method_pix,
          subtitle: l10n.recurringPaymentsExecution_method_pix_hint,
          selected: state.isPix,
          onTap: () => store.setMethod(RecurringPaymentMethodType.PIX),
        ),
        const SizedBox(height: 10),
        _MethodOption(
          icon: Icons.receipt_long,
          label: l10n.recurringPaymentsExecution_method_bill,
          subtitle: l10n.recurringPaymentsExecution_method_bill_hint,
          selected: !state.isPix,
          onTap: () => store.setMethod(RecurringPaymentMethodType.BILL),
        ),
        if (state.hasBanking && state.savedPixKey != null) ...[
          const SizedBox(height: 14),
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_pix_destination_label,
            value:
                '${state.savedPixKeyType?.apiValue ?? ''} · ${state.savedPixKey}',
            note: l10n.recurringPaymentsExecution_pix_destination_note,
          ),
        ],
        const SizedBox(height: 20),
        CustomButton(
          text: l10n.recurringPaymentsExecution_confirm_action,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.arrow_forward,
          onPressed: state.isAmountAndMethodComplete ? onContinue : null,
        ),
      ],
    );
  }
}

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppColors.purple.withValues(alpha: 0.06)
                  : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.purple : AppColors.greyMiddle,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.purple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? AppColors.purple : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              selected ? Icons.check_circle : Icons.chevron_right,
              size: 20,
              color: selected ? AppColors.purple : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
