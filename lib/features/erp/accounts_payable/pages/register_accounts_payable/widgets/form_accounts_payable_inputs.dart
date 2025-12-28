import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:church_finance_bk/features/erp/providers/pages/suppliers/store/suppliers_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';
import 'installment_account_payable_form.dart';
import 'tax_account_payable_form.dart';

Widget generalInformationSection(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
) {
  return _SectionCard(
    title: context.l10n.accountsPayable_form_section_basic_title,
    subtitle: context.l10n.accountsPayable_form_section_basic_subtitle,
    children: [
      _supplierDropdown(formStore, validator),
      _descriptionInput(context, formStore, validator),
    ],
  );
}

Widget documentSection(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
) {
  final state = formStore.state;

  return _SectionCard(
    title: context.l10n.accountsPayable_form_section_document_title,
    subtitle: context.l10n.accountsPayable_form_section_document_subtitle,
    children: [
      Dropdown(
        label: context.l10n.accountsPayable_form_field_document_type,
        items:
            AccountsPayableDocumentType.values
                .map((type) => type.friendlyName)
                .toList(),
        initialValue: state.documentType?.friendlyName,
        onChanged: (value) {
          final type = AccountsPayableDocumentType.values.firstWhere(
            (element) => element.friendlyName == value,
            orElse: () => AccountsPayableDocumentType.other,
          );
          formStore.setDocumentType(type);
        },
        onValidator:
            (_) => validator.errorByKey(formStore.state, 'documentType'),
      ),
      const SizedBox(height: 16),
      Input(
        label: context.l10n.accountsPayable_form_field_document_number,
        initialValue: state.documentNumber,
        onChanged: formStore.setDocumentNumber,
        onValidator:
            (_) => validator.errorByKey(formStore.state, 'documentNumber'),
      ),
      const SizedBox(height: 16),
      Input(
        label: context.l10n.accountsPayable_form_field_document_date,
        initialValue: state.documentIssueDate,
        onChanged: formStore.setDocumentIssueDate,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final pickedDate = await selectDate(context);
          if (pickedDate == null) return;
          final formatted = convertDateFormatToDDMMYYYY(pickedDate.toString());
          formStore.setDocumentIssueDate(formatted);
        },
        onValidator:
            (_) => validator.errorByKey(formStore.state, 'documentIssueDate'),
      ),
    ],
  );
}

Widget taxSection(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  final state = formStore.state;

  final shouldShowTaxation =
      state.documentType == AccountsPayableDocumentType.invoice;

  if (!shouldShowTaxation) {
    return const SizedBox.shrink();
  }
  final taxStatusError =
      showValidationMessages
          ? validator.errorByKey(formStore.state, 'taxStatus')
          : null;

  final showExemptionReason =
      state.taxStatus == AccountsPayableTaxStatus.exempt;
  final showTaxCodes =
      state.taxStatus == AccountsPayableTaxStatus.taxed ||
      state.taxStatus == AccountsPayableTaxStatus.substitution;

  return _SectionCard(
    title: context.l10n.accountsPayable_form_section_tax_title,
    subtitle: context.l10n.accountsPayable_form_section_tax_subtitle,
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            AccountsPayableTaxStatus.values.map((status) {
              final isSelected = state.taxStatus == status;
              return ChoiceChip(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    status.friendlyName,
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
                onSelected: (_) => formStore.setTaxStatus(status),
              );
            }).toList(),
      ),
      if (taxStatusError != null) ...[
        const SizedBox(height: 8),
        Text(
          taxStatusError,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            color: Colors.red,
          ),
        ),
      ],
      const SizedBox(height: 12),
      Row(
        children: [
          Switch.adaptive(
            value: state.taxExempt,
            activeColor: AppColors.purple,
            onChanged: formStore.setTaxExempt,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.accountsPayable_form_field_tax_exempt_switch,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
              ),
            ),
          ),
        ],
      ),
      if (showExemptionReason)
        Input(
          label: context.l10n.accountsPayable_form_field_tax_exemption_reason,
          initialValue: state.taxExemptionReason,
          onChanged: formStore.setTaxExemptionReason,
          onValidator:
              (_) =>
                  validator.errorByKey(formStore.state, 'taxExemptionReason'),
        ),
      Input(
        label: context.l10n.accountsPayable_form_field_tax_observation,
        initialValue: state.taxObservation,
        onChanged: formStore.setTaxObservation,
      ),
      if (showTaxCodes) ...[
        Input(
          label: context.l10n.accountsPayable_form_field_tax_cst,
          labelSuffix: _buildCstHelpIcon(context),
          initialValue: state.taxCstCode,
          onChanged: formStore.setTaxCstCode,
        ),
        Input(
          label: context.l10n.accountsPayable_form_field_tax_cfop,
          labelSuffix: _buildCfopHelpIcon(context),
          initialValue: state.taxCfop,
          onChanged: formStore.setTaxCfop,
        ),
      ],
      if (!state.taxExempt) ...[
        const SizedBox(height: 16),
        TaxAccountPayableForm(
          formStore: formStore,
          validator: validator,
          showValidationMessages: showValidationMessages,
        ),
      ],
    ],
  );
}

