import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

import '../models/dre_model.dart';

class DRECards extends StatefulWidget {
  final DREReportModel data;

  const DRECards({super.key, required this.data});

  @override
  State<DRECards> createState() => _DRECardsState();
}

class _DRECardsState extends State<DRECards> {
  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  Widget build(BuildContext context) {
    final itemBySymbol = widget.data.itemBySymbol;
    final sections =
        widget.data.orderedSymbols
            .where(itemBySymbol.containsKey)
            .map((symbol) => itemBySymbol[symbol]!)
            .toList();
    final useAccordion = widget.data.currencyCount >= 5 && sections.length > 1;

    for (final section in sections) {
      _sectionKeys.putIfAbsent(section.symbol, GlobalKey.new);
    }

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MultiCurrencySummaryPanel(
          sections: sections,
          onSymbolTap: _scrollToSymbol,
        ),
        const SizedBox(height: 20),
        if (useAccordion)
          _SymbolAccordionList(sections: sections, sectionKeys: _sectionKeys)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                sections
                    .map(
                      (item) => Padding(
                        key: _sectionKeys[item.symbol],
                        padding: const EdgeInsets.only(bottom: 28),
                        child: _DRESymbolSection(data: item),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }

  void _scrollToSymbol(String symbol) {
    final context = _sectionKeys[symbol]?.currentContext;
    if (context == null) {
      return;
    }
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }
}

class _MultiCurrencySummaryPanel extends StatelessWidget {
  final List<DREBySymbolModel> sections;
  final ValueChanged<String> onSymbolTap;

  const _MultiCurrencySummaryPanel({
    required this.sections,
    required this.onSymbolTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.reports_dre_summary_by_currency_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                sections
                    .map(
                      (item) => _CurrencyChip(
                        data: item,
                        onTap: () => onSymbolTap(item.symbol),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final DREBySymbolModel data;
  final VoidCallback onTap;

  const _CurrencyChip({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  data.symbol,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.reports_dre_summary_chip_gross_revenue(
                _formatCurrency(data.grossRevenue, data.symbol),
              ),
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.reports_dre_summary_chip_net_result(
                _formatCurrency(data.netResult, data.symbol),
              ),
              style: TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color:
                    data.netResult < 0
                        ? const Color(0xFFD62839)
                        : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value, String symbol) {
    final formatted = CurrencyFormatter.formatCurrency(
      value.abs(),
      symbol: symbol,
    );
    return value < 0 ? '($formatted)' : formatted;
  }
}

class _SymbolAccordionList extends StatelessWidget {
  final List<DREBySymbolModel> sections;
  final Map<String, GlobalKey> sectionKeys;

  const _SymbolAccordionList({
    required this.sections,
    required this.sectionKeys,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: sections.first.symbol,
      children:
          sections.map((section) {
            return ExpansionPanelRadio(
              value: section.symbol,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Container(
                    key: sectionKeys[section.symbol],
                    child: Text(
                      section.symbol,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _DRESymbolSection(data: section, showSymbolTitle: false),
              ),
            );
          }).toList(),
    );
  }
}

class _DRESymbolSection extends StatefulWidget {
  final DREBySymbolModel data;
  final bool showSymbolTitle;

  const _DRESymbolSection({required this.data, this.showSymbolTitle = true});

  @override
  State<_DRESymbolSection> createState() => _DRESymbolSectionState();
}

class _DRESymbolSectionState extends State<_DRESymbolSection> {
  bool _hideZeroLines = false;
  late final Map<String, bool> _expandedByGroup = {
    'revenue': true,
    'costs': true,
    'results': true,
  };

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showSymbolTitle) ...[
          Text(
            context.l10n.reports_dre_section_title_by_symbol(data.symbol),
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.reports_dre_section_subtitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
        ],
        Text(
          context.l10n.reports_dre_main_indicators_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _mainIndicators(context, data),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.reports_dre_detail_by_category,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                  context.l10n.reports_dre_toggle_hide_zero,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _hideZeroLines,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.purple;
                    }
                    return null;
                  }),
                  onChanged: (value) => setState(() => _hideZeroLines = value),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        _detailAccordion(context, data),
      ],
    );
  }

  Widget _mainIndicators(BuildContext context, DREBySymbolModel data) {
    final cards = [
      _MainCardData(
        title: context.l10n.reports_dre_card_gross_revenue_title,
        description: context.l10n.reports_dre_card_gross_revenue_description,
        value: data.grossRevenue,
        accent: AppColors.green,
        helpMeaning: context.l10n.reports_dre_help_gross_revenue_meaning,
        helpExample: context.l10n.reports_dre_help_gross_revenue_example,
      ),
      _MainCardData(
        title: context.l10n.reports_dre_card_operational_result_title,
        description:
            context.l10n.reports_dre_card_operational_result_description,
        value: data.operationalResult,
        accent: AppColors.blue,
        helpMeaning: context.l10n.reports_dre_help_operational_result_meaning,
        helpExample: context.l10n.reports_dre_help_operational_result_example,
      ),
      _MainCardData(
        title: context.l10n.reports_dre_card_net_result_title,
        description: context.l10n.reports_dre_card_net_result_description,
        value: data.netResult,
        accent: data.netResult >= 0 ? AppColors.green : const Color(0xFFD62839),
        helpMeaning: context.l10n.reports_dre_help_net_result_meaning,
        helpExample: context.l10n.reports_dre_help_net_result_example,
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          cards
              .map(
                (item) => _MainIndicatorCard(data: item, symbol: data.symbol),
              )
              .toList(),
    );
  }

  Widget _detailAccordion(BuildContext context, DREBySymbolModel data) {
    final groups = _buildGroups(context, data);
    final filteredGroups =
        groups
            .map((group) {
              final rows =
                  _hideZeroLines
                      ? group.rows.where((row) => row.value != 0).toList()
                      : group.rows;
              return _DetailGroupData(
                id: group.id,
                title: group.title,
                rows: rows,
              );
            })
            .where((group) => group.rows.isNotEmpty)
            .toList();

    return ExpansionPanelList(
      expansionCallback: (index, expanded) {
        final groupId = filteredGroups[index].id;
        setState(() {
          _expandedByGroup[groupId] = !expanded;
        });
      },
      children:
          filteredGroups.map((group) {
            final subtotal = group.rows.fold<double>(
              0,
              (sum, row) => sum + row.value,
            );

            return ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: _expandedByGroup[group.id] ?? true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    group.title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: Text(
                    _formatCurrency(subtotal, data.symbol),
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 14,
                      color:
                          subtotal < 0
                              ? const Color(0xFFD62839)
                              : Colors.black87,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children:
                      group.rows
                          .map(
                            (row) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.greyLight.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            row.title,
                                            style: const TextStyle(
                                              fontFamily: AppFonts.fontSubTitle,
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        _HelpChip(
                                          title: row.title,
                                          meaning: row.helpMeaning,
                                          example: row.helpExample,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _formatCurrency(row.value, data.symbol),
                                    style: TextStyle(
                                      fontFamily: AppFonts.fontTitle,
                                      fontSize: 14,
                                      color:
                                          row.value < 0
                                              ? const Color(0xFFD62839)
                                              : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            );
          }).toList(),
    );
  }

  List<_DetailGroupData> _buildGroups(
    BuildContext context,
    DREBySymbolModel data,
  ) {
    return [
      _DetailGroupData(
        id: 'revenue',
        title: context.l10n.reports_dre_group_revenue,
        rows: [
          _DetailRowData(
            title: context.l10n.reports_dre_card_gross_revenue_title,
            value: data.grossRevenue,
            helpMeaning: context.l10n.reports_dre_help_gross_revenue_meaning,
            helpExample: context.l10n.reports_dre_help_gross_revenue_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_item_net_revenue_title,
            value: data.netRevenue,
            helpMeaning: context.l10n.reports_dre_help_net_revenue_meaning,
            helpExample: context.l10n.reports_dre_help_net_revenue_example,
          ),
        ],
      ),
      _DetailGroupData(
        id: 'costs',
        title: context.l10n.reports_dre_group_costs,
        rows: [
          _DetailRowData(
            title: context.l10n.reports_dre_item_direct_costs_title,
            value: data.directCosts,
            helpMeaning: context.l10n.reports_dre_help_direct_costs_meaning,
            helpExample: context.l10n.reports_dre_help_direct_costs_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_item_operational_expenses_title,
            value: data.operationalExpenses,
            helpMeaning:
                context.l10n.reports_dre_help_operational_expenses_meaning,
            helpExample:
                context.l10n.reports_dre_help_operational_expenses_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_item_ministry_transfers_title,
            value: data.ministryTransfers,
            helpMeaning:
                context.l10n.reports_dre_help_ministry_transfers_meaning,
            helpExample:
                context.l10n.reports_dre_help_ministry_transfers_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_item_capex_title,
            value: data.capexInvestments,
            helpMeaning: context.l10n.reports_dre_help_capex_meaning,
            helpExample: context.l10n.reports_dre_help_capex_example,
          ),
        ],
      ),
      _DetailGroupData(
        id: 'results',
        title: context.l10n.reports_dre_group_results,
        rows: [
          _DetailRowData(
            title: context.l10n.reports_dre_item_gross_profit_title,
            value: data.grossProfit,
            helpMeaning: context.l10n.reports_dre_help_gross_profit_meaning,
            helpExample: context.l10n.reports_dre_help_gross_profit_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_card_operational_result_title,
            value: data.operationalResult,
            helpMeaning:
                context.l10n.reports_dre_help_operational_result_meaning,
            helpExample:
                context.l10n.reports_dre_help_operational_result_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_item_extraordinary_title,
            value: data.extraordinaryResults,
            helpMeaning: context.l10n.reports_dre_help_extraordinary_meaning,
            helpExample: context.l10n.reports_dre_help_extraordinary_example,
          ),
          _DetailRowData(
            title: context.l10n.reports_dre_card_net_result_title,
            value: data.netResult,
            helpMeaning: context.l10n.reports_dre_help_net_result_meaning,
            helpExample: context.l10n.reports_dre_help_net_result_example,
          ),
        ],
      ),
    ];
  }

  String _formatCurrency(double value, String symbol) {
    final formatted = CurrencyFormatter.formatCurrency(
      value.abs(),
      symbol: symbol,
    );
    return value < 0 ? '($formatted)' : formatted;
  }
}

class _MainCardData {
  final String title;
  final String description;
  final double value;
  final Color accent;
  final String helpMeaning;
  final String helpExample;

  _MainCardData({
    required this.title,
    required this.description,
    required this.value,
    required this.accent,
    required this.helpMeaning,
    required this.helpExample,
  });
}

class _MainIndicatorCard extends StatelessWidget {
  final _MainCardData data;
  final String symbol;

  const _MainIndicatorCard({required this.data, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              _HelpChip(
                title: data.title,
                meaning: data.helpMeaning,
                example: data.helpExample,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatCurrency(data.value, symbol),
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 22,
              color: data.value < 0 ? const Color(0xFFD62839) : Colors.black,
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

  String _formatCurrency(double value, String symbol) {
    final formatted = CurrencyFormatter.formatCurrency(
      value.abs(),
      symbol: symbol,
    );
    return value < 0 ? '($formatted)' : formatted;
  }
}

class _DetailGroupData {
  final String id;
  final String title;
  final List<_DetailRowData> rows;

  _DetailGroupData({required this.id, required this.title, required this.rows});
}

class _DetailRowData {
  final String title;
  final double value;
  final String helpMeaning;
  final String helpExample;

  _DetailRowData({
    required this.title,
    required this.value,
    required this.helpMeaning,
    required this.helpExample,
  });
}

class _HelpChip extends StatelessWidget {
  final String title;
  final String meaning;
  final String example;

  const _HelpChip({
    required this.title,
    required this.meaning,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showHelpDialog(context),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.mustard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Icon(Icons.help_outline, size: 14, color: Colors.black87),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            context.l10n.reports_dre_help_dialog_title(title),
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.reports_dre_help_what_means,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  meaning,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.reports_dre_help_example,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  example,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.reports_dre_help_understood),
            ),
          ],
        );
      },
    );
  }
}
