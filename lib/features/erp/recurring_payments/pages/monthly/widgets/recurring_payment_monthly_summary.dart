import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_monthly_store.dart';

/// Resumo do mês: quantos compromissos estão pendentes e quantos já foram pagos.
///
/// O total só soma valores **fixos**: um compromisso variável não tem valor
/// antes de ser pago, e somar zero mentiria. Quando existem variáveis
/// pendentes, elas aparecem como contagem ao lado do total.
class RecurringPaymentMonthlySummary extends StatelessWidget {
  const RecurringPaymentMonthlySummary({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecurringPaymentMonthlyStore>().state;
    final l10n = context.l10n;

    if (!state.hasItems) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.recurringPaymentsExecution_summary_label,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.purple,
          ),
        ),
        _Chip(
          text: l10n.recurringPaymentsExecution_summary_counts(
            state.pendingCount,
            state.paidCount,
          ),
        ),
        if (state.pendingCount > 0)
          _Chip(
            text: l10n.recurringPaymentsExecution_summary_fixed_total(
              CurrencyFormatter.formatCurrency(
                state.fixedPendingTotal,
                symbol: symbol,
              ),
            ),
          ),
        if (state.variablePendingCount > 0)
          _Chip(
            text: l10n.recurringPaymentsExecution_summary_variable_pending(
              state.variablePendingCount,
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppFonts.fontText,
          fontSize: 12,
          color: AppColors.purple,
        ),
      ),
    );
  }
}
