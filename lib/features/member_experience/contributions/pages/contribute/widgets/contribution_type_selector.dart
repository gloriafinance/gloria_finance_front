import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:flutter/material.dart';

class ContributionTypeSelector extends StatelessWidget {
  final MemberContributionType selectedType;
  final ValueChanged<MemberContributionType> onTypeSelected;

  const ContributionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.member_contribution_filter_type_label,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 16,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeButton(
                context,
                MemberContributionType.tithe,
                context.l10n.member_contribution_type_tithe,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeButton(
                context,
                MemberContributionType.offering,
                context.l10n.member_contribution_type_offering,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    BuildContext context,
    MemberContributionType type,
    String label,
  ) {
    final isSelected = selectedType == type;

    return Material(
      color: isSelected ? AppColors.purple : Colors.white,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () => onTypeSelected(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? AppColors.purple : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 18,
                ),
              if (isSelected) const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 14,
                  color: isSelected ? Colors.white : AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
