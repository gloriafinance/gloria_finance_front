import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../models/installment_model.dart';
import '../../../models/index.dart';
import '../store/form_accounts_receivable_store.dart';
import '../validators/form_accounts_receivable_validator.dart';
import 'external_debtor_form.dart';
import 'installment_form.dart';
import 'installments_table.dart';
import 'member_selector.dart';

class FormAccountsReceivable extends StatefulWidget {
  const FormAccountsReceivable({super.key});

  @override
  State<FormAccountsReceivable> createState() => _FormAccountsReceivableState();
}

class _FormAccountsReceivableState extends State<FormAccountsReceivable> {
  final formKey = GlobalKey<FormState>();
  final validator = FormAccountsReceivableValidator();

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormAccountsReceivableStore>(context);
    final conceptStore = context.watch<FinancialConceptStore>();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),

            // Tipo de deudor selector
            _debtorTypeSelector(formStore),
            SizedBox(height: 20),

            // Campos según el tipo de deudor
            formStore.state.debtorType == DebtorType.MEMBER
                ? MemberSelector(formStore: formStore)
                : ExternalDebtorForm(
                  formStore: formStore,
                  validator: validator,
                ),

            SizedBox(height: 20),

            _accountTypeSelector(context, formStore),

            SizedBox(height: 20),

            _financialConceptSelector(formStore, conceptStore),

            SizedBox(height: 20),

            _description(formStore, validator),

            SizedBox(height: 20),

            _automaticInstallmentsSection(formStore),

            SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Registrar parcelas',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  fontFamily: AppFonts.fontSubTitle,
                ),
              ),
            ),
            _btnAddItem(formStore),
            formStore.state.installments.isNotEmpty
                ? InstallmentsTable(
                  installments: formStore.state.installments,
                  onRemove: (index) => formStore.removeInstallment(index),
                )
                : Center(
                  child: Text(
                    'Nenhuma parcela adicionada',
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                  ),
                ),

            // SizedBox(height: 30),
            isMobile(context)
                ? _btnSave(formStore)
                : Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 300, child: _btnSave(formStore)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _financialConceptSelector(
    FormAccountsReceivableStore formStore,
    FinancialConceptStore conceptStore,
  ) {
    final List<FinancialConceptModel> incomeConcepts = conceptStore
        .state.financialConcepts
        .where((concept) =>
            concept.type == FinancialConceptType.INCOME.apiValue &&
            concept.active)
        .toList();

    final initialValue = incomeConcepts.any((concept) =>
            concept.financialConceptId ==
            formStore.state.financialConceptId)
        ? incomeConcepts
            .firstWhere((concept) =>
                concept.financialConceptId ==
                formStore.state.financialConceptId)
            .name
        : null;

    return Dropdown(
      label: 'Conceito financeiro',
      initialValue: initialValue,
      items: incomeConcepts.map((concept) => concept.name).toList(),
      onChanged: (value) {
        final selected = incomeConcepts.firstWhere((concept) => concept.name == value);
        formStore.setFinancialConceptId(selected.financialConceptId);
      },
      onValidator: validator.byField(formStore.state, 'financialConceptId'),
    );
  }

  Widget _automaticInstallmentsSection(
    FormAccountsReceivableStore formStore,
  ) {
    final state = formStore.state;

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
                label: 'Quantidade de parcelas',
                initialValue: state.automaticInstallments > 0
                    ? state.automaticInstallments.toString()
                    : '',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => formStore.setAutomaticInstallments(
                    int.tryParse(value) ?? 0),
              ),
            ),
            SizedBox(
              width: 220,
              child: Input(
                label: 'Valor por parcela',
                initialValue: state.automaticInstallmentAmount > 0
                    ? CurrencyFormatter
                        .formatCurrency(state.automaticInstallmentAmount)
                    : '',
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
                onChanged: (value) => formStore.setAutomaticInstallmentAmount(
                  value.trim().isEmpty
                      ? 0
                      : CurrencyFormatter.cleanCurrency(value),
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: Input(
                label: 'Primeiro vencimento',
                initialValue: state.automaticFirstDueDate,
                onChanged: formStore.setAutomaticFirstDueDate,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final pickedDate = await selectDate(context);
                  if (pickedDate == null) return;
                  final formatted =
                      convertDateFormatToDDMMYYYY(pickedDate.toString());
                  formStore.setAutomaticFirstDueDate(formatted);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ButtonActionTable(
          color: AppColors.blue,
          text: 'Gerar parcelas automaticamente',
          icon: Icons.calculate_outlined,
          onPressed: () {
            final generated = formStore.generateAutomaticInstallments();
            if (!generated) {
              Toast.showMessage(
                'Preencha os dados para gerar as parcelas automaticamente.',
                ToastType.warning,
              );
              return;
            }

            Toast.showMessage(
              'Parcelas geradas automaticamente.',
              ToastType.info,
            );
          },
        ),
      ],
    );
  }

  Widget _description(
    FormAccountsReceivableStore formStore,
    FormAccountsReceivableValidator validator,
  ) {
    return Input(
      label: 'Descrição',
      initialValue: formStore.state.description,
      onChanged: (value) => formStore.setDescription(value),
      onValidator: validator.byField(formStore.state, 'description'),
    );
  }

  Widget _btnAddItem(FormAccountsReceivableStore formStore) {
    return Row(
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: "Adicionar parcela",
          onPressed: () {
            ModalPage(
              title: "Adicionar parcela",
              body: InstallmentForm(
                onCallback: (InstallmentModel item) {
                  formStore.addInstallment(item);
                },
                formStore: formStore,
              ),
            ).show(context);
          },
          icon: Icons.add_box_outlined,
        ),
      ],
    );
  }

  Widget _accountTypeSelector(
    BuildContext context,
    FormAccountsReceivableStore formStore,
  ) {
    return Dropdown(
      label: 'Tipo de Conta',
      labelSuffix: _buildAccountTypeHelpIcon(context),
      initialValue: formStore.state.type.friendlyName,
      items:
          AccountsReceivableType.values
              .map((type) => type.friendlyName)
              .toList(),
      onChanged: (value) {
        final selectedType = AccountsReceivableType.values.firstWhere(
          (element) => element.friendlyName == value,
        );
        formStore.setType(selectedType);
      },
    );
  }

  Widget _buildAccountTypeHelpIcon(BuildContext context) {
    return InkWell(
      onTap: () => _showAccountTypeHelp(context),
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(Icons.help_outline, size: 18, color: AppColors.purple),
      ),
    );
  }

  Future<void> _showAccountTypeHelp(BuildContext context) async {
    final entries = [
      {
        'title': 'CONTRIBUIÇÃO',
        'description': 'Compromissos voluntários assumidos por membros ou grupos.',
        'example': 'Ex.: campanhas de missões, ofertas recorrentes, doações especiais.'
      },
      {
        'title': 'SERVIÇO',
        'description': 'Cobranças por atividades ou serviços prestados pela igreja.',
        'example': 'Ex.: cursos de música, conferências, aluguel de buffet do evento.'
      },
      {
        'title': 'INTERINSTITUCIONAL',
        'description': 'Valores decorrentes de parcerias com outras instituições.',
        'example': 'Ex.: apoio em eventos conjuntos, convênios com outra igreja.'
      },
      {
        'title': 'LOCAÇÃO',
        'description': 'Empréstimo remunerado de espaços, veículos ou equipamentos.',
        'example': 'Ex.: aluguel do auditório, locação de instrumentos ou cadeiras.'
      },
      {
        'title': 'EMPRÉSTIMO',
        'description': 'Recursos concedidos pela igreja que devem ser devolvidos.',
        'example': 'Ex.: adiantamento a ministérios, apoio financeiro temporário.'
      },
      {
        'title': 'FINANCEIRO',
        'description': 'Movimentos bancários que ainda aguardam compensação.',
        'example': 'Ex.: cheques em processamento, adquirência de cartão, devoluções.'
      },
      {
        'title': 'JURÍDICO',
        'description': 'Cobranças relacionadas a ações judiciais, seguros ou indenizações.',
        'example': 'Ex.: cumprimento de sentença, sinistros cobertos por seguradora.'
      },
    ];

    await ModalPage(
      title: 'Como classificar o tipo da conta',
      width: 520,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Escolha o tipo que melhor descreve a origem do valor a receber.',
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildAccountTypeHelpEntry(
                entry['title']!,
                entry['description']!,
                entry['example']!,
              ),
            ),
          ),
        ],
      ),
    ).show(context);
  }

  Widget _buildAccountTypeHelpEntry(
    String title,
    String description,
    String example,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          example,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 13,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _debtorTypeSelector(FormAccountsReceivableStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Deudor',
          style: TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Radio<DebtorType>(
              value: DebtorType.MEMBER,
              groupValue: formStore.state.debtorType,
              onChanged: (value) {
                if (value != null) {
                  formStore.setDebtorType(value);
                }
              },
            ),
            Text('Membro da Igreja'),
            SizedBox(width: 20),
            Radio<DebtorType>(
              value: DebtorType.EXTERNAL,
              groupValue: formStore.state.debtorType,
              onChanged: (value) {
                if (value != null) {
                  formStore.setDebtorType(value);
                }
              },
            ),
            Text('Externo'),
          ],
        ),
      ],
    );
  }

  Widget _btnSave(FormAccountsReceivableStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
          padding: EdgeInsets.only(top: 20),
          child: CustomButton(
            text: "Salvar",
            backgroundColor: AppColors.green,
            textColor: Colors.black,
            onPressed: () => _saveRecord(formStore),
          ),
        );
  }

  void _saveRecord(FormAccountsReceivableStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (formStore.state.installments.isEmpty) {
      Toast.showMessage('Adicione pelo menos uma parcela', ToastType.warning);
      return;
    }

    try {
      await formStore.save();
      Toast.showMessage('Empréstimo salvo com sucesso', ToastType.info);
      Future.delayed(Duration(seconds: 1), () {
        context.go('/accounts-receivables');
      });
    } catch (e) {
      Toast.showMessage('Erro ao salvar o empréstimo', ToastType.error);
    }
  }
}
