import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
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
        children: [_buildTitle(context), _buildContent()],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.l10n.erp_menu_reports_income_statement,
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
                  _buildReportHeader(context, data),
                  const SizedBox(height: 28),
                  if (!data.hasSummary)
                    _buildEmptyState(context)
                  else ...[
                    IncomeStatementSummaryPanel(data: data),
                    const SizedBox(height: 40),
                    IncomeStatementReportSections(data: data),
                  ],
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader(BuildContext context, IncomeStatementModel data) {
    final symbols = data.orderedSymbols;
    final hasManyCurrencies = symbols.length > 1;
    final currencyLabel = context.l10n.reports_income_currency_badge(
      symbols.join(', '),
      symbols.length.toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(
          context.l10n.reports_income_statement_monthly_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        if (hasManyCurrencies) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              currencyLabel,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.reports_income_multi_currency_disclaimer,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDEE2E6)),
      ),
      child: Text(
        context.l10n.reports_income_empty_selected_period,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black45,
        ),
      ),
    );
  }
}
