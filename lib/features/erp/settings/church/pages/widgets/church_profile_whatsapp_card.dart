import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../models/church_model.dart';
import 'church_profile_card.dart';

class ChurchProfileWhatsAppCard extends StatelessWidget {
  final ChurchModel? church;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const ChurchProfileWhatsAppCard({
    super.key,
    required this.church,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Check if WABA ID is present (connected)
    final bool isConnected =
        church?.wabaId != null && church!.wabaId!.isNotEmpty;

    return ChurchProfileCard(
      title: l10n.settings_church_profile_whatsapp_title,
      // Custom coloring for WhatsApp card if needed, but sticking to standard now
      // child container could have color if desired.
      icon: Icons.message, // Or WhatsApp icon if available
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle and Actions
          Text(
            l10n.settings_church_profile_whatsapp_subtitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.black54,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: isConnected ? null : onConnect,
              icon: isConnected ? Icons.check_circle : Icons.chat,
              text:
                  isConnected
                      ? l10n.settings_church_profile_whatsapp_connected
                      : l10n.settings_church_profile_whatsapp_connect,
              backgroundColor:
                  isConnected ? Colors.grey : const Color(0xFF25D366),
              textColor: Colors.white,
            ),
          ),
          if (isConnected) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: onDisconnect,
                text: l10n.settings_church_profile_whatsapp_disconnect,
                backgroundColor: Colors.red,
                typeButton: CustomButton.outline,
                textColor: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
