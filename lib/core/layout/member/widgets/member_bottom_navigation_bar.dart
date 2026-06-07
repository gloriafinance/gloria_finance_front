import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:go_router/go_router.dart';

class MemberBottomNavigationBar extends StatelessWidget {
  const MemberBottomNavigationBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/dashboard' || location.startsWith('/member/home')) {
      return 0;
    }
    if (location.startsWith('/member/contribute')) return 1;
    if (location.startsWith('/member/commitments')) return 2;
    // Profile lives in the drawer, not in the bottom bar.
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final int selectedIndex = _calculateSelectedIndex(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: AppColors.purple,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: AppFonts.fontTitle,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: AppFonts.fontText,
      ),
      elevation: 5,

      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, color: Colors.white70),
          activeIcon: Icon(Icons.home_filled, color: Colors.white),
          label: l10n.member_shell_nav_home,
          backgroundColor: Colors.white70,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism_outlined, color: Colors.white70),
          activeIcon: Icon(Icons.volunteer_activism, color: Colors.white),
          label: l10n.member_shell_nav_contribute,
          backgroundColor: Colors.white70,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note, color: Colors.white70),
          activeIcon: Icon(Icons.event_note, color: Colors.white),
          label: l10n.member_shell_nav_commitments,
          backgroundColor: Colors.white70,
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.person_2_outlined, color: Colors.white70),
        //   activeIcon: Icon(Icons.person, color: Colors.white),
        //   label: l10n.member_drawer_profile,
        //   backgroundColor: Colors.white70,
        // ),
      ],
      onTap: (index) => _onItemTapped(index, context),
      type: BottomNavigationBarType.fixed,
    );
  }
}
