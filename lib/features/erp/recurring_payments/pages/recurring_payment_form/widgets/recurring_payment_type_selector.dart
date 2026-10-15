import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';

import '../../../models/recurring_payment_model.dart';

/// Elección del tipo de valor (fijo o variable).
///
/// Es un par de radio-cards y no un dropdown: esa decisión cambia el resto del
/// formulario (muestra u oculta el valor) y debe quedar visible todo el tiempo.
class RecurringPaymentTypeSelector extends StatelessWidget {
  const RecurringPaymentTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RecurringPaymentValueType selected;
  final ValueChanged<RecurringPaymentValueType> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      _TypeOption(type: RecurringPaymentValueType.FIXED),
      _TypeOption(type: RecurringPaymentValueType.VARIABLE),
    ];

    if (isMobile(context)) {
      return Column(
        children: [
          for (final option in options) ...[
            option.build(context, selected, onChanged),
            const SizedBox(height: 10),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in options) ...[
          Expanded(child: option.build(context, selected, onChanged)),
          if (option != options.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _TypeOption {
  const _TypeOption({required this.type});

  final RecurringPaymentValueType type;

  Widget build(
    BuildContext context,
    RecurringPaymentValueType selected,
    ValueChanged<RecurringPaymentValueType> onChanged,
  ) {
    final isSelected = type == selected;
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => onChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.purple.withValues(alpha: 0.08)
                  : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.greyMiddle,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.purple : AppColors.greyMiddle,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purple,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.friendlyName(l10n),
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    type == RecurringPaymentValueType.FIXED
                        ? l10n.recurringPayments_type_fixed_hint
                        : l10n.recurringPayments_type_variable_hint,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 11.5,
                      height: 1.5,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
