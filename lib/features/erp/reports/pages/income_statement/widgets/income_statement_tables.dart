import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/widgets/statement_category_help.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/income_statement_model.dart';

enum _BreakdownViewMode { cards, table }

class IncomeStatementReportSections extends StatelessWidget {
  final IncomeStatementModel data;

  const IncomeStatementReportSections({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context.l10n.reports_income_breakdown_title),
        const SizedBox(height: 16),
        _breakdownSection(context),
        const SizedBox(height: 40),
        _cashFlowSection(context),
        const SizedBox(height: 40),
        _costCentersSection(context),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.fontTitle,
        color: AppColors.purple,
      ),
    );
  }

  Widget _breakdownSection(BuildContext context) {
    final sections =
        data.breakdownSections
            .where((section) => section.breakdown.isNotEmpty)
            .toList();

    if (sections.isEmpty) {
      return _emptyMessage(context.l10n.reports_income_breakdown_empty);
    }

    if (sections.length == 1) {
      return _buildBreakdownCurrencyContent(
        context,
        sections.first.breakdown,
        sections.first.symbol,
        showHeader: true,
      );
    }

    final orderedSymbols = data.orderedSymbols;
    final orderedSections = [...sections]..sort((a, b) {
      final indexA = orderedSymbols.indexOf(a.symbol);
      final indexB = orderedSymbols.indexOf(b.symbol);
      if (indexA == -1 && indexB == -1) {
        return a.symbol.compareTo(b.symbol);
      }
      if (indexA == -1) {
        return 1;
      }
      if (indexB == -1) {
        return -1;
      }
      return indexA.compareTo(indexB);
    });

    final initialSymbol = orderedSections.first.symbol;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionPanelList.radio(
          initialOpenPanelValue: initialSymbol,
          children:
              orderedSections.map((section) {
                final totals = _calculateBreakdownTotals(section.breakdown);

                return ExpansionPanelRadio(
                  value: section.symbol,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: _buildBreakdownHeader(
                        context: context,
                        symbol: section.symbol,
                        totals: totals,
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _buildBreakdownCurrencyContent(
                      context,
                      section.breakdown,
                      section.symbol,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildBreakdownCurrencyContent(
    BuildContext context,
    List<IncomeStatementBreakdown> breakdown,
    String symbol, {
    bool showHeader = false,
  }) {
    final orderedByImpact = _sortBreakdownByImpact(breakdown);
    final topRows = orderedByImpact.take(5).toList();
    final totals = _calculateBreakdownTotals(breakdown);
    final singleCurrencyView = showHeader;

    var viewMode = _BreakdownViewMode.cards;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (singleCurrencyView) ...[
              _buildBreakdownHeadline(
                context: context,
                symbol: symbol,
                totals: totals,
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                _viewModeButton(
                  label: _viewModeLabel(context, _BreakdownViewMode.cards),
                  icon: Icons.view_module_outlined,
                  active: viewMode == _BreakdownViewMode.cards,
                  onTap:
                      () => setState(() => viewMode = _BreakdownViewMode.cards),
                ),
                const SizedBox(width: 8),
                _viewModeButton(
                  label: _viewModeLabel(context, _BreakdownViewMode.table),
                  icon: Icons.table_chart_outlined,
                  active: viewMode == _BreakdownViewMode.table,
                  onTap:
                      () => setState(() => viewMode = _BreakdownViewMode.table),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (viewMode == _BreakdownViewMode.cards)
              _buildRankingList(context, topRows, symbol)
            else
              _buildBreakdownTable(context, breakdown, symbol),
          ],
        );
      },
    );
  }

  Widget _viewModeButton({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color:
              active
                  ? AppColors.purple.withValues(alpha: 0.12)
                  : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.purple : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? AppColors.purple : Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: active ? AppColors.purple : Colors.black87,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _viewModeLabel(BuildContext context, _BreakdownViewMode mode) {
    return mode == _BreakdownViewMode.cards
        ? context.l10n.reports_income_view_mode_cards
        : context.l10n.reports_income_view_mode_table;
  }

  Widget _buildBreakdownTable(
    BuildContext context,
    List<IncomeStatementBreakdown> breakdown,
    String symbol,
  ) {
    final orderedRows = _sortBreakdownRows(breakdown);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomTable(
        headers: [
          context.l10n.reports_income_breakdown_header_category,
          context.l10n.reports_income_breakdown_header_income,
          context.l10n.reports_income_breakdown_header_expenses,
          context.l10n.reports_income_breakdown_header_balance,
        ],
        data: FactoryDataTable<IncomeStatementBreakdown>(
          data: orderedRows,
          dataBuilder: (row) {
            final netText = _StyledText(
              text: _formatCurrency(row.net, symbol: symbol),
              isNegative: row.net < 0,
            );

            return [
              _buildCategoryCell(context, row),
              _StyledText(text: _formatCurrency(row.income, symbol: symbol)),
              _StyledText(text: _formatCurrency(row.expenses, symbol: symbol)),
              netText,
            ];
          },
        ),
        dataRowMinHeight: 30,
        dataRowMaxHeight: 52,
      ),
    );
  }

  Widget _buildBreakdownHeader({
    required BuildContext context,
    required String symbol,
    required _BreakdownTotals totals,
  }) {
    final netColor =
        totals.net > 0
            ? const Color(0xFF1B998B)
            : totals.net < 0
            ? const Color(0xFFD62839)
            : Colors.black54;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          symbol,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        _summaryChip(
          label: context.l10n.reports_income_breakdown_header_income,
          value: _formatCurrency(totals.income, symbol: symbol),
        ),
        _summaryChip(
          label: context.l10n.reports_income_breakdown_header_expenses,
          value: _formatCurrency(totals.expenses, symbol: symbol),
        ),
        _summaryChip(
          label: context.l10n.reports_income_breakdown_header_balance,
          value: _formatCurrency(totals.net, symbol: symbol),
          textColor: netColor,
        ),
      ],
    );
  }

  Widget _buildBreakdownHeadline({
    required BuildContext context,
    required String symbol,
    required _BreakdownTotals totals,
  }) {
    final netColor =
        totals.net > 0
            ? const Color(0xFF1B998B)
            : totals.net < 0
            ? const Color(0xFFD62839)
            : Colors.black87;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  symbol,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                '${context.l10n.reports_income_cashflow_header_balance}: ${_formatCurrency(totals.net, symbol: symbol)}',
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: netColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${context.l10n.reports_income_breakdown_header_income}: ${_formatCurrency(totals.income, symbol: symbol)} • ${context.l10n.reports_income_breakdown_header_expenses}: ${_formatCurrency(totals.expenses, symbol: symbol)}',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip({
    required String label,
    required String value,
    Color textColor = Colors.black87,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildRankingList(
    BuildContext context,
    List<IncomeStatementBreakdown> rows,
    String symbol,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final columns = isMobile(context) ? 1 : 2;
        final cardWidth =
            (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              rows
                  .map(
                    (row) => SizedBox(
                      width: cardWidth,
                      child: _buildTopCategoryCard(context, row, symbol),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildTopCategoryCard(
    BuildContext context,
    IncomeStatementBreakdown row,
    String symbol,
  ) {
    final mobile = isMobile(context);
    final netColor =
        row.net > 0
            ? const Color(0xFF1B998B)
            : row.net < 0
            ? const Color(0xFFD62839)
            : Colors.black54;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(31, 218, 216, 216),
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          row.category.friendlyName(context.l10n),
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _quickHelpButton(context, row.category),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Text(
                      row.category.description(context.l10n),
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    if (mobile) ...[
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(row.net, symbol: symbol),
                        style: TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 16,
                          color: netColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!mobile) ...[
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrency(row.net, symbol: symbol),
                      style: TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 16,
                        color: netColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          _miniMetric(
            context.l10n.reports_income_breakdown_header_income,
            _formatCurrency(row.income, symbol: symbol),
          ),
          const SizedBox(height: 2),
          _miniMetric(
            context.l10n.reports_income_breakdown_header_expenses,
            _formatCurrency(row.expenses, symbol: symbol),
          ),
        ],
      ),
    );
  }

  Widget _quickHelpButton(
    BuildContext context,
    IncomeStatementCategory category,
  ) {
    final help = _categoryHelpText(context, category);
    return StatementCategoryHelpButton(
      dialogTitle: help.title,
      entries: [help],
      closeText: context.l10n.common_cancel,
      backgroundColor: const Color.fromARGB(255, 255, 207, 117),
      iconColor: Colors.black87,
      iconSize: 14,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      showEntryHeading: false,
    );
  }

  StatementCategoryHelpEntry _categoryHelpText(
    BuildContext context,
    IncomeStatementCategory category,
  ) {
    switch (category) {
      case IncomeStatementCategory.revenue:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body: context.l10n.reports_income_category_help_revenue_body,
        );
      case IncomeStatementCategory.cogs:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body: context.l10n.reports_income_category_help_cogs_body,
        );
      case IncomeStatementCategory.opex:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body: context.l10n.reports_income_category_help_opex_body,
        );
      case IncomeStatementCategory.ministry_transfers:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body:
              context.l10n.reports_income_category_help_ministry_transfers_body,
        );
      case IncomeStatementCategory.capex:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body: context.l10n.reports_income_category_help_capex_body,
        );
      case IncomeStatementCategory.other:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body: context.l10n.reports_income_category_help_other_body,
        );
      case IncomeStatementCategory.unknown:
        return StatementCategoryHelpEntry(
          title: category.friendlyName(context.l10n),
          body: context.l10n.reports_income_category_help_unknown_body,
        );
    }
  }

  Widget _miniMetric(
    String label,
    String value, {
    Color color = Colors.black87,
  }) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: Colors.black54,
        ),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCell(
    BuildContext context,
    IncomeStatementBreakdown row,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.category.friendlyName(context.l10n),
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            row.category.description(context.l10n),
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12,
              height: 1.4,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashFlowSection(BuildContext context) {
    final groups = data.availabilityAccountsGrouped;
    final totalsBySymbol = data.availabilityTotalsBySymbol;
    final symbols = _orderedSymbols(
      groups.keys.toSet().union(totalsBySymbol.keys.toSet()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context.l10n.reports_income_cashflow_title),
        const SizedBox(height: 8),
        if (symbols.isNotEmpty) ...[
          ...symbols.map((symbol) {
            final total =
                totalsBySymbol[symbol] ?? _buildAvailabilityTotal(symbol);
            final text = _cashFlowTotalsText(
              context,
              symbol: symbol,
              income: total.income,
              expenses: total.expenses,
              balance: total.total,
              includeSymbolPrefix: symbols.length > 1,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  color: Colors.black54,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
        symbols.isEmpty
            ? _emptyMessage(context.l10n.reports_income_cashflow_empty)
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  symbols.map((symbol) {
                    final accounts = <AvailabilityAccountEntry>[
                      ...(groups[symbol] ?? const <AvailabilityAccountEntry>[]),
                    ]..sort(
                      (a, b) => a.availabilityAccount.accountName.compareTo(
                        b.availabilityAccount.accountName,
                      ),
                    );

                    if (accounts.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (symbols.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _currencySubheader(symbol),
                            ),
                          _availabilityTable(
                            context,
                            accounts,
                            showSymbolBadge: symbols.length > 1,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
      ],
    );
  }

  Widget _availabilityTable(
    BuildContext context,
    List<AvailabilityAccountEntry> accounts, {
    required bool showSymbolBadge,
  }) {
    return CustomTable(
      headers: [
        context.l10n.reports_income_cashflow_header_account,
        context.l10n.reports_income_cashflow_header_income,
        context.l10n.reports_income_cashflow_header_expenses,
        context.l10n.reports_income_cashflow_header_balance,
      ],
      data: FactoryDataTable<AvailabilityAccountEntry>(
        data: accounts,
        dataBuilder: (item) {
          final symbol = item.availabilityAccount.symbol;
          final accountLabel =
              showSymbolBadge
                  ? '${item.availabilityAccount.accountName} [$symbol]'
                  : item.availabilityAccount.accountName;

          return [
            Text(
              accountLabel,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.black87,
              ),
            ),
            _StyledText(text: _formatCurrency(item.totalInput, symbol: symbol)),
            _StyledText(
              text: _formatCurrency(item.totalOutput, symbol: symbol),
            ),
            _StyledText(
              text: _formatCurrency(item.balance, symbol: symbol),
              isNegative: item.balance < 0,
            ),
          ];
        },
      ),
    );
  }

  Widget _costCentersSection(BuildContext context) {
    final groups = data.costCentersGrouped;
    final totalsBySymbol = data.costCenterTotalsBySymbol;
    final symbols = _orderedSymbols(
      groups.keys.toSet().union(totalsBySymbol.keys.toSet()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context.l10n.reports_income_cost_centers_title),
        const SizedBox(height: 8),
        if (symbols.isNotEmpty) ...[
          ...symbols.map((symbol) {
            final total =
                totalsBySymbol[symbol]?.total ??
                _calculateCostCentersTotal(symbol);
            final text = context.l10n.reports_income_cost_centers_total_applied(
              _formatCurrency(total, symbol: symbol),
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  color: Colors.black54,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
        symbols.isEmpty
            ? _emptyMessage(context.l10n.reports_income_cost_centers_empty)
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  symbols.map((symbol) {
                    final rows = <CostCenterUsage>[
                      ...(groups[symbol] ?? const <CostCenterUsage>[]),
                    ]..sort((a, b) => b.total.compareTo(a.total));

                    if (rows.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (symbols.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _currencySubheader(symbol),
                            ),
                          _costCentersTable(context, rows, symbol),
                        ],
                      ),
                    );
                  }).toList(),
            ),
      ],
    );
  }

  Widget _costCentersTable(
    BuildContext context,
    List<CostCenterUsage> rows,
    String symbol,
  ) {
    return CustomTable(
      headers: [
        context.l10n.reports_income_cost_centers_header_name,
        context.l10n.reports_income_cost_centers_header_total,
        context.l10n.reports_income_cost_centers_header_last_move,
      ],
      data: FactoryDataTable<CostCenterUsage>(
        data: rows,
        dataBuilder: (item) {
          return [
            Text(
              item.costCenter.costCenterName,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.black87,
              ),
            ),
            _StyledText(text: _formatCurrency(item.total, symbol: symbol)),
            _StyledText(text: _formatDateTime(item.lastMove)),
          ];
        },
      ),
    );
  }

  List<IncomeStatementBreakdown> _sortBreakdownRows(
    List<IncomeStatementBreakdown> rows,
  ) {
    const categoryOrder = {
      IncomeStatementCategory.revenue: 0,
      IncomeStatementCategory.cogs: 1,
      IncomeStatementCategory.opex: 2,
      IncomeStatementCategory.ministry_transfers: 3,
      IncomeStatementCategory.capex: 4,
      IncomeStatementCategory.other: 5,
      IncomeStatementCategory.unknown: 6,
    };

    final ordered = [...rows];
    ordered.sort((a, b) {
      final orderA = categoryOrder[a.category] ?? 999;
      final orderB = categoryOrder[b.category] ?? 999;
      return orderA.compareTo(orderB);
    });
    return ordered;
  }

  List<IncomeStatementBreakdown> _sortBreakdownByImpact(
    List<IncomeStatementBreakdown> rows,
  ) {
    final ordered = [...rows];
    ordered.sort((a, b) => b.net.abs().compareTo(a.net.abs()));
    return ordered;
  }

  _BreakdownTotals _calculateBreakdownTotals(
    List<IncomeStatementBreakdown> rows,
  ) {
    double income = 0;
    double expenses = 0;
    double net = 0;

    for (final row in rows) {
      income += row.income;
      expenses += row.expenses;
      net += row.net;
    }

    return _BreakdownTotals(income: income, expenses: expenses, net: net);
  }

  AvailabilityAccountsTotal _buildAvailabilityTotal(String symbol) {
    final rows = data.availabilityAccountsGrouped[symbol] ?? [];
    double income = 0;
    double expenses = 0;
    for (final row in rows) {
      income += row.totalInput;
      expenses += row.totalOutput;
    }

    return AvailabilityAccountsTotal(
      symbol: symbol,
      total: income - expenses,
      income: income,
      expenses: expenses,
    );
  }

  String _cashFlowTotalsText(
    BuildContext context, {
    required String symbol,
    required double income,
    required double expenses,
    required double balance,
    required bool includeSymbolPrefix,
  }) {
    final baseText =
        '${context.l10n.reports_income_cashflow_header_income}: ${_formatCurrency(income, symbol: symbol)} | '
        '${context.l10n.reports_income_cashflow_header_expenses}: ${_formatCurrency(expenses, symbol: symbol)} | '
        '${context.l10n.reports_income_cashflow_header_balance}: ${_formatCurrency(balance, symbol: symbol)}';

    if (!includeSymbolPrefix) {
      return baseText;
    }

    return '$symbol — $baseText';
  }

  double _calculateCostCentersTotal(String symbol) {
    final rows = data.costCentersGrouped[symbol] ?? [];
    return rows.fold(0, (sum, item) => sum + item.total);
  }

  List<String> _orderedSymbols(Set<String> symbols) {
    final ordered = data.orderedSymbols.where(symbols.contains).toList();
    final remaining =
        symbols.where((item) => !ordered.contains(item)).toList()..sort();
    ordered.addAll(remaining);
    return ordered;
  }

  Widget _currencySubheader(String symbol) {
    return Text(
      symbol,
      style: const TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _emptyMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black45,
        ),
      ),
    );
  }

  String _formatCurrency(double value, {String? symbol}) {
    final formatted = CurrencyFormatter.formatCurrency(
      value.abs(),
      symbol: symbol,
    );
    return value < 0 ? '($formatted)' : formatted;
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) {
      return '-';
    }

    final localDate = value.toLocal();
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(localDate);
  }
}

class _BreakdownTotals {
  final double income;
  final double expenses;
  final double net;

  _BreakdownTotals({
    required this.income,
    required this.expenses,
    required this.net,
  });
}

class _StyledText extends StatelessWidget {
  final String text;
  final bool isNegative;

  const _StyledText({required this.text, this.isNegative = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.fontSubTitle,
        color: isNegative ? const Color(0xFFD62839) : Colors.black54,
        fontWeight: isNegative ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
