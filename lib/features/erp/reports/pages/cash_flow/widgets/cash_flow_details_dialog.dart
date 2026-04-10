import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/formatter.dart';

import '../models/cash_flow_model.dart';
import '../utils/cash_flow_utils.dart';

Future<void> showCashFlowDetailsDialog(
  BuildContext context,
  CashFlowBucketDetailsModel details,
) {
  final locale = Localizations.localeOf(context).toLanguageTag();

  return ModalPage(
    title: context.l10n.reports_cash_flow_details_title,
    width: 1100,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MetaChip(
              label: context.l10n.reports_cash_flow_details_range(
                '${cashFlowDisplayDate(details.startDate, locale: locale)} - ${cashFlowDisplayDate(details.endDate, locale: locale)}',
              ),
            ),
            _MetaChip(
              label: context.l10n.reports_cash_flow_details_count(
                details.details.length.toString(),
              ),
            ),
          ],
        ),
        if (details.details.isEmpty) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              context.l10n.reports_cash_flow_details_empty,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.black54,
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 20),
          _CashFlowDetailsTable(details: details, locale: locale),
        ],
      ],
    ),
  ).show(context);
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _FlowTypeBadge extends StatelessWidget {
  final String flowType;

  const _FlowTypeBadge({required this.flowType});

  @override
  Widget build(BuildContext context) {
    final isEntry = flowType == 'entry';
    final color = isEntry ? AppColors.green : const Color(0xFFD62839);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isEntry
            ? context.l10n.reports_cash_flow_flow_entry
            : context.l10n.reports_cash_flow_flow_exit,
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}

class _CashFlowDetailsTable extends StatelessWidget {
  final CashFlowBucketDetailsModel details;
  final String locale;

  const _CashFlowDetailsTable({required this.details, required this.locale});

  @override
  Widget build(BuildContext context) {
    final headers = [
      _ColumnSpec(context.l10n.common_date, 110),
      _ColumnSpec(context.l10n.common_description, 230),
      _ColumnSpec(context.l10n.reports_cash_flow_filter_account_types, 130),
      _ColumnSpec(context.l10n.reports_cash_flow_details_category, 190),
      _ColumnSpec(context.l10n.reports_cash_flow_filter_cost_center, 150),
      _ColumnSpec(
        context.l10n.reports_cash_flow_filter_availability_accounts,
        170,
      ),
      _ColumnSpec(context.l10n.common_amount, 120),
      _ColumnSpec(context.l10n.common_type, 120),
    ];

    final minWidth = headers.fold<double>(
      0,
      (total, item) => total + item.width,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: Column(
            children: [
              _TableHeader(headers: headers),
              ...details.details.map(
                (row) =>
                    _TableRow(headers: headers, child: _buildRow(context, row)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRow(BuildContext context, CashFlowBucketDetailModel row) {
    return [
      _TextCell(cashFlowDisplayDate(row.date, locale: locale)),
      _TextCell(row.description ?? '-', maxLines: 3),
      _TextCell(row.method ?? '-'),
      _TextCell(row.categoryName ?? '-', maxLines: 3),
      _TextCell(row.costCenterName ?? '-'),
      _TextCell(row.accountName ?? '-', maxLines: 2),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          formatCurrency(row.amount),
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            color:
                row.flowType == 'entry'
                    ? AppColors.green
                    : const Color(0xFFD62839),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: _FlowTypeBadge(flowType: row.flowType),
      ),
    ];
  }
}

class _ColumnSpec {
  final String label;
  final double width;

  const _ColumnSpec(this.label, this.width);
}

class _TableHeader extends StatelessWidget {
  final List<_ColumnSpec> headers;

  const _TableHeader({required this.headers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: headers
            .map(
              (header) => SizedBox(
                width: header.width,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Text(
                    header.label.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final List<_ColumnSpec> headers;
  final List<Widget> child;

  const _TableRow({required this.headers, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(headers.length, (index) {
          return SizedBox(
            width: headers[index].width,
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: child[index],
            ),
          );
        }),
      ),
    );
  }
}

class _TextCell extends StatelessWidget {
  final String value;
  final int maxLines;

  const _TextCell(this.value, {this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: AppFonts.fontSubTitle,
        fontSize: 14,
        color: Colors.black54,
        height: 1.4,
      ),
    );
  }
}
