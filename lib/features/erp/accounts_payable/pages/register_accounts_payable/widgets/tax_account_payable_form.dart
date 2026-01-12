import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/erp/accounts_payable/models/accounts_payable_tax.dart';
import 'package:church_finance_bk/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';

class TaxAccountPayableForm extends StatefulWidget {
  final FormAccountsPayableStore formStore;
  final FormAccountsPayableValidator validator;
  final bool showValidationMessages;

  const TaxAccountPayableForm({
    super.key,
    required this.formStore,
    required this.validator,
    required this.showValidationMessages,
  });

  @override
  State<TaxAccountPayableForm> createState() => _TaxAccountPayableFormState();
}

class _TaxAccountPayableFormState extends State<TaxAccountPayableForm> {
  @override
  Widget build(BuildContext context) {
    final state = widget.formStore.state;
    final taxes = state.taxes;

    final errorMessage =
        widget.showValidationMessages
            ? widget.validator.errorByKey(state, 'taxes') ??
                widget.validator.errorByKey(state, 'taxesContents')
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.tax_form_title_add,
          icon: Icons.add_box_outlined,
          onPressed: () => _openCreateTax(widget.formStore),
        ),
        const SizedBox(height: 12),
        if (taxes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyMiddle),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              context.l10n.tax_form_empty_list,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
              ),
            ),
          )
        else
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: taxes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final tax = taxes[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyMiddle),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tax.taxType,
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontTitle,
                                  fontSize: 15,
                                  color: AppColors.purple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Situação: ${tax.status.friendlyName}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Percentual: ${tax.percentage.toStringAsFixed(2)}%',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Valor: ${CurrencyFormatter.formatCurrency(tax.amount, symbol: state.symbolFormatMoney)}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar imposto',
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.blue,
                              ),
                              onPressed:
                                  () => _openEditTax(widget.formStore, index),
                            ),
                            IconButton(
                              tooltip: 'Remover imposto',
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed:
                                  () => widget.formStore.removeTaxLine(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openCreateTax(FormAccountsPayableStore formStore) async {
    final result = await _showTaxDialog(context, formStore);
    if (result == null) return;
    widget.formStore.addTaxLine(result);
  }

  Future<void> _openEditTax(
    FormAccountsPayableStore formStore,
    int index,
  ) async {
    final taxes = widget.formStore.state.taxes;
    if (index < 0 || index >= taxes.length) return;

    final result = await _showTaxDialog(
      context,
      formStore,
      initial: taxes[index],
    );

    if (result == null) return;
    widget.formStore.updateTaxLine(index, result);
  }

  Future<AccountsPayableTaxLine?> _showTaxDialog(
    BuildContext context,
    FormAccountsPayableStore formStore, {
    AccountsPayableTaxLine? initial,
  }) async {
    final formKey = GlobalKey<FormState>();
    String taxType = initial?.taxType ?? '';
    String percentageText =
        initial != null ? initial.percentage.toStringAsFixed(2) : '';
    String amountText =
        initial != null && initial.amount > 0
            ? CurrencyFormatter.formatCurrency(initial.amount)
            : '';
    AccountsPayableTaxStatus status =
        initial?.status ?? AccountsPayableTaxStatus.taxed;

    AccountsPayableTaxLine? result;

    return await ModalPage(
      title:
          initial == null
              ? context.l10n.tax_form_title_add
              : context.l10n.tax_form_title_edit,
      width: 400,
      body: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Input(
                  label: context.l10n.tax_form_type_label,
                  initialValue: taxType,
                  onChanged: (value) => taxType = value,
                  onValidator: (value) {
                    if ((value ?? '').isEmpty) {
                      return context.l10n.tax_form_type_error;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Input(
                  label: context.l10n.tax_form_percentage_label,
                  initialValue: percentageText,
                  onChanged: (value) => percentageText = value,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onValidator: (value) {
                    final parsed = double.tryParse(
                      (value ?? '').replaceAll(',', '.').trim(),
                    );
                    if (parsed == null || parsed <= 0) {
                      return context.l10n.tax_form_percentage_error;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Input(
                  label: context.l10n.tax_form_amount_label,
                  initialValue: amountText,
                  onChanged: (value) => amountText = value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyFormatter.getInputFormatters(
                      formStore.state.symbolFormatMoney,
                    ),
                  ],
                  onValidator: (value) {
                    final amount = CurrencyFormatter.cleanCurrency(
                      value ?? '0',
                    );
                    if (amount <= 0) {
                      return context.l10n.tax_form_amount_error;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Dropdown(
                  label: context.l10n.tax_form_status_label,
                  items: [
                    context.l10n.tax_form_status_taxed,
                    // 'Tributada'
                    context.l10n.tax_form_status_substitution,
                    // 'Substituição tributária'
                  ],
                  initialValue:
                      status == AccountsPayableTaxStatus.substitution
                          ? context.l10n.tax_form_status_substitution
                          : context.l10n.tax_form_status_taxed,
                  onChanged: (value) {
                    if (value == context.l10n.tax_form_status_substitution) {
                      status = AccountsPayableTaxStatus.substitution;
                    } else {
                      status = AccountsPayableTaxStatus.taxed;
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: context.l10n.common_cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      typeButton: CustomButton.outline,
                      backgroundColor: AppColors.purple,
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: context.l10n.common_save,
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        final percentage = double.parse(
                          percentageText.replaceAll(',', '.').trim(),
                        );
                        final amount = CurrencyFormatter.cleanCurrency(
                          amountText,
                        );

                        result = AccountsPayableTaxLine(
                          taxType: taxType,
                          percentage: percentage,
                          amount: amount,
                          status: status,
                        );

                        Navigator.of(context).pop(result);
                      },
                      backgroundColor: AppColors.purple,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ).show<AccountsPayableTaxLine>(context);
  }
}
