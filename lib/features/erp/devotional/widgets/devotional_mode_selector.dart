import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

class DevotionalModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onChanged;
  final String title;
  final String automaticTitle;
  final String automaticSubtitle;
  final String reviewTitle;
  final String reviewSubtitle;

  const DevotionalModeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
    required this.title,
    required this.automaticTitle,
    required this.automaticSubtitle,
    required this.reviewTitle,
    required this.reviewSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        _ModeCard(
          selected: selectedMode == 'automatic',
          title: automaticTitle,
          subtitle: automaticSubtitle,
          icon: Icons.flash_on,
          onTap: () => onChanged('automatic'),
        ),
        const SizedBox(height: 8),
        _ModeCard(
          selected: selectedMode == 'review',
          title: reviewTitle,
          subtitle: reviewSubtitle,
          icon: Icons.playlist_add_check,
          onTap: () => onChanged('review'),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ModeCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.purple : AppColors.greyMiddle,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.purple : AppColors.grey,
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
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, color: selected ? AppColors.purple : AppColors.grey),
          ],
        ),
      ),
    );
  }
}
