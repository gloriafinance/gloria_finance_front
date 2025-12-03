import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/erp/reports/pages/monthly_tithes/store/monthly_tithes_list_store.dart';
import 'package:church_finance_bk/features/erp/reports/pages/monthly_tithes/widgets/monthly_tithes_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/cards_summary_tithes.dart';
import 'widgets/montlhy_tithes_filters.dart';

class MonthlyTithesScreen extends StatelessWidget {
  const MonthlyTithesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => MonthlyTithesListStore()..searchMonthlyTithes(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.reports_monthly_tithes_title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: Colors.black,
            ),
          ),

          SizedBox(height: 20),
          MonthlyTithesFilters(),
          SizedBox(height: 20),
          CardsSummaryTithes(),
          MonthlyTithesTable(),
        ],
      ),
    );
  }
}
