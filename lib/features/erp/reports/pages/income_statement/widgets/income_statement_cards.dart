import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

import '../models/income_statement_model.dart';

class IncomeStatementSummaryPanel extends StatelessWidget {
  final IncomeStatementModel data;

  const IncomeStatementSummaryPanel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _SummaryCardData(
        title: l10n.reports_income_summary_net_revenue_title,
        description: l10n.reports_income_summary_net_revenue_desc,
        amount: data.summary.revenue,
        accent: AppColors.blue,
      ),
      _SummaryCardData(
        title: l10n.reports_income_summary_operating_expenses_title,
        description: l10n.reports_income_summary_operating_expenses_desc,
        amount: data.summary.operatingExpenses,
        accent: const Color(0xFF495057),
      ),
      _SummaryCardData(
        title: l10n.reports_income_summary_operating_income_title,
        description: l10n.reports_income_summary_operating_income_desc,
        amount: data.summary.operatingIncome,
        accent: const Color(0xFF5C6BC0),
      ),
      _SummaryCardData(
        title: l10n.reports_income_summary_net_income_title,
        description: l10n.reports_income_summary_net_income_desc,
        amount: data.summary.netIncome,
        accent:
            data.summary.netIncome >= 0
                ? AppColors.green
                : const Color(0xFFD62839),
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((item) => _SummaryCard(data: item)).toList(),
    );
  }
}

class _SummaryCardData {
  final String title;
  final String description;
  final double amount;
  final Color accent;

  _SummaryCardData({
    required this.title,
    required this.description,
    required this.amount,
    required this.accent,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final amountText = _formatCurrency(data.amount);
    final isNegative = data.amount < 0;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: data.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            amountText,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 22,
              color: isNegative ? const Color(0xFFD62839) : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              height: 1.4,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    final formatted = CurrencyFormatter.formatCurrency(value.abs());
    return value < 0 ? '($formatted)' : formatted;
  }
}
