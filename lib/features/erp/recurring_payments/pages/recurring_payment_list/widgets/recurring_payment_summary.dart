import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_list_store.dart';

/// Resumen de la configuración actual.
///
/// Responde "qué está comprometido" sin volverse un panel financiero: son
/// conteos de configuración y la suma de los fijos activos.
class RecurringPaymentSummary extends StatelessWidget {
  const RecurringPaymentSummary({super.key, required this.symbolFormatMoney});

  final String symbolFormatMoney;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecurringPaymentListStore>().state;

    if (!state.hasPayments) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _SummaryStat(
            color: AppColors.purple,
            value: '${state.totalCount}',
            label: context.l10n.recurringPayments_summary_total,
          ),
          _SummaryStat(
            color: AppColors.green,
            value: '${state.activeCount}',
            label: context.l10n.recurringPayments_summary_active,
          ),
          _SummaryStat(
            color: Colors.red,
            value: '${state.inactiveCount}',
            label: context.l10n.recurringPayments_summary_inactive,
          ),
          _SummaryStat(
            color: AppColors.mustard,
            value: CurrencyFormatter.formatCurrency(
              state.activeFixedMonthlyTotal,
              symbol: symbolFormatMoney,
            ),
            label: context.l10n.recurringPayments_summary_fixed_month,
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.color,
    required this.value,
    required this.label,
  });

  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 15,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 11.5,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