Widget paymentSection(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  return _SectionCard(
    title: context.l10n.accountsPayable_form_section_payment_title,
    subtitle: context.l10n.accountsPayable_form_section_payment_subtitle,
    children: [
      _PaymentModeSelector(formStore: formStore),
      const SizedBox(height: 20),
      InstallmentAccountPayableForm(
        formStore: formStore,
        validator: validator,
        showValidationMessages: showValidationMessages,
      ),
    ],
  );
}

Widget _supplierDropdown(
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
) {
  return Consumer<SuppliersListStore>(
    builder: (context, supplierStore, child) {
      final suppliers = supplierStore.state.suppliers;
      final items = suppliers.map((supplier) => supplier.name).toList();
      final initialValue =
          suppliers.any(
                (supplier) => supplier.supplierId == formStore.state.supplierId,
              )
              ? formStore.state.supplierName
              : null;

      final dropdown = Dropdown(
        label: context.l10n.accountsPayable_form_field_supplier,
        items: items,
        initialValue: initialValue,
        onChanged: (value) {
          if (value == null || suppliers.isEmpty) return;
          final selectedSupplier = suppliers.firstWhere(
            (supplier) => supplier.name == value,
            orElse: () => suppliers.first,
          );
          formStore.setSupplier(
            selectedSupplier.supplierId ?? '',
            selectedSupplier.name,
          );
        },
        onValidator: (_) => validator.errorByKey(formStore.state, 'supplierId'),
      );

      if (suppliers.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dropdown,
            const SizedBox(height: 8),
            Text(
              context.l10n.accountsPayable_form_error_supplier_required,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
              ),
            ),
          ],
        );
      }

      return dropdown;
    },
  );
}

Widget _descriptionInput(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
) {
  return Input(
    label: context.l10n.accountsPayable_form_field_description,
    initialValue: formStore.state.description,
    onChanged: formStore.setDescription,
    onValidator: (_) => validator.errorByKey(formStore.state, 'description'),
  );
}

class _PaymentModeSelector extends StatelessWidget {
  final FormAccountsPayableStore formStore;

  const _PaymentModeSelector({required this.formStore});

  @override
  Widget build(BuildContext context) {
    final selectedMode = formStore.state.paymentMode;
    final availableModes =
        AccountsPayablePaymentMode.values
            .where((mode) => mode != AccountsPayablePaymentMode.manual)
            .toList();

    if (availableModes.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectiveMode =
        availableModes.contains(selectedMode)
            ? selectedMode
            : availableModes.first;

    if (effectiveMode != selectedMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formStore.setPaymentMode(effectiveMode);
      });
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          availableModes.map((mode) {
            final isSelected = effectiveMode == mode;

            return ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
              onSelected: (_) => formStore.setPaymentMode(mode),
            );
          }).toList(),
    );
  }
}

