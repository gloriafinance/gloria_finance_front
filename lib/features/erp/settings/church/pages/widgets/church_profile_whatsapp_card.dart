import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/church/store/church_store.dart';
import 'package:gloria_finance/features/erp/settings/integrations/services/integrations_service.dart';
import 'package:gloria_finance/features/erp/settings/integrations/store/whatsapp_test_message_store.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/church_model.dart';
import 'church_profile_card.dart';

class ChurchProfileWhatsAppCard extends StatefulWidget {
  final ChurchModel? church;
  final VoidCallback onConnect;

  const ChurchProfileWhatsAppCard({
    super.key,
    required this.church,
    required this.onConnect,
  });

  @override
  State<ChurchProfileWhatsAppCard> createState() =>
      _ChurchProfileWhatsAppCardState();
}

class _ChurchProfileWhatsAppCardState extends State<ChurchProfileWhatsAppCard> {
  bool _isDisconnecting = false;
  final _testRecipientController = TextEditingController();

  @override
  void dispose() {
    _testRecipientController.dispose();
    super.dispose();
  }

  Future<void> _disconnectWhatsapp() async {
    if (_isDisconnecting) return;

    final authStore = context.read<AuthSessionStore>();
    final churchStore = context.read<ChurchStore>();
    final service = IntegrationsService(
      tokenAPI: authStore.state.session.token,
    );

    setState(() => _isDisconnecting = true);
    try {
      await service.disconnectWhatsapp();
      await churchStore.loadChurch(authStore.state.session.churchId);
    } catch (_) {
      // Error toast is already handled by AppHttp.transformResponse.
    } finally {
      if (mounted) {
        setState(() => _isDisconnecting = false);
      }
    }
  }

  Future<void> _sendTestMessage() async {
    final recipient = _testRecipientController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (recipient.isEmpty) {
      Toast.showMessage(
        l10n.settings_church_profile_whatsapp_test_recipient_required,
        ToastType.info,
      );
      return;
    }

    final success = await context.read<WhatsappTestMessageStore>().send(
      recipient,
    );
    if (!mounted) {
      return;
    }

    Toast.showMessage(
      success
          ? l10n.settings_church_profile_whatsapp_test_success
          : l10n.settings_church_profile_whatsapp_test_error,
      success ? ToastType.success : ToastType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isConnected = widget.church?.isWhatsappConnected == true;
    final testMessageStore = context.watch<WhatsappTestMessageStore>();

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
              onPressed:
                  isConnected || _isDisconnecting ? null : widget.onConnect,
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
            Text(
              l10n.settings_church_profile_whatsapp_test_title,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.settings_church_profile_whatsapp_test_subtitle,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _testRecipientController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.settings_church_profile_whatsapp_test_recipient,
                hintText:
                    l10n.settings_church_profile_whatsapp_test_recipient_hint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: testMessageStore.isSending ? null : _sendTestMessage,
                text:
                    testMessageStore.isSending
                        ? l10n.settings_church_profile_whatsapp_test_sending
                        : l10n.settings_church_profile_whatsapp_test_send,
                icon: testMessageStore.isSending ? null : Icons.send,
                leading:
                    testMessageStore.isSending
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : null,
                backgroundColor: const Color(0xFF25D366),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: _isDisconnecting ? null : _disconnectWhatsapp,
                text: l10n.settings_church_profile_whatsapp_disconnect,
                backgroundColor: Colors.red,
                typeButton: CustomButton.outline,
                textColor: Colors.red,
                leading:
                    _isDisconnecting
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
