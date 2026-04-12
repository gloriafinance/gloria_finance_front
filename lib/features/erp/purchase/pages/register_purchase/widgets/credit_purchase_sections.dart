import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/upload_file.dart';
import 'package:gloria_finance/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/validators/form_accounts_payable_validator.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/widgets/section_card.dart';
import 'package:gloria_finance/features/erp/providers/pages/suppliers/store/suppliers_list_store.dart';
import 'package:gloria_finance/features/erp/purchase/pages/register_purchase/store/credit_purchase_register_store.dart';
import 'package:gloria_finance/features/erp/purchase/pages/register_purchase/validators/credit_purchase_register_validator.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:provider/provider.dart';

import '../../../../../auth/pages/login/store/auth_session_store.dart';
import 'add_item_purchase.dart';
import 'table_item.dart';

Widget creditPurchaseInformationSection(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  CreditPurchaseRegisterValidator validator,
  FormAccountsPayableValidator accountsPayableValidator,
) {
  return SectionCard(
    title: 'Informacoes da compra',
    subtitle:
        'Completa los datos de la compra y del proveedor antes de registrar la obligacion.',
    children: [
      if (!isMobile(context))
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _costCenterDropdown(store, validator)),
            const SizedBox(width: 16),
            Expanded(
              child: _supplierDropdown(store, accountsPayableValidator),
            ),
          ],
        ),
      if (isMobile(context)) ...[
        _costCenterDropdown(store, validator),
        _supplierDropdown(store, accountsPayableValidator),
      ],
      const SizedBox(height: 4),
      if (!isMobile(context))
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _purchaseDateInput(context, store, validator)),
            const SizedBox(width: 16),
            Expanded(child: _totalInput(store, validator)),
            const SizedBox(width: 16),
            Expanded(child: _taxInput(store)),
          ],
        ),
      if (isMobile(context)) ...[
        _purchaseDateInput(context, store, validator),
        _totalInput(store, validator),
        _taxInput(store),
      ],
      Input(
        label: context.l10n.accountsPayable_form_field_description,
        initialValue: store.state.description,
        onChanged: store.setDescription,
        onValidator:
            (_) => accountsPayableValidator.errorByKey(store.state, 'description'),
      ),
      const SizedBox(height: 4),
      UploadFile(
        label: 'Faça o upload da nota fiscal',
        multipartFiles: store.setFiles,
        allowedExtensions: const ['pdf'],
        allowMultiple: true,
        helperText: 'PDF, com no maximo 10MB',
      ),
    ],
  );
}

Widget creditPurchaseItemsSection(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  CreditPurchaseRegisterValidator validator,
  bool showValidationMessages,
) {
  final itemsError =
      showValidationMessages
          ? validator.errorByKey(store.purchaseState, 'items')
          : null;

  return SectionCard(
    title: 'Itens da compra',
    subtitle: 'Adicione cada item incluido na compra.',
    children: [
      Row(
        children: [
          ButtonActionTable(
            color: AppColors.mustard,
            text: 'Adicionar item',
            icon: Icons.add_box_outlined,
            onPressed: () {
              ModalPage(
                title: 'Adicionar item',
                body: AddItemPurchase(
                  symbol: store.purchaseState.symbolFormatMoney,
                  onCallback: store.addItem,
                ),
              ).show(context);
            },
          ),
        ],
      ),
      const SizedBox(height: 12),
      TableItem(items: store.purchaseState.items),
      if (itemsError != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            itemsError,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.red,
            ),
          ),
        ),
    ],
  );
}

Widget creditPurchasePaymentSection(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  return SectionCard(
    title: context.l10n.accountsPayable_form_section_payment_title,
    subtitle: context.l10n.accountsPayable_form_section_payment_subtitle,
    children: [
      _CreditPaymentModeSelector(store: store),
      const SizedBox(height: 20),
      if (store.state.paymentMode == AccountsPayablePaymentMode.single)
        _singlePaymentSection(context, store, validator),
      if (store.state.paymentMode == AccountsPayablePaymentMode.automatic)
        _automaticPaymentSection(
          context,
          store,
          validator,
          showValidationMessages,
        ),
      const SizedBox(height: 16),
      _installmentsPreviewSection(
        context,
        store,
        validator,
        showValidationMessages,
      ),
    ],
  );
}

void syncCreditPurchaseCurrency(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authStore = Provider.of<AuthSessionStore>(context, listen: false);
    final formStore = Provider.of<CreditPurchaseRegisterStore>(
      context,
      listen: false,
    );

    formStore.setSymbolFormatMoney(authStore.state.session.symbolFormatMoney);
  });
}

