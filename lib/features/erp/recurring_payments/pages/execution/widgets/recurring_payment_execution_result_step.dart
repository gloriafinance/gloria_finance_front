import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

import '../../../models/recurring_payment_execution_model.dart';
import '../../../models/recurring_payment_pay_result.dart';
import 'recurring_payment_execution_field.dart';

/// Resultado da execução bancária.
///
/// Apresenta o estado devolvido pela API sem inferir confirmação bancária.
class RecurringPaymentExecutionResultStep extends StatelessWidget {
  const RecurringPaymentExecutionResultStep({
    super.key,
    required this.result,
    required this.method,
    required this.symbolFormatMoney,
    required this.onClose,
    required this.onRetry,
    required this.onCheckStatus,
    required this.isCheckingStatus,
  });

  final RecurringPaymentPayResult result;
  final RecurringPaymentMethodType method;
  final String symbolFormatMoney;
  final VoidCallback onClose;
  final VoidCallback onRetry;
  final VoidCallback onCheckStatus;
  final bool isCheckingStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outcome = result.outcome;

    if (outcome == RecurringPaymentPayOutcome.ALREADY_PAID) {
      return _block(
        context,
        icon: Icons.check_circle_outline,
        color: AppColors.green,
        title: l10n.recurringPaymentsExecution_paid_title,
        description: l10n.recurringPaymentsExecution_already_paid,
        onClose: onClose,
      );
    }

    if (outcome == RecurringPaymentPayOutcome.PAID) {
      return _block(
        context,
        icon: Icons.check_circle_outline,
        color: AppColors.green,
        title: l10n.recurringPaymentsExecution_paid_title,
        description: l10n.recurringPaymentsExecution_paid_confirmed,
        onClose: onClose,
      );
    }

    if (outcome == RecurringPaymentPayOutcome.BLOCKED) {
      return _block(
        context,
        icon: Icons.pause_circle_outline,
        color: AppColors.mustard,
        title:
            method == RecurringPaymentMethodType.PIX_QR
                ? l10n.recurringPaymentsExecution_status_unknown
                : l10n.recurringPaymentsExecution_blocked_title,
        description:
            method == RecurringPaymentMethodType.PIX_QR
                ? l10n.recurringPaymentsExecution_pixQr_unknown
                : l10n.recurringPaymentsExecution_blocked_description,
        onClose: onClose,
      );
    }

    if (outcome == RecurringPaymentPayOutcome.FAILED) {
      return _block(
        context,
        icon: Icons.error_outline,
        color: Colors.red,
        title: l10n.recurringPaymentsExecution_failed_title,
        description: l10n.recurringPaymentsExecution_failed_description,
        onClose: onClose,
        primary: CustomButton(
          text: l10n.recurringPaymentsExecution_failed_retry,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.refresh,
          onPressed: onRetry,
        ),
      );
    }

    if (outcome == null) {
      // Estado que este cliente não conhece: informa sem inventar significado.
      return _block(
        context,
        icon: Icons.help_outline,
        color: AppColors.grey,
        title: l10n.recurringPaymentsExecution_status_unknown,
        description: l10n.recurringPaymentsExecution_unknown_result_description,
        onClose: onClose,
      );
    }

    return _accepted(context);
  }

  Widget _accepted(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.recurringPaymentsExecution_sent_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        RecurringPaymentExecutionNotice(
          text:
              method == RecurringPaymentMethodType.PIX_QR
                  ? l10n.recurringPaymentsExecution_pixQr_pending
                  : l10n.recurringPaymentsExecution_sent_description,
          icon: Icons.hourglass_top,
          color: AppColors.blue,
        ),
        const SizedBox(height: 12),
        if (result.effectiveAmount != null)
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_field_value,
            value: CurrencyFormatter.formatCurrency(
              result.effectiveAmount!,
              symbol: symbolFormatMoney,
            ),
          ),
        RecurringPaymentExecutionField(
          label: l10n.recurringPaymentsExecution_field_method,
          value:
              method == RecurringPaymentMethodType.PIX ||
                      method == RecurringPaymentMethodType.PIX_QR
                  ? l10n.recurringPaymentsExecution_method_pix
                  : l10n.recurringPaymentsExecution_method_bill,
        ),
        const SizedBox(height: 18),
        if (method == RecurringPaymentMethodType.PIX_QR) ...[
          CustomButton(
            text: l10n.recurringPaymentsExecution_pixQr_checkStatus,
            backgroundColor: AppColors.green,
            disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
            textColor: Colors.black,
            icon: Icons.refresh,
            leading:
                isCheckingStatus
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : null,
            onPressed: isCheckingStatus ? null : onCheckStatus,
          ),
          const SizedBox(height: 8),
        ],
        CustomButton(
          text: l10n.recurringPaymentsExecution_common_close,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _block(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required VoidCallback onClose,
    Widget? primary,
  }) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 12.5,
                      height: 1.6,
                      color: Color(0xFF5F5F5F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (primary != null) ...[primary, const SizedBox(height: 8)],
        CustomButton(
          text: l10n.recurringPaymentsExecution_common_close,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          onPressed: onClose,
        ),
      ],
    );
  }
}
