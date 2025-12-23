import 'package:church_finance_bk/app/locale_store.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/language_selector.dart';
import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberDrawer extends StatefulWidget {
  const MemberDrawer({super.key});

  @override
  State<MemberDrawer> createState() => _MemberDrawerState();
}

class _MemberDrawerState extends State<MemberDrawer> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error silently or show toast
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    AuthSessionStore? authStore;
    LocaleStore? localeStore;
    try {
      authStore = context.watch<AuthSessionStore>();
    } catch (_) {
      authStore = null;
    }
    try {
      localeStore = context.watch<LocaleStore>();
    } catch (_) {
      localeStore = null;
    }

    final session = authStore?.state.session;
    final accountName =
        (session?.name ?? '').isNotEmpty
            ? session!.name
            : l10n.member_drawer_greeting;
    final avatarLetter =
        accountName.trim().isNotEmpty
            ? accountName.trim().substring(0, 1).toUpperCase()
            : 'M';

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.purple),
                  accountName: Text(
                    accountName,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: GestureDetector(
                    onTap: () {
                      context.pop(); // Close drawer
                      context.push('/member/profile');
                    },
                    child: Text(
                      l10n.member_drawer_view_profile,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      avatarLetter,
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (localeStore != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: LanguageSelector(),
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.purple,
                  ),
                  title: Text(l10n.member_drawer_notifications),
                  onTap: () {
                    context.pop();
                    // TODO: Navigate to notifications
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: AppColors.purple,
                  ),
                  title: Text(l10n.member_drawer_profile),
                  onTap: () {
                    context.pop();
                    context.push('/member/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.purple,
                  ),
                  title: Text(l10n.member_drawer_settings),
                  onTap: () {
                    context.pop();
                    context.push('/member/settings');
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    l10n.member_drawer_legal_section,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.grey,
                  ),
                  title: Text(l10n.member_drawer_privacy_policy),
                  onTap:
                      () => _launchUrl(
                        'https://gloriafinance.com.br/privacy-policy',
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.grey),
                  title: Text(l10n.member_drawer_sensitive_data),
                  onTap:
                      () => _launchUrl(
                        'https://gloriafinance.com.br/sensitive-data-policy',
                      ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: Colors.grey,
                  ),
                  title: Text(l10n.member_drawer_terms),
                  onTap:
                      () => _launchUrl(
                        'https://gloriafinance.com.br/terms-of-use',
                      ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    l10n.member_drawer_logout,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    final authStore = Provider.of<AuthSessionStore>(
                      context,
                      listen: false,
                    );
                    authStore.logout();
                    context.go('/');
                  },
                ),
              ],
            ),
          ),
          if (_version.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.member_drawer_version(_version),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
