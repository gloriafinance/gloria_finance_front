import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

class ChurchProfileHeader extends StatelessWidget {
  final VoidCallback onSave;
  final bool isSaving;

  const ChurchProfileHeader({
    super.key,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings_church_profile_title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.settings_church_profile_subtitle,
                style: const TextStyle(
                  fontFamily: AppFonts.fontText,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: l10n.settings_church_profile_save,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  onPressed: isSaving ? null : onSave,
                ),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settings_church_profile_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settings_church_profile_subtitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            CustomButton(
              text: l10n.settings_church_profile_save,
              backgroundColor: AppColors.purple,
              textColor: Colors.white,
              onPressed: isSaving ? null : onSave,
            ),
          ],
        );
      },
    );
  }
}
