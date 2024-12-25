import 'package:church_finance_bk/layout_dashboard.dart';
import 'package:flutter/material.dart';

import 'widgets/contribution_table.dart';

class ContributionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      'Lista de contribuições',
      screen: ContributionTable(),
    );
  }
}
