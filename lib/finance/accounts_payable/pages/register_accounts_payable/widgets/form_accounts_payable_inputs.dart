import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_tax.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/providers/pages/suppliers/store/suppliers_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/form_accounts_payable_state.dart';
import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';
import 'installment_account_payable_form.dart';
import 'tax_account_payable_form.dart';

Widget generalInformationSection(
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
) {
  return _SectionCard(
    title: 'Informações básicas',
    subtitle: 'Escolha o fornecedor e descreva a conta a pagar.',
    children: [
      _supplierDropdown(formStore, validator),
      _descriptionInput(formStore, validator),
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
    title: 'Documento fiscal',
    subtitle: 'Inclua detalhes do documento quando necessário.',
    children: [
      Row(
        children: [
          Switch.adaptive(
            value: state.includeDocument,
            activeColor: AppColors.purple,
            onChanged: formStore.setIncludeDocument,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Adicionar informações do documento',
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
              ),
            ),
          ),
        ],
      ),
      if (state.includeDocument) ...[
        const SizedBox(height: 16),
        Dropdown(
          label: 'Tipo de documento',
          items: AccountsPayableDocumentType.values
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
          onValidator: (_) =>
              validator.errorByKey(formStore.state, 'documentType'),
        ),
        Input(
          label: 'Número do documento',
          initialValue: state.documentNumber,
          onChanged: formStore.setDocumentNumber,
          onValidator: (_) =>
              validator.errorByKey(formStore.state, 'documentNumber'),
        ),
        Input(
          label: 'Data de emissão',
          initialValue: state.documentIssueDate,
          onChanged: formStore.setDocumentIssueDate,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final pickedDate = await selectDate(context);
            if (pickedDate == null) return;
            final formatted =
                convertDateFormatToDDMMYYYY(pickedDate.toString());
            formStore.setDocumentIssueDate(formatted);
          },
          onValidator: (_) =>
              validator.errorByKey(formStore.state, 'documentIssueDate'),
        ),
      ],
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
  final taxStatusError = showValidationMessages
      ? validator.errorByKey(formStore.state, 'taxStatus')
      : null;

  final showExemptionReason =
      state.taxStatus == AccountsPayableTaxStatus.exempt;
  final showTaxCodes = state.taxStatus == AccountsPayableTaxStatus.taxed ||
      state.taxStatus == AccountsPayableTaxStatus.substitution;

  return _SectionCard(
    title: 'Tributação da nota fiscal',
    subtitle: 'Classifique a nota e informe os impostos destacados.',
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AccountsPayableTaxStatus.values.map((status) {
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
              'Nota fiscal isenta de impostos',
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
          label: 'Motivo da isenção',
          initialValue: state.taxExemptionReason,
          onChanged: formStore.setTaxExemptionReason,
          onValidator: (_) =>
              validator.errorByKey(formStore.state, 'taxExemptionReason'),
        ),
      Input(
        label: 'Observações',
        initialValue: state.taxObservation,
        onChanged: formStore.setTaxObservation,
      ),
      if (showTaxCodes) ...[
        Input(
          label: 'Código CST',
          initialValue: state.taxCstCode,
          onChanged: formStore.setTaxCstCode,
        ),
        Input(
          label: 'CFOP',
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
  final selectedMode = formStore.state.paymentMode;

  return _SectionCard(
    title: 'Configuração do pagamento',
    subtitle:
        'Defina como essa conta será quitada e revise o cronograma de parcelas.',
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AccountsPayablePaymentMode.values.map((mode) {
          final isSelected = selectedMode == mode;

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
      ),
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
      final initialValue = suppliers.any(
        (supplier) => supplier.supplierId == formStore.state.supplierId,
      )
          ? formStore.state.supplierName
          : null;

      final dropdown = Dropdown(
        label: 'Fornecedor',
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
        onValidator: (_) =>
            validator.errorByKey(formStore.state, 'supplierId'),
      );

      if (suppliers.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dropdown,
            const SizedBox(height: 8),
            const Text(
              'Nenhum fornecedor encontrado. Cadastre um fornecedor para continuar.',
              style: TextStyle(
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
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
) {
  return Input(
    label: 'Descrição',
    initialValue: formStore.state.description,
    onChanged: formStore.setDescription,
    onValidator: (_) => validator.errorByKey(formStore.state, 'description'),
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
