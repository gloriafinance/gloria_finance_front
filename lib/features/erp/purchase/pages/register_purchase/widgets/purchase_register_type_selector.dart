import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/index.dart';

import '../models/purchase_register_type.dart';

class PurchaseRegisterTypeSelector extends StatelessWidget {
  final PurchaseRegisterType selectedType;
  final ValueChanged<PurchaseRegisterType> onChanged;

  const PurchaseRegisterTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          PurchaseRegisterType.values.map((type) {
            final isSelected = type == selectedType;

            return ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  type.label,
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    color: isSelected ? AppColors.purple : AppColors.grey,
                  ),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.purple.withOpacity(0.12),
              backgroundColor: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? AppColors.purple : AppColors.greyMiddle,
                ),
              ),
              onSelected: (_) => onChanged(type),
            );
          }).toList(),
    );
  }
}
