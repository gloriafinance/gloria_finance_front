import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

class MemberSettingsNotificationsSection extends StatefulWidget {
  const MemberSettingsNotificationsSection({super.key});

  @override
  State<MemberSettingsNotificationsSection> createState() =>
      _MemberSettingsNotificationsSectionState();
}

class _MemberSettingsNotificationsSectionState
    extends State<MemberSettingsNotificationsSection> {
  // Mock state for notifications
  bool _churchEventsEnabled = true;
  bool _paymentCommitmentsEnabled = true;
  bool _contributionsStatusEnabled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
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
            title: l10n.member_settings_notification_church_events_title,
            description: l10n.member_settings_notification_church_events_desc,
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
            title: l10n.member_settings_notification_payments_title,
            description: l10n.member_settings_notification_payments_desc,
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
            title: l10n.member_settings_notification_contributions_status_title,
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
