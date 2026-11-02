import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

/// Fila de switch con título y descripción.
///
/// Se usa un `Switch` dentro de un `Row` (patrón del ERP) y no un
/// `SwitchListTile`: el ListTile exige un `Material` propio cuando vive dentro de
/// una superficie con color, como la `SectionCard`.
class RecurringPaymentSwitchRow extends StatelessWidget {
  const RecurringPaymentSwitchRow({
    super.key,
    required this.value,
    required this.title,
    required this.description,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String description;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Switch(
            value: value,
            activeColor: AppColors.green,
            onChanged: onChanged,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
