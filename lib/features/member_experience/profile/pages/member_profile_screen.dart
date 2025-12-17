import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/features/auth/auth_session_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:church_finance_bk/l10n/app_localizations.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessionStore = context.watch<AuthSessionStore>();
    final session = sessionStore.state.session;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Custom Purple Header matching MemberContributeScreen
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 8),
            decoration: const BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                Center(
                  child: Text(
                    l10n.member_drawer_profile,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildUserInfoCard(session, context, l10n),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: l10n.member_profile_personal_data_title,
                    child: _buildPersonalDataCard(session, context, l10n),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: l10n.member_profile_security_title,
                    child: _buildSecurityCard(context, l10n),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: l10n.member_profile_notifications_title,
                    child: _buildNotificationCard(context, l10n),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(
    AuthSessionModel session,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    // Mock date or format createdAt
    String memberSince = "2023";
    try {
      if (session.createdAt.isNotEmpty) {
        memberSince = DateTime.parse(session.createdAt).year.toString();
      }
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(
              0xFF7B8FA1,
            ), // Greyish blue from design
            child: Text(
              session.name.isNotEmpty ? session.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            session.name,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.member_profile_member_since(memberSince),
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            session.churchName.isNotEmpty
                ? session.churchName
                : "Igreja Batista Glória",
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildPersonalDataCard(
    AuthSessionModel session,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            l10n.member_profile_full_name_label,
            session.name,
            isFirst: true,
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildInfoRow(l10n.member_profile_email_label, session.email),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // TODO: Mock data for now as per plan
          _buildInfoRow(l10n.member_profile_phone_label, "(11) 91234-5678"),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildInfoRow(
            l10n.member_profile_dni_label,
            "123.456.789-00",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 16,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go('/member/profile/change-password');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, color: AppColors.purple),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.member_profile_change_password_title,
                        style: TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.member_profile_change_password_subtitle,
                        style: TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to notification settings
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.member_profile_notifications_settings_title,
                        style: TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.member_profile_notifications_settings_subtitle,
                        style: TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
