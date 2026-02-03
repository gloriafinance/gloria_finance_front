import 'package:church_finance_bk/core/layout/member/widgets/member_bottom_navigation_bar.dart';
import 'package:church_finance_bk/core/layout/member/widgets/member_drawer.dart';
import 'package:church_finance_bk/core/layout/member/widgets/notification_badge.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/pages/login/store/auth_session_store.dart';

class MemberShell extends StatefulWidget {
  final Widget child;

  const MemberShell({super.key, required this.child});

  @override
  State<MemberShell> createState() => _MemberShellState();
}

class _MemberShellState extends State<MemberShell> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    AuthSessionStore authStore = context.watch<AuthSessionStore>();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // Light grey base (aligned with other member screens)
      extendBodyBehindAppBar: true,
      drawer: const MemberDrawer(),
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 80,
        // Allow space for Menu + Logo
        leading: Builder(
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                Image.asset('images/applogo.jpg', height: 32),
              ],
            );
          },
        ),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.member_shell_header_tagline,
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                color: Colors.grey[700],
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              // l10n.member_shell_header_default_church,
              authStore.state.session.churchName,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
        actions: [
          NotificationBadge(
            onTap: () {
              // TODO: Handle notification tap
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: widget.child,
        ),
      ),
      bottomNavigationBar: const MemberBottomNavigationBar(),
    );
  }
}
