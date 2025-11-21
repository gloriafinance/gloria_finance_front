import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../theme/app_color.dart';
import '../../theme/app_fonts.dart';
import '../state/navigator_member_state.dart';

class NavigatorMember extends StatefulWidget {
  const NavigatorMember({super.key});

  @override
  State<StatefulWidget> createState() => _NavigatorMember();
}

class _NavigatorMember extends State<NavigatorMember> {
  @override
  Widget build(BuildContext context) {
    final navigatorNotifier = Provider.of<NavigatorMemberNotifier>(context);

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
        child: GNav(
          haptic: true,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: AppColors.mustard,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.purple,
          color: AppColors.purple,
          tabs: [
            _item("Inicio", Icons.home_outlined, "/dashboard"),
            _item(
              "Compromissos",
              Icons.assignment_outlined,
              "/member/commitments",
            ),
            _item("Contribuiçōes", Icons.monetization_on_outlined,
                "/contributions_list"),
            _item("Perfil", Icons.settings_rounded, "/settings"),
          ],
          selectedIndex: navigatorNotifier.selectedIndex,
          onTabChange: (index) {
            navigatorNotifier.setIndexTab(index);
          },
        ),
      ),
    );
  }

  GButton _item(String text, IconData icon, String urlScreen) {
    return GButton(
      icon: icon,
      text: text,
      onPressed: () => context.go(urlScreen),
      textStyle: const TextStyle(
          fontFamily: AppFonts.fontSubTitle, color: AppColors.mustard),
    );
  }
}
