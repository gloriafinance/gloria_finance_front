import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:share_plus/share_plus.dart';

class FinancialConceptPixDialog extends StatelessWidget {
  final String conceptName;
  final String copyPaste;
  final String encodedImage;

  const FinancialConceptPixDialog({
    super.key,
    required this.conceptName,
    required this.copyPaste,
    required this.encodedImage,
  });

  static Future<void> show(
    BuildContext context, {
    required String conceptName,
    required String copyPaste,
    required String encodedImage,
  }) {
    return showDialog<void>(
      context: context,
      builder:
          (_) => FinancialConceptPixDialog(
            conceptName: conceptName,
            copyPaste: copyPaste,
            encodedImage: encodedImage,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        context.l10n.settings_financial_concept_pix_dialog_title,
        style: const TextStyle(fontFamily: AppFonts.fontTitle),
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                conceptName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.memory(
                  base64Decode(encodedImage),
                  width: 240,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.settings_financial_concept_pix_copy_paste_label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                copyPaste,
                style: const TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(
                      context.l10n.settings_financial_concept_pix_copy_action,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _sharePix,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.purple,
                    ),
                    icon: const Icon(Icons.share_outlined),
                    label: Text(
                      context.l10n.settings_financial_concept_pix_share_action,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.l10n.common_cancel,
            style: TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        ),
      ],
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: copyPaste));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.settings_financial_concept_pix_copy_success),
        backgroundColor: AppColors.green,
      ),
    );
  }

  Future<void> _sharePix() async {
    await SharePlus.instance.share(
      ShareParams(
        text: '$conceptName\n$copyPaste',
        files: [
          XFile.fromData(
            base64Decode(encodedImage),
            mimeType: 'image/png',
            name: 'pix-$conceptName.png',
          ),
        ],
      ),
    );
  }
}
