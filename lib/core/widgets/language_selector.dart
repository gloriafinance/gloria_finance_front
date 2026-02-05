import 'package:gloria_finance/app/locale_store.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeStore = context.watch<LocaleStore>();
    final currentLocale = localeStore.locale;

    String labelFor(Locale locale) {
      final languageCode = locale.languageCode.toUpperCase();
      final country = locale.countryCode;
      if (country == null || country.isEmpty) {
        return languageCode;
      }
      return '$languageCode-$country';
    }

    final supportedLocales = localeStore.supportedLocales;

    return PopupMenuButton<Locale>(
      tooltip: '',
      onSelected: (locale) {
        localeStore.setLocale(locale);
      },
      itemBuilder:
          (context) => supportedLocales
              .map(
                (locale) => PopupMenuItem<Locale>(
                  value: locale,
                  child: Row(
                    children: [
                      if (locale == currentLocale)
                        const Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.purple,
                        )
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      Text(
                        labelFor(locale),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.greyMiddle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language,
              size: 18,
              color: AppColors.purple,
            ),
            const SizedBox(width: 6),
            Text(
              labelFor(currentLocale),
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: AppColors.greyMiddle,
            ),
          ],
        ),
      ),
    );
  }
}
