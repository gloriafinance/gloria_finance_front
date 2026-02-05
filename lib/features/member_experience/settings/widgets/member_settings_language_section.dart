import 'package:gloria_finance/app/locale_store.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberSettingsLanguageSection extends StatelessWidget {
  const MemberSettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeStore = context.watch<LocaleStore>();
    final currentLocale = localeStore.locale;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.member_settings_language_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.member_settings_language_description,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          _buildLanguageOption(
            context,
            label: 'Português (Brasil)',
            locale: const Locale('pt', 'BR'),
            currentLocale: currentLocale,
            isDefault: true,
            l10n: l10n,
            onTap: () => localeStore.setLocale(const Locale('pt', 'BR')),
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            context,
            label: 'Español (Latinoamérica)',
            locale: const Locale('es'),
            currentLocale: currentLocale,
            onTap: () => localeStore.setLocale(const Locale('es')),
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            context,
            label: 'English (US)',
            locale: const Locale('en'),
            currentLocale: currentLocale,
            onTap: () => localeStore.setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String label,
    required Locale locale,
    required Locale currentLocale,
    required VoidCallback onTap,
    bool isDefault = false,
    dynamic l10n,
  }) {
    // Check if languages match (handling potentially null country code)
    final isSelected =
        locale.languageCode == currentLocale.languageCode &&
        (locale.countryCode == null ||
            locale.countryCode == currentLocale.countryCode);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFF3E5F5)
                  : Colors.white, // Light Purple
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purple : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n?.member_settings_language_default_tag ?? 'Padrão',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.purple : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.purple : Colors.grey.shade400,
                ),
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
