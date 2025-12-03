import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart';
import '../../../helpers/accounts_receivable_helper.dart';
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
  late FormAccountsReceivableValidator validator;
  bool showValidationMessages = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;
    validator = FormAccountsReceivableValidator(
      descriptionRequired:
          l10n.accountsReceivable_form_error_description_required,
      financialConceptRequired:
          l10n.accountsReceivable_form_error_financial_concept_required,
      debtorNameRequired:
          l10n.accountsReceivable_form_error_debtor_name_required,
      debtorDniRequired:
          l10n.accountsReceivable_form_error_debtor_dni_required,
      debtorPhoneRequired:
          l10n.accountsReceivable_form_error_debtor_phone_required,
      debtorEmailRequired:
          l10n.accountsReceivable_form_error_debtor_email_required,
      totalAmountRequired:
          l10n.accountsReceivable_form_error_total_amount_required,
      singleDueDateRequired:
          l10n.accountsReceivable_form_error_single_due_date_required,
      installmentsRequired:
          l10n.accountsReceivable_form_error_installments_required,
      installmentsInvalid:
          l10n.accountsReceivable_form_error_installments_invalid,
      automaticInstallmentsRequired:
          l10n.accountsReceivable_form_error_automatic_installments_required,
      automaticAmountRequired:
          l10n.accountsReceivable_form_error_automatic_amount_required,
      automaticFirstDueDateRequired: l10n
          .accountsReceivable_form_error_automatic_first_due_date_required,
      installmentsCountMismatch:
          l10n.accountsReceivable_form_error_installments_count_mismatch,
    );
  }

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
    final List<FinancialConceptModel> incomeConcepts =
        conceptStore.state.financialConcepts
            .where(
              (concept) =>
                  concept.type == FinancialConceptType.INCOME.apiValue &&
                  concept.active,
            )
            .toList();

    final initialValue =
        incomeConcepts.any(
              (concept) =>
                  concept.financialConceptId ==
                  formStore.state.financialConceptId,
            )
            ? incomeConcepts
                .firstWhere(
                  (concept) =>
                      concept.financialConceptId ==
                      formStore.state.financialConceptId,
                )
                .name
            : null;

    return Dropdown(
      label: context.l10n.accountsReceivable_form_field_financial_concept,
      initialValue: initialValue,
      items: incomeConcepts.map((concept) => concept.name).toList(),
      onChanged: (value) {
        final selected = incomeConcepts.firstWhere(
          (concept) => concept.name == value,
        );
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
            context
                .l10n.accountsReceivable_form_installments_single_empty_message;
        break;
      case AccountsReceivablePaymentMode.automatic:
        paymentDetails = _AutomaticInstallmentsSection(
          formStore: formStore,
          validator: validator,
          showValidationMessages: showValidationMessages,
        );
        emptyMessage =
            context.l10n
                .accountsReceivable_form_installments_automatic_empty_message;
        break;
    }

    return _SectionCard(
      title: context.l10n.accountsReceivable_form_section_payment_title,
      subtitle:
          context
              .l10n.accountsReceivable_form_section_payment_subtitle,
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
      label: context.l10n.accountsReceivable_view_general_description,
      initialValue: formStore.state.description,
      onChanged: (value) => formStore.setDescription(value),
      onValidator: validator.byField(formStore.state, 'description'),
    );
  }

  Widget _accountTypeSelector(
    BuildContext context,
    FormAccountsReceivableStore formStore,
  ) {
    final types = AccountsReceivableType.values;
    final labels =
        types
            .map(
              (type) => getAccountsReceivableTypeLabel(context, type),
            )
            .toList(growable: false);

    final currentType = formStore.state.type;
    return Dropdown(
      label: context.l10n.accountsReceivable_form_field_type,
      labelSuffix: _buildAccountTypeHelpIcon(context),
      initialValue:
          currentType != null
              ? getAccountsReceivableTypeLabel(context, currentType)
              : null,
      items: labels,
      onChanged: (value) {
        final index = labels.indexOf(value);
        if (index >= 0) {
          formStore.setType(types[index]);
        }
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
    final l10n = context.l10n;
    final entries = [
      {
        'title': l10n.accountsReceivable_type_contribution_title,
        'description':
            l10n.accountsReceivable_type_contribution_description,
        'example': l10n.accountsReceivable_type_contribution_example,
      },
      {
        'title': l10n.accountsReceivable_type_service_title,
        'description': l10n.accountsReceivable_type_service_description,
        'example': l10n.accountsReceivable_type_service_example,
      },
      {
        'title': l10n.accountsReceivable_type_interinstitutional_title,
        'description':
            l10n.accountsReceivable_type_interinstitutional_description,
        'example': l10n.accountsReceivable_type_interinstitutional_example,
      },
      {
        'title': l10n.accountsReceivable_type_rental_title,
        'description': l10n.accountsReceivable_type_rental_description,
        'example': l10n.accountsReceivable_type_rental_example,
      },
      {
        'title': l10n.accountsReceivable_type_loan_title,
        'description': l10n.accountsReceivable_type_loan_description,
        'example': l10n.accountsReceivable_type_loan_example,
      },
      {
        'title': l10n.accountsReceivable_type_financial_title,
        'description': l10n.accountsReceivable_type_financial_description,
        'example': l10n.accountsReceivable_type_financial_example,
      },
      {
        'title': l10n.accountsReceivable_type_legal_title,
        'description': l10n.accountsReceivable_type_legal_description,
        'example': l10n.accountsReceivable_type_legal_example,
      },
    ];

    await ModalPage(
      title: l10n.accountsReceivable_type_help_title,
      width: 520,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.accountsReceivable_type_help_intro,
            style: const TextStyle(
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
          context.l10n.accountsReceivable_form_debtor_type_title,
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
            Text(context.l10n.accountsReceivable_form_debtor_type_member),
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
            Text(context.l10n.accountsReceivable_form_debtor_type_external),
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
            text: context.l10n.accountsReceivable_form_save,
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

      Toast.showMessage(
        context.l10n.accountsReceivable_form_toast_saved_success,
        ToastType.info,
      );
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
      Toast.showMessage(
        context.l10n.accountsReceivable_form_toast_saved_error,
        ToastType.error,
      );
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
      children:
          AccountsReceivablePaymentMode.values.map((mode) {
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
          label: context.l10n.accountsReceivable_view_general_total,
          initialValue:
              state.totalAmount > 0
                  ? CurrencyFormatter.formatCurrency(state.totalAmount)
                  : '',
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
          onChanged:
              (value) => formStore.setTotalAmount(
                value.trim().isEmpty
                    ? 0
                    : CurrencyFormatter.cleanCurrency(value),
              ),
          onValidator:
              (_) =>
                  showValidationMessages
                      ? validator.errorByKey(state, 'totalAmount')
                      : null,
        ),
        Input(
          label: context
              .l10n.accountsReceivable_form_field_single_due_date,
          initialValue: state.singleDueDate,
          onChanged: formStore.setSingleDueDate,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final pickedDate = await selectDate(context);
            if (pickedDate == null) return;
            final formatted = convertDateFormatToDDMMYYYY(
              pickedDate.toString(),
            );
            formStore.setSingleDueDate(formatted);
          },
          onValidator:
              (_) =>
                  showValidationMessages
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
                label: context
                    .l10n.accountsReceivable_form_field_automatic_installments,
                initialValue:
                    state.automaticInstallments > 0
                        ? state.automaticInstallments.toString()
                        : '',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged:
                    (value) => formStore.setAutomaticInstallments(
                      int.tryParse(value) ?? 0,
                    ),
                onValidator:
                    (_) =>
                        showValidationMessages
                            ? validator.errorByKey(
                              state,
                              'automaticInstallments',
                            )
                            : null,
              ),
            ),
            SizedBox(
              width: 220,
              child: Input(
                label: context
                    .l10n.accountsReceivable_form_field_automatic_amount,
                initialValue:
                    state.automaticInstallmentAmount > 0
                        ? CurrencyFormatter.formatCurrency(
                          state.automaticInstallmentAmount,
                        )
                        : '',
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
                onChanged:
                    (value) => formStore.setAutomaticInstallmentAmount(
                      value.trim().isEmpty
                          ? 0
                          : CurrencyFormatter.cleanCurrency(value),
                    ),
                onValidator:
                    (_) =>
                        showValidationMessages
                            ? validator.errorByKey(
                              state,
                              'automaticInstallmentAmount',
                            )
                            : null,
              ),
            ),
            SizedBox(
              width: 220,
              child: Input(
                label: context
                    .l10n
                    .accountsReceivable_form_field_automatic_first_due_date,
                initialValue: state.automaticFirstDueDate,
                onChanged: formStore.setAutomaticFirstDueDate,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final pickedDate = await selectDate(context);
                  if (pickedDate == null) return;
                  final formatted = convertDateFormatToDDMMYYYY(
                    pickedDate.toString(),
                  );
                  formStore.setAutomaticFirstDueDate(formatted);
                },
                onValidator:
                    (_) =>
                        showValidationMessages
                            ? validator.errorByKey(
                              state,
                              'automaticFirstDueDate',
                            )
                            : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ButtonActionTable(
          color: AppColors.blue,
          text:
              context.l10n.accountsReceivable_form_generate_installments,
          icon: Icons.calculate_outlined,
          onPressed: () => _handleGenerateAutomatic(context),
        ),
      ],
    );
  }

  void _handleGenerateAutomatic(BuildContext context) {
    final l10n = context.l10n;
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
        message ??
            l10n
                .accountsReceivable_form_error_generate_installments_fill_data,
        ToastType.warning,
      );
      return;
    }

    Toast.showMessage(
      l10n.accountsReceivable_form_toast_generate_installments_success,
      ToastType.info,
    );
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
          context.l10n.accountsReceivable_form_installments_summary_title,
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
                                context.l10n
                                    .accountsReceivable_form_installment_item_title(
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
                                ),
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.l10n
                                    .accountsReceivable_form_installment_item_due_date(
                                  installment.dueDate,
                                ),
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
                  context.l10n
                      .accountsReceivable_form_installments_summary_total(
                    CurrencyFormatter.formatCurrency(totalAmount),
                  ),
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
