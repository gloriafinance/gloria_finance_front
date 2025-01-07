import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../stores/finance_record_paginate_store.dart';
import 'widgets/finance_record_filters.dart';
import 'widgets/finance_record_table.dart';

class FinancialRecordScreen extends StatelessWidget {
  const FinancialRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                FinanceRecordPaginateStore()..searchFinanceRecords()),
      ],
      child: MaterialApp(
        home: LayoutDashboard(
          _header(context),
          screen: Column(
            children: [FinanceRecordFilters(), FinanceRecordTable()],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Movimentos financeiros',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontMedium,
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
            text: "Fechar mês",
            onPressed: () => {},
            icon: Icons.close_fullscreen_sharp),
        ButtonActionTable(
            color: AppColors.purple,
            text: "Relatório",
            onPressed: () => {},
            icon: Icons.download),
        ButtonActionTable(
            color: AppColors.purple,
            text: "Registrar",
            onPressed: () => GoRouter.of(context).go('/financial-record/add'),
            icon: Icons.add_chart),
      ],
    );
  }
}
