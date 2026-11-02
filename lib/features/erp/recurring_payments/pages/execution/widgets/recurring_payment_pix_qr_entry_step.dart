import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

class RecurringPaymentPixQrEntryStep extends StatelessWidget {
  const RecurringPaymentPixQrEntryStep({
    super.key,
    required this.onCamera,
    required this.onPaste,
  });
  final VoidCallback onCamera;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.recurringPaymentsExecution_qr_entry_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _QrEntryCard(
          icon: Icons.qr_code_scanner,
          title: l10n.recurringPaymentsExecution_qr_camera,
          subtitle: l10n.recurringPaymentsExecution_qr_camera_hint,
          onTap: onCamera,
        ),
        const SizedBox(height: 10),
        _QrEntryCard(
          icon: Icons.content_paste,
          title: l10n.recurringPaymentsExecution_qr_paste,
          subtitle: l10n.recurringPaymentsExecution_qr_paste_hint,
          onTap: onPaste,
        ),
      ],
    );
  }
}

class _QrEntryCard extends StatelessWidget {
  const _QrEntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E7EC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 11.5,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}
