import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PixPaymentCodePanel extends StatelessWidget {
  final String copyPaste;
  final String codeLabel;
  final String copyLabel;
  final String qrHint;
  final String copiedMessage;

  const PixPaymentCodePanel({
    super.key,
    required this.copyPaste,
    required this.codeLabel,
    required this.copyLabel,
    required this.qrHint,
    required this.copiedMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E5EF)),
          ),
          child: Column(
            children: [
              QrImageView(data: copyPaste, version: QrVersions.auto, size: 230),
              const SizedBox(height: 14),
              Text(
                qrHint,
                style: TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E5EF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                codeLabel,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 16,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SelectableText(copyPaste),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ButtonActionTable(
                  color: AppColors.purple,
                  text: copyLabel,
                  icon: Icons.copy,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: copyPaste));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(copiedMessage)));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
