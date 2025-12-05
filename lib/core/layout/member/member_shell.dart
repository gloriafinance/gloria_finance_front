import 'package:church_finance_bk/core/layout/member/widgets/member_drawer.dart';
import 'package:church_finance_bk/core/layout/member/widgets/notification_badge.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MemberShell extends StatefulWidget {
  final Widget child;

  const MemberShell({super.key, required this.child});

  @override
  State<MemberShell> createState() => _MemberShellState();
}

class _MemberShellState extends State<MemberShell> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/dashboard' || location.startsWith('/member/home')) return 0;
    if (location.startsWith('/member/contribute')) return 1;
    if (location.startsWith('/member/commitments')) return 2;
    if (location.startsWith('/member/statements')) return 3;
    // Profile is now in Drawer, so no index 4
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/member/contribute');
        break;
      case 2:
        context.go('/member/commitments');
        break;
      case 3:
        context.go('/member/statements');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);
    final l10n = context.l10n;

    return Scaffold(
      //backgroundColor: const Color(0xFFF3E5F5), // Light Purple / Lilac base
      extendBodyBehindAppBar: true,
      drawer: const MemberDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        // Slightly more opaque
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
              l10n.member_shell_header_default_church,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF3E5F5), // Light Purple / Lilac
              Color(0xFFE1BEE7), // Slightly darker Lilac
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: widget.child,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: GNav(
            gap: 8,
            activeColor: AppColors.purple,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.purple.withValues(alpha: 0.1),
            color: Colors.grey,
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: l10n.member_shell_nav_home,
              ),
              GButton(
                icon: Icons.volunteer_activism,
                text: l10n.member_shell_nav_contribute,
              ),
              GButton(
                icon: Icons.event_note,
                text: l10n.member_shell_nav_commitments,
              ),
              GButton(
                icon: Icons.receipt_long,
                text: l10n.member_shell_nav_statements,
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: (index) => _onItemTapped(index, context),
          ),
        ),
      ),
    );
  }
}
