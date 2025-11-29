import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/features/erp/bank_statements/store/bank_statement_import_store.dart';
import 'package:church_finance_bk/features/erp/contributions/pages/app_contribuitions/widgets/month_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bank_statement_file_picker.dart';

class BankStatementImportSheet extends StatefulWidget {
  const BankStatementImportSheet({super.key});

  @override
  State<BankStatementImportSheet> createState() =>
      _BankStatementImportSheetState();
}

class _BankStatementImportSheetState extends State<BankStatementImportSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isMobileLayout = isMobile(context);
    final bankStore = context.watch<BankStore>();
    final importStore = context.watch<BankStatementImportStore>();
    final state = importStore.state;

    final monthItems =
        monthDropdown(context)
            .map(
              (item) => DropdownMenuItem<String>(
                value: item.value.toString(),
                child: item.child,
              ),
            )
            .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Importar extrato bancário',
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:
                        state.importing
                            ? null
                            : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _FormFields(
                isMobile: isMobileLayout,
                submitting: state.importing,
                bankValue: state.bankId,
                monthValue: state.month?.toString(),
                yearValue: state.year,
                bankItems:
                    bankStore.state.banks
                        .map(
                          (bank) => DropdownMenuItem<String>(
                            value: bank.bankId,
                            child: Text('${bank.name} (${bank.tag})'),
                          ),
                        )
                        .toList(),
                monthItems: monthItems,
                onBankChanged:
                    (value) => context
                        .read<BankStatementImportStore>()
                        .setBankId(value),
                onMonthChanged:
                    (value) => context
                        .read<BankStatementImportStore>()
                        .setMonth(value != null ? int.tryParse(value) : null),
                onYearChanged:
                    (value) =>
                        context.read<BankStatementImportStore>().setYear(value),
              ),
              const SizedBox(height: 24),
              const Text(
                'Arquivo CSV',
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 15,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(height: 12),
              BankStatementFilePicker(
                onFileSelected: (file) {
                  context.read<BankStatementImportStore>().setFile(file);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon:
                      state.importing
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    state.importing ? 'Enviando...' : 'Enviar extrato',
                  ),
                  onPressed:
                      state.importing ? null : () => _handleSubmit(context),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final importStore = context.read<BankStatementImportStore>();

    if (!importStore.state.isValid) {
      Toast.showMessage(
        'Preencha todos os campos e selecione um arquivo CSV.',
        ToastType.warning,
      );
      return;
    }

    try {
      await importStore.importStatement();
      //await context.read<BankStatementListStore>().fetchStatements();

      Toast.showMessage('Extrato importado com sucesso.', ToastType.info);

      if (mounted) {
        importStore.reset();
        Navigator.of(context).pop();
      }
    } catch (e) {
      Toast.showMessage(
        'Não foi possível importar o extrato. Verifique os dados e tente novamente.',
        ToastType.error,
      );
    }
  }
}

class _FormFields extends StatelessWidget {
  final bool isMobile;
  final bool submitting;
  final String? bankValue;
  final String? monthValue;
  final int? yearValue;
  final List<DropdownMenuItem<String>> bankItems;
  final List<DropdownMenuItem<String>> monthItems;
  final ValueChanged<String?> onBankChanged;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  const _FormFields({
    required this.isMobile,
    required this.submitting,
    required this.bankValue,
    required this.monthValue,
    required this.yearValue,
    required this.bankItems,
    required this.monthItems,
    required this.onBankChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bankField = DropdownButtonFormField<String>(
      value: bankValue,
      items: bankItems,
      onChanged: submitting ? null : onBankChanged,
      decoration: _fieldDecoration('Banco'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione um banco.';
        }
        return null;
      },
    );

    final monthField = DropdownButtonFormField<String>(
      value: monthValue,
      items: monthItems,
      onChanged: submitting ? null : onMonthChanged,
      decoration: _fieldDecoration('Mês'),
      validator:
          (value) => value == null || value.isEmpty ? 'Informe o mês.' : null,
    );

    final yearField = TextFormField(
      initialValue: yearValue?.toString(),
      keyboardType: TextInputType.number,
      decoration: _fieldDecoration('Ano'),
      enabled: !submitting,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o ano.';
        }

        final parsed = int.tryParse(value);
        if (parsed == null || parsed < 2000) {
          return 'Ano inválido.';
        }

        return null;
      },
      onChanged: (value) {
        if (value.isEmpty) {
          onYearChanged(null);
          return;
        }

        final parsed = int.tryParse(value);
        if (parsed != null) {
          onYearChanged(parsed);
        }
      },
    );

    if (isMobile) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: bankField),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: monthField),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: yearField),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: bankField),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: monthField),
        const SizedBox(width: 16),
        Expanded(flex: 1, child: yearField),
      ],
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      fontFamily: AppFonts.fontSubTitle,
      color: AppColors.purple,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.greyMiddle),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.greyMiddle),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.blue),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
