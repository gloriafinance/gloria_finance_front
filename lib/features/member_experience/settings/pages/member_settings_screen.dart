import 'package:church_finance_bk/app/locale_store.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberSettingsScreen extends StatefulWidget {
  const MemberSettingsScreen({super.key});

  @override
  State<MemberSettingsScreen> createState() => _MemberSettingsScreenState();
}

class _MemberSettingsScreenState extends State<MemberSettingsScreen> {
  // Mock state for notifications
  bool _churchEventsEnabled = true;
  bool _paymentCommitmentsEnabled = true;
  bool _contributionsStatusEnabled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeStore = context.watch<LocaleStore>();
    final currentLocale = localeStore.locale;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light grey background
      body: Column(
        children: [
          _SettingsHeader(
            title: l10n.member_settings_title,
            subtitle: l10n.member_settings_subtitle,
            onBack: () => context.canPop() ? context.pop() : context.go('/'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Language Section
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.member_settings_language_title,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.member_settings_language_description,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontText,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildLanguageOption(
                          context,
                          label: 'Português (Brasil)',
                          locale: const Locale('pt', 'BR'),
                          currentLocale: currentLocale,
                          isDefault: true,
                          l10n: l10n,
                          onTap:
                              () => localeStore.setLocale(
                                const Locale('pt', 'BR'),
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          label: 'Español (Latinoamérica)',
                          locale: const Locale('es'),
                          currentLocale: currentLocale,
                          onTap:
                              () => localeStore.setLocale(const Locale('es')),
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          label: 'English (US)',
                          locale: const Locale('en'),
                          currentLocale: currentLocale,
                          onTap:
                              () => localeStore.setLocale(const Locale('en')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notifications Section
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.member_settings_notifications_title,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.member_settings_notifications_description,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontText,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildNotificationOption(
                          icon: Icons.calendar_today_outlined,
                          title:
                              l10n.member_settings_notification_church_events_title,
                          description:
                              l10n.member_settings_notification_church_events_desc,
                          value: _churchEventsEnabled,
                          onChanged: (val) {
                            setState(() {
                              _churchEventsEnabled = val;
                            });
                          },
                        ),
                        const Divider(height: 32),
                        _buildNotificationOption(
                          icon: Icons.receipt_long_outlined,
                          title:
                              l10n.member_settings_notification_payments_title,
                          description:
                              l10n.member_settings_notification_payments_desc,
                          value: _paymentCommitmentsEnabled,
                          onChanged: (val) {
                            setState(() {
                              _paymentCommitmentsEnabled = val;
                            });
                          },
                        ),
                        const Divider(height: 32),
                        _buildNotificationOption(
                          icon: Icons.volunteer_activism_outlined,
                          title:
                              l10n.member_settings_notification_contributions_status_title,
                          description:
                              l10n.member_settings_notification_contributions_status_desc,
                          value: _contributionsStatusEnabled,
                          onChanged: (val) {
                            setState(() {
                              _contributionsStatusEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
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
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String label,
    required Locale locale,
    required Locale currentLocale,
    required VoidCallback onTap,
    bool isDefault = false,
    dynamic l10n,
  }) {
    // Check if languages match (handling potentially null country code)
    final isSelected =
        locale.languageCode == currentLocale.languageCode &&
        (locale.countryCode == null ||
            locale.countryCode == currentLocale.countryCode);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFF3E5F5)
                  : Colors.white, // Light Purple
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purple : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n?.member_settings_language_default_tag ?? 'Padrão',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.purple : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.purple : Colors.grey.shade400,
                ),
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(
              0xFFE8E5EA,
            ), // Light purple/grey background for icon
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.purple, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Switch(
                    value: value,
                    onChanged: onChanged,
                    activeColor: AppColors.purple,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 48.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _SettingsHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
