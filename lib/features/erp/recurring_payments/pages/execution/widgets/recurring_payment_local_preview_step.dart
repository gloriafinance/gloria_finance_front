import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

import 'recurring_payment_execution_field.dart';

/// Revisión previa con los datos reales recibidos por la API.
class RecurringPaymentLocalPreviewStep extends StatelessWidget {
  const RecurringPaymentLocalPreviewStep({
    super.key,
    required this.isPixQr,
    required this.expectedAmount,
    required this.actualAmount,
    required this.variable,
    required this.sourceName,
    required this.recurrenceName,
    required this.competence,
    required this.symbolFormatMoney,
    required this.onConfirm,
    required this.onReview,
  });

  final bool isPixQr;
  final double? expectedAmount;
  final double? actualAmount;
  final bool variable;
  final String sourceName;
  final String recurrenceName;
  final String competence;
  final String symbolFormatMoney;
  final VoidCallback onConfirm;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String currency(double value) =>
        CurrencyFormatter.formatCurrency(value, symbol: symbolFormatMoney);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RecurringPaymentExecutionField(
          label: l10n.recurringPaymentsExecution_period_label,
          value: '$recurrenceName · $competence',
        ),
        Text(
          isPixQr
              ? l10n.recurringPaymentsExecution_instrument_qr
              : l10n.recurringPaymentsExecution_instrument_boleto,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 12),
        RecurringPaymentExecutionField(
          label:
              isPixQr
                  ? l10n.recurringPaymentsExecution_qr_amount_label
                  : l10n.recurringPaymentsExecution_boleto_value,
          value:
              actualAmount == null
                  ? l10n.recurringPaymentsExecution_amount_required
                  : currency(actualAmount!),
          emphasized: true,
        ),
        if (!variable && expectedAmount != null)
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_boleto_configured_value,
            value: currency(expectedAmount!),
          ),
        RecurringPaymentExecutionField(
          label: l10n.recurringPaymentsExecution_account_label,
          value: sourceName,
        ),
        const SizedBox(height: 12),
        const SizedBox(height: 16),
        CustomButton(
          text: l10n.recurringPaymentsExecution_confirm_action,
          backgroundColor: AppColors.green,
          disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
          textColor: Colors.black,
          icon: Icons.check,
          onPressed: onConfirm,
        ),
        TextButton(
          onPressed: onReview,
          style: TextButton.styleFrom(foregroundColor: AppColors.green),
          child: Text(
            isPixQr
                ? l10n.recurringPaymentsExecution_qr_paste
                : l10n.recurringPaymentsExecution_boleto_edit,
          ),
        ),
      ],
    );
  }
}
