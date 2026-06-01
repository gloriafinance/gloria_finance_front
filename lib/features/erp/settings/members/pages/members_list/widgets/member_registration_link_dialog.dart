import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../store/member_registration_link_store.dart';

class MemberRegistrationLinkDialog extends StatelessWidget {
  const MemberRegistrationLinkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(24),
        child: const _DialogContent(),
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MemberRegistrationLinkStore>();
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.member_registration_link_title,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: AppFonts.fontTitle,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        if (store.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (store.error != null)
          _buildError(context, store)
        else if (store.link != null)
          _buildSuccess(context, store)
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildError(BuildContext context, MemberRegistrationLinkStore store) {
    final l10n = context.l10n;
    final message = store.error == 'permission'
        ? l10n.member_registration_link_error_permission
        : l10n.member_registration_link_error_generic;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: AppFonts.fontSubTitle,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ButtonActionTable(
            text: l10n.member_registration_link_close_button,
            color: Colors.black38,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.close,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context, MemberRegistrationLinkStore store) {
    final l10n = context.l10n;
    final link = store.link!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.member_registration_link_description,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.fontSubTitle,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '${l10n.member_registration_link_church_label}: ',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.fontSubTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                link.churchName,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.fontSubTitle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyMiddle),
          ),
          child: SelectableText(
            link.registrationUrl,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.purple,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ButtonActionTable(
              text: l10n.member_registration_link_copy_button,
              color: AppColors.purple,
              onPressed: () => _handleCopy(context, store),
              icon: Icons.copy,
            ),
            ButtonActionTable(
              text: l10n.member_registration_link_whatsapp_button,
              color: AppColors.green,
              onPressed: () => _handleWhatsApp(context, store),
              icon: Icons.share,
            ),
            ButtonActionTable(
              text: l10n.member_registration_link_close_button,
              color: Colors.black38,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.close,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.purple, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.member_registration_link_review_note,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: AppFonts.fontSubTitle,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleCopy(
    BuildContext context,
    MemberRegistrationLinkStore store,
  ) async {
    await store.copyLink();
    if (context.mounted) {
      Toast.showMessage(
        context.l10n.member_registration_link_copied,
        ToastType.success,
      );
    }
  }

  Future<void> _handleWhatsApp(
    BuildContext context,
    MemberRegistrationLinkStore store,
  ) async {
    final l10n = context.l10n;
    final link = store.link!;
    final message = l10n.member_registration_link_whatsapp_message(
      link.registrationUrl,
    );
    final launched = await store.shareOnWhatsApp(message);
    if (!launched && context.mounted) {
      Toast.showMessage(
        'No fue posible abrir WhatsApp.',
        ToastType.warning,
      );
    }
  }
}
