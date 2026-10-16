import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_monthly_store.dart';

/// Seletor de competência: ‹ OUTUBRO 2026 ›
class RecurringPaymentMonthSelector extends StatelessWidget {
  const RecurringPaymentMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentMonthlyStore>();
    final month = store.state.month;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ArrowButton(
          icon: Icons.chevron_left,
          onPressed: store.previousMonth,
          tooltip: month.previous.label,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 176),
          child: Text(
            month.label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 15,
              letterSpacing: 0.4,
              color: AppColors.purple,
            ),
          ),
        ),
        _ArrowButton(
          icon: Icons.chevron_right,
          onPressed: store.nextMonth,
          tooltip: month.next.label,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        color: AppColors.purple,
        splashRadius: 20,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
