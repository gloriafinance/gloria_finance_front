import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../store/contribution_pagination_store.dart';
import 'widgets/contribution_filters.dart';
import 'widgets/contribution_table.dart';

class ContributionsListScreen extends StatelessWidget {
  const ContributionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                ContributionPaginationStore()..searchContributions()),
      ],
      child: LayoutDashboard(
        _header(context),
        screen: Column(
          children: [
            ContributionFilters(),
            ContributionTable(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Lista de contribuições',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _buttons(context),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      children: [
        ButtonActionTable(
            color: AppColors.purple,
            text: "Registrar contribuição",
            onPressed: () => GoRouter.of(context).go('/contributions_list/add'),
            icon: Icons.add_reaction_outlined),
      ],
    );
  }
}
