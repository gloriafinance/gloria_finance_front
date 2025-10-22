import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:church_finance_bk/settings/financial_concept/pages/form_financial_concept/store/financial_concept_form_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FinancialConceptForm extends StatefulWidget {
  const FinancialConceptForm({super.key});

  @override
  State<FinancialConceptForm> createState() => _FinancialConceptFormState();
}

class _FinancialConceptFormState extends State<FinancialConceptForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = context.watch<FinancialConceptFormStore>();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Input(
              label: 'Nome',
              initialValue: formStore.state.name,
              onValidator: _requiredValidator,
              onChanged: formStore.setName,
            ),
            Input(
              label: 'Descrição',
              initialValue: formStore.state.description,
              onValidator: _requiredValidator,
              onChanged: formStore.setDescription,
            ),
            Dropdown(
              label: 'Tipo de conceito',
              initialValue: formStore.state.type?.friendlyName,
              items: FinancialConceptTypeExtension.listFriendlyName,
              onValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione o tipo';
                }
                return null;
              },
              onChanged: (value) {
                final selected = FinancialConceptType.values.firstWhere(
                  (element) => element.friendlyName == value,
                );
                formStore.setType(selected);
              },
            ),
            Dropdown(
              label: 'Categoria do demonstrativo',
              initialValue:
                  formStore.state.statementCategory?.friendlyName,
              items: StatementCategoryExtension.listFriendlyName,
              onValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione a categoria';
                }
                return null;
              },
              onChanged: (value) {
                final selected = StatementCategoryExtension.fromFriendlyName(
                  value,
                );
                formStore.setStatementCategory(selected);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Ativo',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 16,
                  ),
                ),
                Switch(
                  activeColor: AppColors.purple,
                  value: formStore.state.active,
                  onChanged: formStore.setActive,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 220,
                child: formStore.state.makeRequest
                    ? const Loading()
                    : CustomButton(
                        text: 'Salvar',
                        backgroundColor: AppColors.green,
                        textColor: Colors.black,
                        onPressed: () => _save(formStore),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<void> _save(FinancialConceptFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success = await formStore.submit();

    if (success && mounted) {
      Toast.showMessage('Registro salvo com sucesso', ToastType.info);
      final conceptStore = context.read<FinancialConceptStore>();
      await conceptStore.searchFinancialConcepts();
      context.go('/financial-concepts');
    }
  }
}
