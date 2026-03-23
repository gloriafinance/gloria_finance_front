import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
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
          create: (_) => ContributionPaginationStore()..searchContributions(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          ContributionFilters(),
          ContributionTable(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Text(
      context.l10n.contributions_list_title,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }
}
