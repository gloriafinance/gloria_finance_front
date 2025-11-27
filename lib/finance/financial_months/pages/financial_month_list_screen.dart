import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/financial_months/store/financial_month_store.dart';
import 'package:church_finance_bk/finance/financial_months/widgets/financial_month_filters.dart';
import 'package:church_finance_bk/finance/financial_months/widgets/financial_month_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinancialMonthListScreen extends StatefulWidget {
  const FinancialMonthListScreen({super.key});

  @override
  State<FinancialMonthListScreen> createState() =>
      _FinancialMonthListScreenState();
}

class _FinancialMonthListScreenState extends State<FinancialMonthListScreen> {
  late FinancialMonthStore _store;

  @override
  void initState() {
    super.initState();
    _store = FinancialMonthStore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _store.loadFinancialMonths();
    });
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _store,
      child: LayoutDashboard(
        _header(context),
        screen: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FinancialMonthFilters(),
            SizedBox(height: 24),
            FinancialMonthTable(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Meses Financeiros',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
