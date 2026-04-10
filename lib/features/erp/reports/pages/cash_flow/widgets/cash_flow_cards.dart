import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/formatter.dart';

import '../models/cash_flow_model.dart';

class CashFlowSummaryCards extends StatelessWidget {
  final CashFlowSummaryModel summary;
  final String? currencySymbol;

  const CashFlowSummaryCards({
    super.key,
    required this.summary,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryCardData(
        title: context.l10n.reports_cash_flow_kpi_opening_balance,
        value: formatCurrency(summary.openingBalance, symbol: currencySymbol),
        accent: AppColors.blue,
      ),
      _SummaryCardData(
        title: context.l10n.reports_cash_flow_kpi_entries,
        value: formatCurrency(summary.entries, symbol: currencySymbol),
        accent: AppColors.green,
      ),
      _SummaryCardData(
        title: context.l10n.reports_cash_flow_kpi_exits,
        value: formatCurrency(summary.exits, symbol: currencySymbol),
        accent: const Color(0xFFD62839),
      ),
      _SummaryCardData(
        title: context.l10n.reports_cash_flow_kpi_net,
        value: formatCurrency(summary.net, symbol: currencySymbol),
        accent: summary.net >= 0 ? AppColors.green : const Color(0xFFD62839),
      ),
      _SummaryCardData(
        title: context.l10n.reports_cash_flow_kpi_closing_balance,
        value: formatCurrency(summary.closingBalance, symbol: currencySymbol),
        accent: AppColors.purple,
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items
          .map((item) => _SummaryCard(item: item, width: 230))
          .toList(growable: false),
    );
  }
}

class _SummaryCardData {
  final String title;
  final String value;
  final Color accent;

  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.accent,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData item;
  final double width;

  const _SummaryCard({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: item.accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 22,
              color: item.accent,
            ),
          ),
        ],
      ),
    );
  }
}