Widget _buildCstHelpIcon(BuildContext context) {
  return Tooltip(
    message: context.l10n.accountsPayable_form_section_payment_mode_help_cst,
    child: InkWell(
      onTap: () => _showCstHelp(context),
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(Icons.help_outline, size: 18, color: AppColors.purple),
      ),
    ),
  );
}

Future<void> _showCstHelp(BuildContext context) async {
  final l10n = context.l10n;
  final entries = <Map<String, String>>[
    {'code': '00', 'description': l10n.accountsPayable_help_cst_00},
    {'code': '10', 'description': l10n.accountsPayable_help_cst_10},
    {'code': '20', 'description': l10n.accountsPayable_help_cst_20},
    {'code': '40', 'description': l10n.accountsPayable_help_cst_40},
    {'code': '60', 'description': l10n.accountsPayable_help_cst_60},
    {'code': '90', 'description': l10n.accountsPayable_help_cst_90},
  ];

  ModalPage(
    title: l10n.accountsPayable_help_cst_title,
    width: 500,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accountsPayable_help_cst_description,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        ...entries.map(
          (entry) =>
              _buildHelpDialogEntry(entry['code']!, entry['description']!),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: CustomButton(
            text: l10n.common_understood,
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: AppColors.purple,
            textColor: Colors.white,
          ),
        ),
      ],
    ),
  ).show(context);
}

Widget _buildCfopHelpIcon(BuildContext context) {
  return Tooltip(
    message: context.l10n.accountsPayable_form_section_payment_mode_help_cfop,
    child: InkWell(
      onTap: () => _showCfopHelp(context),
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(Icons.help_outline, size: 18, color: AppColors.purple),
      ),
    ),
  );
}

Future<void> _showCfopHelp(BuildContext context) async {
  final l10n = context.l10n;
  final groups = <Map<String, String>>[
    {'code': '1xxx', 'description': l10n.accountsPayable_help_cfop_1xxx},
    {'code': '2xxx', 'description': l10n.accountsPayable_help_cfop_2xxx},
    {'code': '5xxx', 'description': l10n.accountsPayable_help_cfop_5xxx},
    {'code': '6xxx', 'description': l10n.accountsPayable_help_cfop_6xxx},
    {'code': '7xxx', 'description': l10n.accountsPayable_help_cfop_7xxx},
  ];

  final examples = <Map<String, String>>[
    {'code': '1.101', 'description': l10n.accountsPayable_help_cfop_1101},
    {'code': '1.556', 'description': l10n.accountsPayable_help_cfop_1556},
    {'code': '5.405', 'description': l10n.accountsPayable_help_cfop_5405},
    {'code': '6.102', 'description': l10n.accountsPayable_help_cfop_6102},
  ];

  ModalPage(
    title: l10n.accountsPayable_help_cfop_title,
    width: 600,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accountsPayable_help_cfop_description,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.accountsPayable_help_cfop_digit_info,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 8),
        ...groups.map(
          (group) =>
              _buildHelpDialogEntry(group['code']!, group['description']!),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.accountsPayable_help_cfop_examples_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 8),
        ...examples.map(
          (example) =>
              _buildHelpDialogEntry(example['code']!, example['description']!),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: CustomButton(
            text: l10n.common_understood,
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: AppColors.purple,
            textColor: Colors.white,
          ),
        ),
      ],
    ),
  ).show(context);
}

Widget _buildHelpDialogEntry(String code, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        text: '$code · ',
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 13,
          color: AppColors.purple,
        ),
        children: [
          TextSpan(
            text: description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyMiddle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              color: AppColors.purple,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
              ),
            ),
          ],
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
