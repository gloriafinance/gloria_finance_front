import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/member_experience/settings/widgets/member_settings_language_section.dart';
import 'package:church_finance_bk/features/member_experience/settings/widgets/member_settings_notifications_section.dart';
import 'package:church_finance_bk/features/member_experience/widgets/member_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberSettingsScreen extends StatelessWidget {
  const MemberSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        MemberHeaderWidget(
          title: l10n.member_settings_title,
          subtitle: l10n.member_settings_subtitle,
          onBack: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Section
                const MemberSettingsLanguageSection(),
                const SizedBox(height: 24),

                // Notifications Section
                const MemberSettingsNotificationsSection(),
                const SizedBox(height: 32),

                Container(
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
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      l10n.member_settings_footer_coming_soon,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        color: Colors.grey,
                        fontSize: 14,
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
