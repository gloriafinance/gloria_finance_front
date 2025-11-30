import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/finance_record_paginate_store.dart';
import 'widgets/finance_record_export_button.dart';
import 'widgets/finance_record_filters.dart';
import 'widgets/finance_record_table.dart';

class FinancialRecordScreen extends StatelessWidget {
  const FinancialRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FinanceRecordPaginateStore()..searchFinanceRecords(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          FinanceRecordFilters(),
          FinanceRecordTable(),
        ],
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
                fontFamily: AppFonts.fontTitle,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [_generateReport(context), _newRecord(context)],
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
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _generateReport(context)),
            Expanded(child: _newRecord(context)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _newRecord(BuildContext context) {
    return ButtonActionTable(
      color: AppColors.purple,
      text: "Registrar",
      onPressed: () => GoRouter.of(context).go('/financial-record/add'),
      icon: Icons.add_chart,
    );
  }

  Widget _generateReport(BuildContext context) {
    return const FinanceRecordExportButton();
  }
}