Widget _costCenterDropdown(
  CreditPurchaseRegisterStore store,
  CreditPurchaseRegisterValidator validator,
) {
  return Consumer<CostCenterListStore>(
    builder: (context, costCenterStore, _) {
      final costCenters = costCenterStore.state.costCenters;
      final selected =
          costCenters.any(
                (costCenter) =>
                    costCenter.costCenterId == store.purchaseState.costCenterId,
              )
              ? costCenters
                  .firstWhere(
                    (costCenter) =>
                        costCenter.costCenterId ==
                        store.purchaseState.costCenterId,
                  )
                  .name
              : null;

      return Dropdown(
        label: 'Centro de custo',
        items: costCenters.map((costCenter) => costCenter.name).toList(),
        initialValue: selected,
        onChanged: (value) {
          final selectedCostCenter = costCenters.firstWhere(
            (costCenter) => costCenter.name == value,
          );
          store.setCostCenterId(selectedCostCenter.costCenterId);
        },
        onValidator: (_) => validator.errorByKey(store.purchaseState, 'costCenterId'),
      );
    },
  );
}

Widget _supplierDropdown(
  CreditPurchaseRegisterStore store,
  FormAccountsPayableValidator validator,
) {
  return Consumer<SuppliersListStore>(
    builder: (context, supplierStore, _) {
      final suppliers = supplierStore.state.suppliers;
      final selected =
          suppliers.any(
                (supplier) => supplier.supplierId == store.state.supplierId,
              )
              ? store.state.supplierName
              : null;

      return Dropdown(
        label: context.l10n.accountsPayable_form_field_supplier,
        items: suppliers.map((supplier) => supplier.name).toList(),
        initialValue: selected,
        onValidator: (_) => validator.errorByKey(store.state, 'supplierId'),
        onChanged: (value) {
          final supplier = suppliers.firstWhere((item) => item.name == value);
          store.setSupplier(supplier.supplierId ?? '', supplier.name);
        },
      );
    },
  );
}

Widget _purchaseDateInput(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  CreditPurchaseRegisterValidator validator,
) {
  return Input(
    label: 'Data da compra',
    initialValue: store.purchaseState.purchaseDate,
    onChanged: (_) {},
    onTap: () async {
      FocusScope.of(context).requestFocus(FocusNode());
      final pickedDate = await selectDate(context);
      if (pickedDate == null) return;
      store.setPurchaseDate(convertDateFormatToDDMMYYYY(pickedDate.toString()));
    },
    onValidator: (_) => validator.errorByKey(store.purchaseState, 'purchaseDate'),
  );
}

Widget _totalInput(
  CreditPurchaseRegisterStore store,
  CreditPurchaseRegisterValidator validator,
) {
  return Input(
    label: 'Total da fatura',
    initialValue:
        store.purchaseState.total > 0
            ? CurrencyFormatter.formatCurrency(
              store.purchaseState.total,
              symbol: store.purchaseState.symbolFormatMoney,
            )
            : '',
    keyboardType: TextInputType.number,
    inputFormatters: [
      CurrencyFormatter.getInputFormatters(store.purchaseState.symbolFormatMoney),
    ],
    onChanged: (value) {
      store.setTotal(CurrencyFormatter.cleanCurrency(value));
    },
    onValidator: (_) => validator.errorByKey(store.purchaseState, 'total'),
  );
}

Widget _taxInput(CreditPurchaseRegisterStore store) {
  return Input(
    label: 'Imposto',
    initialValue:
        store.purchaseState.tax > 0
            ? CurrencyFormatter.formatCurrency(
              store.purchaseState.tax,
              symbol: store.purchaseState.symbolFormatMoney,
            )
            : '',
    keyboardType: TextInputType.number,
    inputFormatters: [
      CurrencyFormatter.getInputFormatters(store.purchaseState.symbolFormatMoney),
    ],
    onChanged: (value) {
      store.setTax(CurrencyFormatter.cleanCurrency(value));
    },
  );
}

class _CreditPaymentModeSelector extends StatelessWidget {
  final CreditPurchaseRegisterStore store;

  const _CreditPaymentModeSelector({required this.store});

  @override
  Widget build(BuildContext context) {
    final selectedMode = store.state.paymentMode;
    final modes = [
      AccountsPayablePaymentMode.single,
      AccountsPayablePaymentMode.automatic,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          modes.map((mode) {
            final isSelected = mode == selectedMode;
            return ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  mode.friendlyName,
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    color: isSelected ? AppColors.purple : AppColors.grey,
                  ),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.purple.withOpacity(0.12),
              backgroundColor: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? AppColors.purple : AppColors.greyMiddle,
                ),
              ),
              onSelected: (_) => store.setPaymentMode(mode),
            );
          }).toList(),
    );
  }
}

