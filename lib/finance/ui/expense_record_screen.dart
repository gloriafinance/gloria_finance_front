import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:flutter/material.dart';

class ExpenseRecordScreen extends StatelessWidget {
  const ExpenseRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      'Lista de contribuições',
      screen: Column(
        children: [
          Text('Expense Record Screen'),
        ],
      ),
    );
  }
}
