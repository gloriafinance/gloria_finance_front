import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'store/income_statement_store.dart';
import 'widgets/income_statement_cards.dart';
import 'widgets/income_statement_filters.dart';
import 'widgets/income_statement_tables.dart';

class IncomeStatementScreen extends StatelessWidget {
  const IncomeStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => IncomeStatementStore()..fetchIncomeStatement(),
      child: LayoutDashboard(
        _buildTitle(),
        screen: _buildContent(),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Estado de Ingresos',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<IncomeStatementStore>(
      builder: (context, store, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filtros
                IncomeStatementFilters(),
                SizedBox(height: 32),

                // Tarjetas de resumen
                IncomeStatementCards(),
                SizedBox(height: 40),

                // Tablas de datos
                IncomeStatementTables(),
              ],
            ),
          ),
        );
      },
    );
  }
}
