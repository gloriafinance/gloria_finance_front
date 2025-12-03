import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

List<DropdownMenuItem<dynamic>> monthDropdown(BuildContext context) {
  final l10n = context.l10n;

  final items = <MapEntry<String, String>>[
    MapEntry('01', l10n.month_january),
    MapEntry('02', l10n.month_february),
    MapEntry('03', l10n.month_march),
    MapEntry('04', l10n.month_april),
    MapEntry('05', l10n.month_may),
    MapEntry('06', l10n.month_june),
    MapEntry('07', l10n.month_july),
    MapEntry('08', l10n.month_august),
    MapEntry('09', l10n.month_september),
    MapEntry('10', l10n.month_october),
    MapEntry('11', l10n.month_november),
    MapEntry('12', l10n.month_december),
  ];

  return items
      .map(
        (entry) => DropdownMenuItem(
          value: entry.key,
          child: Text(
            entry.value,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AppFonts.fontText,
            ),
          ),
        ),
      )
      .toList();
}
