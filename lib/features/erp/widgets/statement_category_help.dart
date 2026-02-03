import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class StatementCategoryHelpEntry {
  final String code;
  final String title;
  final String body;

  const StatementCategoryHelpEntry({
    this.code = '',
    required this.title,
    required this.body,
  });

  bool get hasCode => code.trim().isNotEmpty;
}

class StatementCategoryHelpButton extends StatelessWidget {
  final String dialogTitle;
  final List<StatementCategoryHelpEntry> entries;
  final String closeText;
  final String? tooltipMessage;
  final Color backgroundColor;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final bool showEntryHeading;

  const StatementCategoryHelpButton({
    super.key,
    required this.dialogTitle,
    required this.entries,
    required this.closeText,
    this.tooltipMessage,
    this.backgroundColor = const Color.fromRGBO(243, 205, 51, 0.51),
    this.iconColor = Colors.black87,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    this.iconSize = 14,
    this.showEntryHeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final trigger = InkWell(
      onTap: () => _showHelpDialog(context),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(Icons.help_outline, size: iconSize, color: iconColor),
      ),
    );

    if (tooltipMessage == null || tooltipMessage!.isEmpty) {
      return trigger;
    }

    return Tooltip(message: tooltipMessage, child: trigger);
  }

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            dialogTitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < entries.length; i++) ...[
                    _entry(entries[i]),
                    if (i < entries.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                closeText,
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _entry(StatementCategoryHelpEntry entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showEntryHeading) ...[
          Text(
            entry.hasCode ? '${entry.code} · ${entry.title}' : entry.title,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          entry.body,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            height: 1.45,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
