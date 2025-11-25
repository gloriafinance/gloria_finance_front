import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/trends/widgets/trend_widget.dart';
import 'package:flutter/material.dart';

import 'widgets/availability_account_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      _buildHeader(),
      screen: Column(
        children: [
          AvailabilityAccountCards(),
          const SizedBox(height: 40),
          const TrendWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Dashboard',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
