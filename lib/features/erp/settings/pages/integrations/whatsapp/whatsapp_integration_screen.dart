import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappIntegrationScreen extends StatelessWidget {
  const WhatsappIntegrationScreen({super.key});

  Future<void> _launchMetaSignup() async {
    final Map<String, String> queryParameters = {
      'client_id': "25820028151023925",
      'redirect_uri':
          kReleaseMode
              ? "https://devpto-dev--preview-chore-webhook-whatsaap-1k94yli1.web.app/integrations/whatsapp/callback"
              : "http://localhost:3000/integrations/whatsapp/callback",
      'response_type': 'code',
      'scope': 'whatsapp_business_management,whatsapp_business_messaging',
      'extras': '{"setup":{"config_id":"2065801614266200"}}',
    };

    final Uri url = Uri.https(
      'www.facebook.com',
      '/v18.0/dialog/oauth',
      queryParameters,
    );

    debugPrint('Launching Meta Signup URL: $url');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settings_integrations_whatsapp_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settings_integrations_whatsapp_description,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons
                      .message, // Use a generic icon if WhatsApp icon is not available
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.settings_integrations_whatsapp_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.settings_integrations_whatsapp_description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _launchMetaSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.settings_integrations_whatsapp_button_connect,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
