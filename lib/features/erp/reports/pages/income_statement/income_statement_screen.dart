import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/income_statement_model.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTitle(), _buildContent()],
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
        final isLoading = store.state.makeRequest;
        final data = store.state.data;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IncomeStatementFilters(),
                const SizedBox(height: 24),
                if (isLoading)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 80),
                    child: const CircularProgressIndicator(),
                  )
                else ...[
                  _buildReportHeader(data),
                  const SizedBox(height: 28),
                  IncomeStatementSummaryPanel(data: data),
                  const SizedBox(height: 40),
                  IncomeStatementReportSections(data: data),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader(IncomeStatementModel data) {
    final periodText = _formatPeriod(data.period);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(
          'Relatório Financeiro Mensal',
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _formatPeriod(IncomeStatementPeriod period) {
    if (period.month == 0 && period.year == 0) {
      return '-';
    }

    final month = period.month.clamp(1, 12);
    final monthText = month.toString().padLeft(2, '0');
    return '$monthText/${period.year}';
  }
}
