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

import '../../../models/index.dart';
import '../store/form_accounts_receivable_store.dart';
import '../validators/form_accounts_receivable_validator.dart';
import 'external_debtor_form.dart';
import 'member_selector.dart';

class FormAccountsReceivable extends StatefulWidget {
  const FormAccountsReceivable({super.key});

  @override
  State<FormAccountsReceivable> createState() => _FormAccountsReceivableState();
}

class _FormAccountsReceivableState extends State<FormAccountsReceivable> {
  final formKey = GlobalKey<FormState>();
  final validator = FormAccountsReceivableValidator();
  bool showValidationMessages = false;

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

            _paymentConfigurationSection(
              context,
              formStore,
              showValidationMessages,
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

  Widget _paymentConfigurationSection(
    BuildContext context,
    FormAccountsReceivableStore formStore,
    bool showValidationMessages,
  ) {
    final state = formStore.state;

    Widget paymentDetails;
    String emptyMessage;

    switch (state.paymentMode) {
      case AccountsReceivablePaymentMode.single:
        paymentDetails = _SinglePaymentSection(
          formStore: formStore,
          validator: validator,
          showValidationMessages: showValidationMessages,
        );
        emptyMessage =
            'Informe o valor e a data de vencimento para visualizar o resumo.';
        break;
      case AccountsReceivablePaymentMode.automatic:
        paymentDetails = _AutomaticInstallmentsSection(
          formStore: formStore,
          validator: validator,
          showValidationMessages: showValidationMessages,
        );
        emptyMessage =
            'Informe os dados e clique em "Gerar parcelas" para visualizar o cronograma.';
        break;
    }

    return _SectionCard(
      title: 'Configuração do recebimento',
      subtitle:
          'Defina como essa conta será cobrada e revise o cronograma de parcelas.',
      children: [
        _PaymentModeSelector(formStore: formStore),
        const SizedBox(height: 20),
        paymentDetails,
        const SizedBox(height: 16),
        _InstallmentsPreviewSection(
          formStore: formStore,
          validator: validator,
          showValidationMessages: showValidationMessages,
          emptyMessage: emptyMessage,
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
    return formStore.state.makeRequest
        ? const Loading()
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomButton(
              text: "Salvar",
              backgroundColor: AppColors.green,
              textColor: Colors.black,
              onPressed: () => _saveRecord(formStore),
            ),
          );
  }

  void _saveRecord(FormAccountsReceivableStore formStore) async {
    setState(() {
      showValidationMessages = true;
    });

    final isValidForm = formKey.currentState?.validate() ?? false;
    final errors = validator.validateState(formStore.state);

    if (!isValidForm || errors.isNotEmpty) {
      if (errors.isNotEmpty) {
        Toast.showMessage(errors.values.first, ToastType.warning);
      }
      return;
    }

    try {
      await formStore.save();
      if (!mounted) return;

      Toast.showMessage('Conta a receber registrada com sucesso!', ToastType.info);
      setState(() {
        showValidationMessages = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go('/accounts-receivables');
        }
      });
    } catch (e) {
      if (!mounted) return;
      Toast.showMessage('Erro ao registrar conta a receber', ToastType.error);
    }
  }
}

class _PaymentModeSelector extends StatelessWidget {
  final FormAccountsReceivableStore formStore;

  const _PaymentModeSelector({required this.formStore});

  @override
  Widget build(BuildContext context) {
    final selectedMode = formStore.state.paymentMode;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AccountsReceivablePaymentMode.values.map((mode) {
        final isSelected = mode == selectedMode;
        return ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
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

class _SinglePaymentSection extends StatelessWidget {
  final FormAccountsReceivableStore formStore;
  final FormAccountsReceivableValidator validator;
  final bool showValidationMessages;

  const _SinglePaymentSection({
    required this.formStore,
    required this.validator,
    required this.showValidationMessages,
  });

  @override
  Widget build(BuildContext context) {
    final state = formStore.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Input(
          label: 'Valor total',
          initialValue: state.totalAmount > 0
              ? CurrencyFormatter.formatCurrency(state.totalAmount)
              : '',
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
          onChanged: (value) => formStore.setTotalAmount(
            value.trim().isEmpty
                ? 0
                : CurrencyFormatter.cleanCurrency(value),
          ),
          onValidator: (_) => showValidationMessages
              ? validator.errorByKey(state, 'totalAmount')
              : null,
        ),
        Input(
          label: 'Data de vencimento',
          initialValue: state.singleDueDate,
          onChanged: formStore.setSingleDueDate,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final pickedDate = await selectDate(context);
            if (pickedDate == null) return;
            final formatted = convertDateFormatToDDMMYYYY(pickedDate.toString());
            formStore.setSingleDueDate(formatted);
          },
          onValidator: (_) => showValidationMessages
              ? validator.errorByKey(state, 'singleDueDate')
              : null,
        ),
      ],
    );
  }
}

class _AutomaticInstallmentsSection extends StatelessWidget {
  final FormAccountsReceivableStore formStore;
  final FormAccountsReceivableValidator validator;
  final bool showValidationMessages;

  const _AutomaticInstallmentsSection({
    required this.formStore,
    required this.validator,
    required this.showValidationMessages,
  });

  @override
  Widget build(BuildContext context) {
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
                  int.tryParse(value) ?? 0,
                ),
                onValidator: (_) => showValidationMessages
                    ? validator.errorByKey(state, 'automaticInstallments')
                    : null,
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
                onValidator: (_) => showValidationMessages
                    ? validator.errorByKey(state, 'automaticInstallmentAmount')
                    : null,
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
                onValidator: (_) => showValidationMessages
                    ? validator.errorByKey(state, 'automaticFirstDueDate')
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ButtonActionTable(
          color: AppColors.blue,
          text: 'Gerar parcelas',
          icon: Icons.calculate_outlined,
          onPressed: () => _handleGenerateAutomatic(context),
        ),
      ],
    );
  }

