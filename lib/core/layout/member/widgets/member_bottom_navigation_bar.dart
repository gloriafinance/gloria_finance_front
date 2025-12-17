import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MemberBottomNavigationBar extends StatelessWidget {
  const MemberBottomNavigationBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/dashboard' || location.startsWith('/member/home')) {
      return 0;
    }
    if (location.startsWith('/member/contribute')) return 1;
    if (location.startsWith('/member/commitments')) return 2;
    if (location.startsWith('/member/profile')) return 3;
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
        context.go('/member/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final int selectedIndex = _calculateSelectedIndex(context);

    return Container(
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
              icon: Icons.person_pin_sharp,
              text: l10n.member_drawer_profile,
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: (index) => _onItemTapped(index, context),
        ),
      ),
    );
  }
}
