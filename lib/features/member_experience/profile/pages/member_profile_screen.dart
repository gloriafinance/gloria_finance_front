import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/member_experience/widgets/member_header.dart';
import 'package:gloria_finance/features/member_experience/profile/store/member_profile_store.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessionStore = context.watch<AuthSessionStore>();
    final session = sessionStore.state.session;

    return ChangeNotifierProvider(
      create: (_) => MemberProfileStore()..loadProfile(session.memberId ?? ''),
      child: Builder(
        builder: (context) {
          final profileStore = context.watch<MemberProfileStore>();

          return Column(
            children: [
              // Custom Purple Header matching MemberContributeScreen
              MemberHeaderWidget(
                title: l10n.member_drawer_profile,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildUserInfoCard(session, profileStore, context, l10n),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: l10n.member_profile_personal_data_title,
                        child: _buildPersonalDataCard(
                          session,
                          profileStore,
                          context,
                          l10n,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // _buildSection(
                      //   title: l10n.member_profile_security_title,
                      //   child: _buildSecurityCard(context, l10n),
                      // ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: l10n.member_profile_notifications_title,
                        child: _buildSettings(context, l10n),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(
    AuthSessionModel session,
    MemberProfileStore profileStore,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final profile = profileStore.profile;
    // Mock date or format createdAt
    String memberSince = "2023";
    try {
      final createdAtRaw = profile?.createdAt ?? session.createdAt;
      if (createdAtRaw.isNotEmpty) {
        memberSince = DateTime.parse(createdAtRaw).year.toString();
      }
    } catch (_) {}

    final name = profile?.name ?? session.name;
    final churchName = profile?.church?.name ?? session.churchName;

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
            child:
                profileStore.isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
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
            name,
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
            churchName,
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
    MemberProfileStore profileStore,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final name = profileStore.profile?.name ?? session.name;
    final email = profileStore.profile?.email ?? session.email;
    final phone = profileStore.profile?.phone ?? "";
    final dni = profileStore.profile?.dni ?? "";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child:
          profileStore.isLoading
              ? const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
              : Column(
                children: [
                  _buildInfoRow(
                    l10n.member_profile_full_name_label,
                    name.isNotEmpty ? name : "-",
                    isFirst: true,
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildInfoRow(
                    l10n.member_profile_email_label,
                    email.isNotEmpty ? email : "-",
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildInfoRow(
                    l10n.member_profile_phone_label,
                    phone.isNotEmpty ? phone : "-",
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildInfoRow(
                    l10n.member_profile_dni_label,
                    dni.isNotEmpty ? dni : "-",
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

  Widget _buildSettings(BuildContext context, AppLocalizations l10n) {
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
            context.go("/member/settings");
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
                    Icons.settings_outlined,
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
