import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

import 'widgets/contribution_filters.dart';
import 'widgets/contribution_table.dart';

class ContributionsScreen extends StatelessWidget {
  const ContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      Text(
        'Lista de contribuições',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: AppFonts.fontMedium,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      screen: Column(
        children: [
          ContributionFilters(),
          ContributionTable(),
        ],
      ),
    );
  }
}
