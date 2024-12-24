import 'package:church_finance_bk/LayoutDashboard.dart';
import 'package:flutter/material.dart';

class FinancialMovementsScreen extends StatelessWidget {
  const FinancialMovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      screen: Container(
        child: Center(
          child: Text('Financial Movements Screen'),
        ),
      ),
    );
  }
}
