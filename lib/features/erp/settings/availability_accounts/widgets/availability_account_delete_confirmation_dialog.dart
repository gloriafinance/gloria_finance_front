import 'package:flutter/material.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

Future<bool?> showAvailabilityAccountDeleteConfirmationDialog(
  BuildContext context, {
  required String accountName,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (dialogContext) => AlertDialog(
          title: Text(l10n.settings_availability_delete_confirm_title),
          content: Text(
            l10n.settings_availability_delete_confirm_message(accountName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.common_cancel),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.settings_availability_delete_confirm_action),
            ),
          ],
        ),
  );
}
