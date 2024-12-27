import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/finance/ui/widgets/contribution_filters.dart';
import 'package:church_finance_bk/finance/ui/widgets/contribution_table.dart';
import 'package:flutter/material.dart';

class ContributionsScreen extends StatelessWidget {
  const ContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      'Lista de contribuições',
      screen: Column(
        children: [
          ContributionFilters(),
          ContributionTable(),
        ],
      ),
    );
  }
}
