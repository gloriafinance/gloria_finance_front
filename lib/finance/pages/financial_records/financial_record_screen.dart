import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/finance_concept_store.dart';
import '../../stores/finance_record_paginate_store.dart';
import 'widgets/finance_record_filters.dart';
import 'widgets/finance_record_table.dart';

final financialConceptStore = FinancialConceptStore();

class FinancialRecordScreen extends StatelessWidget {
  const FinancialRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinanceRecordPaginateStore()..searchFinanceRecords(),
      child: MaterialApp(
        home: LayoutDashboard(
          _header(),
          screen: Column(
            children: [FinanceRecordFilters(), FinanceRecordTable()],
          ),
        ),
      ),
    );
  }

  Widget _header() {
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
          child: _buttons(),
        ),
      ],
    );
  }

  // Widget _buttons(WidgetRef ref) {
  Widget _buttons() {
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
            onPressed: () => {},
            //ref.read(appRouterProvider).go("/financial-record/add"),
            icon: Icons.add_chart),
      ],
    );
  }
}
