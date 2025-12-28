import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/features/erp/bank_statements/models/bank_statement_model.dart';
import 'package:church_finance_bk/features/erp/financial_records/finance_record_service.dart';
import 'package:church_finance_bk/features/erp/financial_records/models/finance_record_filter_model.dart';
import 'package:church_finance_bk/features/erp/financial_records/models/finance_record_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankStatementManualLinkDialog extends StatefulWidget {
  final BankStatementModel statement;
  final Future<void> Function(String financialRecordId) onSubmit;

  const BankStatementManualLinkDialog({
    super.key,
    required this.statement,
    required this.onSubmit,
  });

  @override
  State<BankStatementManualLinkDialog> createState() =>
      _BankStatementManualLinkDialogState();
}

class _BankStatementManualLinkDialogState
    extends State<BankStatementManualLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _financeRecordService = FinanceRecordService();

  bool _loadingSuggestions = true;
  bool _submitting = false;
  List<FinanceRecordListModel> _suggestions = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.statement.financialRecordId != null) {
      _controller.text = widget.statement.financialRecordId!;
    }
    _loadSuggestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _loadingSuggestions = true;
      _error = null;
    });

    try {
      final filter = FinanceRecordFilterModel.init();
      filter.perPage = 20;
      filter.page = 1;

      final rangeStart = widget.statement.postedAt.subtract(
        const Duration(days: 1),
      );
      final rangeEnd = widget.statement.postedAt.add(const Duration(days: 1));

      final formatter = DateFormat('dd/MM/yyyy');
      filter.startDate = formatter.format(rangeStart);
      filter.endDate = formatter.format(rangeEnd);
      filter.conceptType =
          widget.statement.direction == BankStatementDirection.income
              ? 'INCOME'
              : 'OUTGO';

      final response = await _financeRecordService.searchFinanceRecords(filter);

      final directionApi =
          widget.statement.direction == BankStatementDirection.income
              ? 'INCOME'
              : 'OUTGO';

      final matches =
          response.results.where((record) {
            final sameDirection = record.type.toUpperCase() == directionApi;
            final sameAmount =
                (record.amount - widget.statement.amount).abs() < 0.01;
            return sameDirection && sameAmount;
          }).toList();

      setState(() {
        _suggestions = matches;
        _loadingSuggestions = false;
      });
    } catch (e) {
      setState(() {
        _error =
            'Não foi possível carregar sugestões. Tente novamente mais tarde.';
        _loadingSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatementSummary(statement: widget.statement),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: context.l10n.bankStatements_link_dialog_id_label,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.bankStatements_link_dialog_id_error;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.bankStatements_link_dialog_suggestions_title,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: AppColors.purple,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            if (_loadingSuggestions)
              const Center(child: CircularProgressIndicator()),
            if (!_loadingSuggestions && _error != null)
              Text(
                context.l10n.bankStatements_link_dialog_suggestions_error,
                style: const TextStyle(color: Colors.redAccent),
              ),
            if (!_loadingSuggestions && _error == null && _suggestions.isEmpty)
              Text(
                context.l10n.bankStatements_link_dialog_suggestions_empty,
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
            if (_suggestions.isNotEmpty)
              ..._suggestions.map(
                (record) => _SuggestionTile(
                  record: record,
                  onSelect: () {
                    _controller.text = record.financialRecordId;
                  },
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text:
                      context
                          .l10n
                          .common_cancel, // Assuming common_cancel exists
                  onPressed:
                      _submitting ? null : () => Navigator.of(context).pop(),
                  typeButton: CustomButton.outline,
                  backgroundColor: AppColors.purple,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text:
                      _submitting
                          ? context.l10n.bankStatements_link_dialog_saving
                          : context.l10n.bankStatements_link_dialog_link_button,
                  onPressed:
                      _submitting
                          ? null
                          : () async {
                            if (!_formKey.currentState!.validate()) return;

                            setState(() {
                              _submitting = true;
                            });

                            try {
                              await widget.onSubmit(_controller.text.trim());
                              if (mounted) Navigator.of(context).pop(true);
                            } catch (e) {
                              setState(() {
                                _submitting = false;
                                _error =
                                    context
                                        .l10n
                                        .bankStatements_link_dialog_link_error;
                              });
                            }
                          },
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  icon: _submitting ? null : Icons.link,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final FinanceRecordListModel record;
  final VoidCallback onSelect;

  const _SuggestionTile({required this.record, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.formatCurrency(record.amount),
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 16,
                ),
              ),
              TextButton(onPressed: onSelect, child: const Text('Usar ID')),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            record.financialConcept?.name ?? 'Sem conceito',
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
          const SizedBox(height: 4),
          Text(
            record.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy').format(record.date),
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'ID: ${record.financialRecordId}',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementSummary extends StatelessWidget {
  final BankStatementModel statement;

  const _StatementSummary({required this.statement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.greyLight.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CurrencyFormatter.formatCurrency(statement.amount),
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            statement.description,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
          const SizedBox(height: 4),
          Text(
            'Data: ${DateFormat('dd/MM/yyyy').format(statement.postedAt)}',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
