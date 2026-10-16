import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/upload_file.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_source_ui_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_execution_store.dart';
import 'recurring_payment_execution_field.dart';

/// Registro manual: a igreja **não** tem banca conectada, então Glória não
/// executa nada — só registra o gasto que aconteceu fora dela.
///
/// Por isso não se pergunta PIX, boleto nem chave: o meio externo não interessa
/// ao histórico contábil. O comprovante, sim, é obrigatório.
class RecurringPaymentManualRegistrationStep extends StatefulWidget {
  const RecurringPaymentManualRegistrationStep({
    super.key,
    required this.onSubmit,
    required this.symbolFormatMoney,
    this.selectedSource,
  });

  final void Function({
    required String paymentDate,
    required String availabilityAccountId,
    required MultipartFile? voucher,
  })
  onSubmit;
  final String symbolFormatMoney;
  final RecurringPaymentSourceUiModel? selectedSource;

  @override
  State<RecurringPaymentManualRegistrationStep> createState() =>
      _RecurringPaymentManualRegistrationStepState();
}

class _RecurringPaymentManualRegistrationStepState
    extends State<RecurringPaymentManualRegistrationStep> {
  DateTime? _date;
  String? _accountId;
  MultipartFile? _voucher;

  @override
  void initState() {
    super.initState();

    _accountId = widget.selectedSource?.id;
  }

  bool _isComplete({required bool requiresVoucher}) {
    final store = context.read<RecurringPaymentExecutionStore>();
    final state = store.state;

    if (state.requiresAmount && !state.isComplete) return false;
    if (_date == null) return false;
    if (_accountId == null) return false;
    if (requiresVoucher && _voucher == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentExecutionStore>();
    final state = store.state;
    final l10n = context.l10n;
    final accounts =
        context
            .watch<AvailabilityAccountsListStore>()
            .state
            .availabilityAccounts
            .where((account) => account.active)
            .toList();
    final selectedAccounts =
        accounts
            .where((account) => account.availabilityAccountId == _accountId)
            .toList();
    final requiresVoucher =
        widget.selectedSource?.requiresVoucher ??
        (selectedAccounts.isNotEmpty &&
            (selectedAccounts.first.accountType == 'BANK' ||
                selectedAccounts.first.accountType == 'WALLET'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          requiresVoucher
              ? l10n.recurringPaymentsExecution_manual_subtitle
              : l10n.recurringPaymentsExecution_manual_no_voucher_subtitle,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 12.5,
            color: Color(0xFF5F5F5F),
          ),
        ),
        const SizedBox(height: 16),
        if (state.isFixed && widget.selectedSource != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFE4E7EC)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                RecurringPaymentExecutionField(
                  label: l10n.recurringPaymentsExecution_field_value,
                  value: CurrencyFormatter.formatCurrency(
                    state.payment.amount ?? 0,
                    symbol: widget.symbolFormatMoney,
                  ),
                  note:
                      l10n.recurringPaymentsExecution_value_from_configuration,
                  emphasized: true,
                ),
                const Divider(height: 10),
                RecurringPaymentExecutionField(
                  label:
                      l10n.recurringPaymentsExecution_manual_selected_account,
                  value: widget.selectedSource!.name,
                ),
              ],
            ),
          )
        else if (state.isFixed)
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_field_value,
            value: CurrencyFormatter.formatCurrency(
              state.payment.amount ?? 0,
              symbol: widget.symbolFormatMoney,
            ),
            note: l10n.recurringPaymentsExecution_value_from_configuration,
            emphasized: true,
          )
        else
          Input(
            label: l10n.recurringPaymentsExecution_manual_amount_label,
            initialValue: state.amountText.isEmpty ? null : state.amountText,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyFormatter.getInputFormatters(widget.symbolFormatMoney),
            ],
            icon: Icons.attach_money,
            onChanged: store.setAmountText,
          ),
        const SizedBox(height: 8),
        Input(
          label: l10n.recurringPaymentsExecution_manual_date_label,
          initialValue:
              _date == null
                  ? null
                  : '${_date!.day.toString().padLeft(2, '0')}/'
                      '${_date!.month.toString().padLeft(2, '0')}/${_date!.year}',
          hintText: l10n.recurringPaymentsExecution_manual_date_hint,
          hintStyle: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 12.5,
            color: Color(0xFF667085),
          ),
          icon: Icons.event,
          readOnly: true,
          onTap: _pickDate,
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        if (widget.selectedSource == null)
          Dropdown(
            label: l10n.recurringPaymentsExecution_manual_account_label,
            items: accounts.map((account) => account.accountName).toList(),
            initialValue: _selectedAccountName(accounts),
            searchHint: l10n.recurringPaymentsExecution_manual_account_label,
            onChanged: (value) {
              setState(() {
                _accountId = null;
                for (final account in accounts) {
                  if (account.accountName == value) {
                    _accountId = account.availabilityAccountId;
                    break;
                  }
                }
              });
            },
          )
        else if (state.isVariable)
          RecurringPaymentExecutionField(
            label: l10n.recurringPaymentsExecution_manual_selected_account,
            value: widget.selectedSource!.name,
          ),
        if (requiresVoucher) ...[
          const SizedBox(height: 8),
          UploadFile(
            label: l10n.recurringPaymentsExecution_manual_voucher_label,
            helperText: l10n.recurringPaymentsExecution_manual_voucher_hint,
            compact: true,
            multipartFile: (file) => setState(() => _voucher = file),
          ),
        ],
        const SizedBox(height: 12),
        RecurringPaymentExecutionNotice(
          text: l10n.recurringPaymentsExecution_manual_no_method_note,
        ),
        if (state.isLoading) ...[
          const SizedBox(height: 12),
          RecurringPaymentExecutionNotice(
            text: l10n.recurringPaymentsExecution_manual_submitting,
            icon: Icons.hourglass_top,
            color: AppColors.blue,
          ),
        ],
        const SizedBox(height: 20),
        CustomButton(
          text: l10n.recurringPaymentsExecution_manual_submit,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.check,
          onPressed:
              state.isLoading || !_isComplete(requiresVoucher: requiresVoucher)
                  ? null
                  : () => widget.onSubmit(
                    paymentDate: _date!.toIso8601String().substring(0, 10),
                    availabilityAccountId: _accountId!,
                    voucher: _voucher,
                  ),
        ),
      ],
    );
  }

  String? _selectedAccountName(List<AvailabilityAccountModel> accounts) {
    for (final account in accounts) {
      if (account.availabilityAccountId == _accountId) {
        return account.accountName;
      }
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: context.l10n.recurringPaymentsExecution_manual_date_label,
    );

    if (picked != null && mounted) setState(() => _date = picked);
  }
}
