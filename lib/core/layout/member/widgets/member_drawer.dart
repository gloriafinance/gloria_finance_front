import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
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
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.purple),
                  accountName: const Text(
                    'Membro Exemplo', // TODO: Get from store
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: GestureDetector(
                    onTap: () {
                      context.pop(); // Close drawer
                      context.go('/member/profile');
                    },
                    child: const Text(
                      'Ver meu perfil',
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: const Text(
                      'M',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.purple,
                  ),
                  title: const Text('Notificações'),
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
                  title: const Text('Meu Perfil'),
                  onTap: () {
                    context.pop();
                    context.go('/member/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.purple,
                  ),
                  title: const Text('Configurações'),
                  onTap: () {
                    context.pop();
                    // TODO: Navigate to settings
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                  child: Text(
                    'Legal',
                    style: TextStyle(
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
                  title: const Text('Política de Privacidade'),
                  onTap:
                      () => _launchUrl(
                        'https://gloriafinance.com.br/privacy-policy',
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.grey),
                  title: const Text('Tratamento de Dados'),
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
                  title: const Text('Termos de Uso'),
                  onTap:
                      () => _launchUrl(
                        'https://gloriafinance.com.br/terms-of-use',
                      ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.red),
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
                'Versão $_version',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
