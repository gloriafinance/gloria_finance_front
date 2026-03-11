import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

class DevotionalToneSelector extends StatelessWidget {
  final List<String> tones;
  final String selectedTone;
  final ValueChanged<String> onSelect;
  final String Function(String) titleBuilder;
  final String Function(String) subtitleBuilder;

  const DevotionalToneSelector({
    super.key,
    required this.tones,
    required this.selectedTone,
    required this.onSelect,
    required this.titleBuilder,
    required this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final selectedSubtitle = subtitleBuilder(selectedTone);

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 760 ? 4 : (maxWidth >= 320 ? 2 : 1);
        final chipWidth = (maxWidth - (spacing * (columns - 1))) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children:
                  tones.map((tone) {
                    final selected = selectedTone == tone;

                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onSelect(tone),
                      child: Container(
                        width: chipWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              selected
                                  ? AppColors.purple.withValues(alpha: 0.10)
                                  : Colors.white,
                          border: Border.all(
                            color:
                                selected
                                    ? AppColors.purple
                                    : AppColors.greyMiddle,
                            width: selected ? 1.4 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? AppColors.purple.withValues(
                                          alpha: 0.16,
                                        )
                                        : AppColors.greyLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _iconByTone(tone),
                                size: 14,
                                color:
                                    selected
                                        ? AppColors.purple
                                        : AppColors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                titleBuilder(tone),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppFonts.fontTitle,
                                  fontSize: 14,
                                  color:
                                      selected
                                          ? AppColors.black
                                          : AppColors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              selectedSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _iconByTone(String tone) {
    switch (tone) {
      case 'pastoral':
        return Icons.volunteer_activism;
      case 'exhortative_soft':
        return Icons.local_fire_department;
      case 'celebrative':
        return Icons.celebration;
      case 'contemplative':
        return Icons.self_improvement;
      default:
        return Icons.auto_awesome;
    }
  }
}
