import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/financial_months/store/financial_month_store.dart';
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
            SizedBox(height: 24),
            FinancialMonthTable(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const Expanded(
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
        _buildYearSelector(),
      ],
    );
  }

  Widget _buildYearSelector() {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (index) => currentYear - 5 + index);

    return Consumer<FinancialMonthStore>(
      builder: (context, store, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyMiddle),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            value: store.state.selectedYear,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.purple),
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.black87,
              fontSize: 16,
            ),
            items: years.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                store.setYear(value);
              }
            },
          ),
        );
      },
    );
  }
}
