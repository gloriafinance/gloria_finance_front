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
    subtitle: 'Informe o documento fiscal associado ao pagamento.',
    children: [
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
      const SizedBox(height: 16),
      Input(
        label: 'Número do documento',
        initialValue: state.documentNumber,
        onChanged: formStore.setDocumentNumber,
        onValidator: (_) =>
            validator.errorByKey(formStore.state, 'documentNumber'),
      ),
      const SizedBox(height: 16),
      Input(
        label: 'Data do documento',
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
          labelSuffix: _buildCstHelpIcon(context),
          initialValue: state.taxCstCode,
          onChanged: formStore.setTaxCstCode,
        ),
        Input(
          label: 'CFOP',
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
    title: 'Configuração do pagamento',
    subtitle:
        'Defina como essa conta será quitada e revise o cronograma de parcelas.',
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

class _PaymentModeSelector extends StatelessWidget {
  final FormAccountsPayableStore formStore;

  const _PaymentModeSelector({
    required this.formStore,
  });

  @override
  Widget build(BuildContext context) {
    final selectedMode = formStore.state.paymentMode;
    final availableModes = AccountsPayablePaymentMode.values
        .where((mode) => mode != AccountsPayablePaymentMode.manual)
        .toList();

    if (availableModes.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectiveMode = availableModes.contains(selectedMode)
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
      children: availableModes.map((mode) {
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
    message: 'Ajuda rápida sobre CST',
    child: InkWell(
      onTap: () => _showCstHelp(context),
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(
          Icons.help_outline,
          size: 18,
          color: AppColors.purple,
        ),
      ),
    ),
  );
}

Future<void> _showCstHelp(BuildContext context) async {
  final entries = <Map<String, String>>[
    {'code': '00', 'description': 'Tributação integral (ICMS normal)'},
    {'code': '10', 'description': 'Tributada com ICMS por substituição'},
    {'code': '20', 'description': 'Com redução de base de cálculo'},
    {'code': '40', 'description': 'Isenta ou não tributada'},
    {'code': '60', 'description': 'ICMS cobrado anteriormente por ST'},
    {'code': '90', 'description': 'Outras situações específicas'},
  ];

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'Código de Situação Tributária (CST)',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
          ),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'O CST mostra como o imposto se aplica à operação.',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...entries.map(
                  (entry) => _buildHelpDialogEntry(
                    entry['code']!,
                    entry['description']!,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Entendi',
              style: TextStyle(
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildCfopHelpIcon(BuildContext context) {
  return Tooltip(
    message: 'Ajuda rápida sobre CFOP',
    child: InkWell(
      onTap: () => _showCfopHelp(context),
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(
          Icons.help_outline,
          size: 18,
          color: AppColors.purple,
        ),
      ),
    ),
  );
}

Future<void> _showCfopHelp(BuildContext context) async {
  final groups = <Map<String, String>>[
    {'code': '1xxx', 'description': 'Entradas dentro do estado'},
    {'code': '2xxx', 'description': 'Entradas de outro estado'},
    {'code': '5xxx', 'description': 'Saídas dentro do estado'},
    {'code': '6xxx', 'description': 'Saídas para outro estado'},
    {'code': '7xxx', 'description': 'Operações com o exterior'},
  ];

  final examples = <Map<String, String>>[
    {'code': '1.101', 'description': 'Compra para industrialização'},
    {'code': '1.556', 'description': 'Compra para uso ou consumo interno'},
    {'code': '5.405', 'description': 'Venda sujeita à substituição tributária'},
    {'code': '6.102', 'description': 'Venda para comercialização fora do estado'},
  ];

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'Código Fiscal de Operações (CFOP)',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
          ),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'O CFOP descreve o tipo de operação (compra, venda, serviço).',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Primeiro dígito indica a origem/destino:',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                ...groups.map(
                  (group) => _buildHelpDialogEntry(
                    group['code']!,
                    group['description']!,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Exemplos úteis:',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                ...examples.map(
                  (example) => _buildHelpDialogEntry(
                    example['code']!,
                    example['description']!,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Entendi',
              style: TextStyle(
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          ),
        ],
      );
    },
  );
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
