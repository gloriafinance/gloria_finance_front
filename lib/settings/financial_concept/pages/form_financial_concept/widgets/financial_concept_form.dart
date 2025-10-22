import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/helpers/index.dart';
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
        child: isMobile(context)
            ? _buildMobileLayout(context, formStore)
            : _buildDesktopLayout(context, formStore),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameField(formStore),
        _buildDescriptionField(formStore),
        _buildTypeField(formStore),
        _buildStatementCategoryField(context, formStore),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildNameField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildTypeField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDescriptionField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildStatementCategoryField(context, formStore)),
          ],
        ),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildNameField(FinancialConceptFormStore formStore) {
    return Input(
      label: 'Nome',
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setName,
    );
  }

  Widget _buildDescriptionField(FinancialConceptFormStore formStore) {
    return Input(
      label: 'Descrição',
      initialValue: formStore.state.description,
      onValidator: _requiredValidator,
      onChanged: formStore.setDescription,
    );
  }

  Widget _buildTypeField(FinancialConceptFormStore formStore) {
    return Dropdown(
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
    );
  }

  Widget _buildStatementCategoryField(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Dropdown(
      label: 'Categoria do demonstrativo',
      labelSuffix: _buildStatementCategoryHelpIcon(context),
      initialValue: formStore.state.statementCategory?.friendlyName,
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
    );
  }

  Widget _buildActiveToggle(FinancialConceptFormStore formStore) {
    return Row(
      children: [
        const Text(
          'Ativo',
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          activeColor: AppColors.purple,
          value: formStore.state.active,
          onChanged: formStore.setActive,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FinancialConceptFormStore formStore) {
    return Align(
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
    );
  }

  Widget _buildStatementCategoryHelpIcon(BuildContext context) {
    return Tooltip(
      message: 'Entenda as categorias',
      child: InkWell(
        onTap: () => _showStatementCategoryHelp(context),
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

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  void _showStatementCategoryHelp(BuildContext context) {
    final entries = [
      {
        'code': StatementCategory.COGS.apiValue,
        'description': StatementCategory.COGS.friendlyName,
        'example':
            'Ex.: compra de materiais para ações sociais ou contratação pontual de músicos para um retiro.'
      },
      {
        'code': StatementCategory.REVENUE.apiValue,
        'description': StatementCategory.REVENUE.friendlyName,
        'example':
            'Ex.: dízimos, ofertas recorrentes e contribuições mensais de parceiros.'
      },
      {
        'code': StatementCategory.OPEX.apiValue,
        'description': StatementCategory.OPEX.friendlyName,
        'example':
            'Ex.: contas de água e energia do templo, salários da equipe administrativa.'
      },
      {
        'code': StatementCategory.CAPEX.apiValue,
        'description': StatementCategory.CAPEX.friendlyName,
        'example':
            'Ex.: compra de um projetor multimídia ou reforma estrutural do prédio.'
      },
      {
        'code': StatementCategory.OTHER.apiValue,
        'description': StatementCategory.OTHER.friendlyName,
        'example':
            'Ex.: venda de equipamento antigo ou ressarcimento de um seguro.'
      },
    ];

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Categorias do demonstrativo',
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
                children: entries
                    .map(
                      (entry) => _buildCategoryHelpEntry(
                        entry['code']!,
                        entry['description']!,
                        entry['example']!,
                      ),
                    )
                    .toList(),
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

  Widget _buildCategoryHelpEntry(
    String code,
    String description,
    String example,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$code · $description',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
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