  void _handleGenerateAutomatic(BuildContext context) {
    final success = formStore.generateAutomaticInstallments();

    if (!success) {
      final errors = validator.validateState(formStore.state);
      final keys = [
        'automaticInstallments',
        'automaticInstallmentAmount',
        'automaticFirstDueDate',
        'installments',
      ];

      String? message;
      for (final key in keys) {
        if (errors.containsKey(key)) {
          message = errors[key];
          break;
        }
      }

      Toast.showMessage(
        message ?? 'Preencha os dados para gerar as parcelas.',
        ToastType.warning,
      );
      return;
    }

    Toast.showMessage('Parcelas geradas automaticamente.', ToastType.info);
  }
}

class _InstallmentsPreviewSection extends StatelessWidget {
  final FormAccountsReceivableStore formStore;
  final FormAccountsReceivableValidator validator;
  final bool showValidationMessages;
  final String emptyMessage;

  const _InstallmentsPreviewSection({
    required this.formStore,
    required this.validator,
    required this.showValidationMessages,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final installments = formStore.state.installments;
    final totalAmount = installments.fold<double>(
      0,
      (sum, installment) => sum + installment.amount,
    );

    String? errorMessage;
    if (showValidationMessages) {
      final keys = [
        'installments',
        'installments_contents',
        'installments_count',
      ];
      for (final key in keys) {
        final error = validator.errorByKey(formStore.state, key);
        if (error != null) {
          errorMessage = error;
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo das parcelas',
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
              emptyMessage,
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Parcela ${index + 1}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontTitle,
                                  fontSize: 15,
                                  color: AppColors.purple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter
                                    .formatCurrency(installment.amount),
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Vencimento: ${installment.dueDate}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
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
                child: Text(
                  'Total: ${CurrencyFormatter.formatCurrency(totalAmount)}',
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
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
