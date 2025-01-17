import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/finance_record_paginate_store.dart';
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
    if (!isMobile(context)) {
      return Row(
        children: [
          Expanded(
            child: Text(
              'Movimentos financeiros',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppFonts.fontMedium,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                _closeMonth(context),
                _generateReport(context),
                _newRecord(context),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Movimentos financeiros',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontMedium,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _closeMonth(context)),
            Expanded(child: _generateReport(context)),
          ],
        ),
        Row(
          children: [
            // Espaço flexível para alinhar os botões à direita
            Expanded(child: _newRecord(context)),
          ],
        ),
      ],
    );
  }

  Widget _newRecord(BuildContext context) {
    return ButtonActionTable(
        color: AppColors.purple,
        text: "Registrar",
        onPressed: () => GoRouter.of(context).go('/financial-record/add'),
        icon: Icons.add_chart);
  }

  Widget _generateReport(BuildContext context) {
    return ButtonActionTable(
        color: AppColors.purple,
        text: "Relatório",
        onPressed: () => {},
        icon: Icons.download);
  }

  Widget _closeMonth(BuildContext context) {
    return ButtonActionTable(
        color: AppColors.purple,
        text: "Fechar mês",
        onPressed: () => {},
        icon: Icons.close_fullscreen_sharp);
  }
}
