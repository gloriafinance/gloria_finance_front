import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      Text(
        'Dashboard', textAlign: TextAlign.left,
        // Esto asegura que el texto no esté centrado
        style: TextStyle(
          fontFamily: AppFonts.fontMedium,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      screen: Column(
        children: [
          Text("Home Screen"),
        ],
      ),
    );
  }
}