Widget _singlePaymentSection(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  FormAccountsPayableValidator validator,
) {
  return Input(
    label: context.l10n.accountsPayable_form_field_single_due_date,
    initialValue: store.state.singleDueDate,
    onChanged: store.setSingleDueDate,
    onTap: () async {
      FocusScope.of(context).requestFocus(FocusNode());
      final pickedDate = await selectDate(context);
      if (pickedDate == null) return;
      store.setSingleDueDate(convertDateFormatToDDMMYYYY(pickedDate.toString()));
    },
    onValidator: (_) => validator.errorByKey(store.state, 'singleDueDate'),
  );
}

Widget _automaticPaymentSection(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  final mismatch = showValidationMessages && store.hasInstallmentsTotalMismatch;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: 220,
            child: Input(
              label: context.l10n.accountsPayable_form_field_automatic_installments,
              initialValue:
                  store.state.automaticInstallments > 0
                      ? store.state.automaticInstallments.toString()
                      : '',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged:
                  (value) =>
                      store.setAutomaticInstallments(int.tryParse(value) ?? 0),
              onValidator:
                  (_) =>
                      validator.errorByKey(store.state, 'automaticInstallments'),
            ),
          ),
          SizedBox(
            width: 220,
            child: Input(
              label: context.l10n.accountsPayable_form_field_automatic_amount,
              initialValue:
                  store.state.automaticInstallmentAmount > 0
                      ? CurrencyFormatter.formatCurrency(
                        store.state.automaticInstallmentAmount,
                        symbol: store.purchaseState.symbolFormatMoney,
                      )
                      : '',
              keyboardType: TextInputType.number,
              inputFormatters: [
                CurrencyFormatter.getInputFormatters(
                  store.purchaseState.symbolFormatMoney,
                ),
              ],
              onChanged:
                  (value) => store.setAutomaticInstallmentAmount(
                    CurrencyFormatter.cleanCurrency(value),
                  ),
              onValidator:
                  (_) => validator.errorByKey(
                    store.state,
                    'automaticInstallmentAmount',
                  ),
            ),
          ),
          SizedBox(
            width: 220,
            child: Input(
              label: context.l10n.accountsPayable_form_field_automatic_first_due_date,
              initialValue: store.state.automaticFirstDueDate,
              onChanged: store.setAutomaticFirstDueDate,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final pickedDate = await selectDate(context);
                if (pickedDate == null) return;
                store.setAutomaticFirstDueDate(
                  convertDateFormatToDDMMYYYY(pickedDate.toString()),
                );
              },
              onValidator:
                  (_) =>
                      validator.errorByKey(store.state, 'automaticFirstDueDate'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ButtonActionTable(
        color: AppColors.blue,
        text: context.l10n.accountsPayable_form_generate_installments,
        icon: Icons.calculate_outlined,
        onPressed: () {
          final success = store.generateAutomaticInstallments();
          if (!success) {
            Toast.showMessage(
              context.l10n.accountsPayable_form_error_generate_installments_fill_data,
              ToastType.warning,
            );
            return;
          }
          Toast.showMessage(
            context.l10n.accountsPayable_form_toast_generate_installments_success,
            ToastType.info,
          );
        },
      ),
      if (mismatch)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'La suma de las cuotas debe coincidir con el total de la compra.',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.red,
            ),
          ),
        ),
    ],
  );
}

Widget _installmentsPreviewSection(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  final installments = store.state.installments;
  final errorMessage =
      showValidationMessages
          ? validator.errorByKey(store.state, 'installments')
          : null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.accountsPayable_form_installments_summary_title,
        style: const TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: 15,
          color: AppColors.purple,
        ),
      ),
      const SizedBox(height: 8),
      if (installments.isEmpty)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyMiddle),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            store.state.paymentMode == AccountsPayablePaymentMode.single
                ? context.l10n.accountsPayable_form_installments_single_empty_message
                : context
                    .l10n
                    .accountsPayable_form_installments_automatic_empty_message,
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
              itemCount: installments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final installment = installments[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyMiddle),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.accountsPayable_form_installment_item_title(
                          index + 1,
                        ),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 15,
                          color: AppColors.purple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatCurrency(
                          installment.amount,
                          symbol: store.purchaseState.symbolFormatMoney,
                        ),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context
                            .l10n
                            .accountsPayable_form_installment_item_due_date(
                              installment.dueDate,
                            ),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total da compra: ${CurrencyFormatter.formatCurrency(store.purchaseState.total, symbol: store.purchaseState.symbolFormatMoney)}',
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.accountsPayable_form_installments_summary_total(
                      CurrencyFormatter.formatCurrency(
                        store.installmentsTotal,
                        symbol: store.purchaseState.symbolFormatMoney,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      color: AppColors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      if (errorMessage != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
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
