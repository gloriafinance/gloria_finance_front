import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';

class InstallmentAccountPayableForm extends StatelessWidget {
  final FormAccountsPayableStore formStore;
  final FormAccountsPayableValidator validator;
  final bool showValidationMessages;

  const InstallmentAccountPayableForm({
    super.key,
    required this.formStore,
    required this.validator,
    required this.showValidationMessages,
  });

  @override
  Widget build(BuildContext context) {
    final state = formStore.state;

    switch (state.paymentMode) {
      case AccountsPayablePaymentMode.single:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SinglePaymentSection(
              formStore: formStore,
              validator: validator,
            ),
            const SizedBox(height: 16),
            _InstallmentsPreviewSection(
              formStore: formStore,
              validator: validator,
              showValidationMessages: showValidationMessages,
              emptyMessage:
                  'Informe o valor e a data de vencimento para visualizar o resumo.',
            ),
          ],
        );
      case AccountsPayablePaymentMode.automatic:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AutomaticInstallmentsSection(
              formStore: formStore,
              validator: validator,
            ),
            const SizedBox(height: 16),
            _InstallmentsPreviewSection(
              formStore: formStore,
              validator: validator,
              showValidationMessages: showValidationMessages,
              emptyMessage:
                  'Informe os dados e clique em "Gerar parcelas" para visualizar o cronograma.',
            ),
          ],
        );
      case AccountsPayablePaymentMode.manual:
        return const SizedBox.shrink();
    }
  }
}

class _SinglePaymentSection extends StatelessWidget {
  final FormAccountsPayableStore formStore;
  final FormAccountsPayableValidator validator;

  const _SinglePaymentSection({
    required this.formStore,
    required this.validator,
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
          onChanged: (value) => formStore
              .setTotalAmount(CurrencyFormatter.cleanCurrency(value)),
          onValidator: (_) => validator.errorByKey(state, 'totalAmount'),
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
          onValidator: (_) => validator.errorByKey(state, 'singleDueDate'),
        ),
      ],
    );
  }
}

class _AutomaticInstallmentsSection extends StatelessWidget {
  final FormAccountsPayableStore formStore;
  final FormAccountsPayableValidator validator;

  const _AutomaticInstallmentsSection({
    required this.formStore,
    required this.validator,
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
                    int.tryParse(value) ?? 0),
                onValidator: (_) =>
                    validator.errorByKey(state, 'automaticInstallments'),
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
                    CurrencyFormatter.cleanCurrency(value)),
                onValidator: (_) => validator
                    .errorByKey(state, 'automaticInstallmentAmount'),
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
                onValidator: (_) =>
                    validator.errorByKey(state, 'automaticFirstDueDate'),
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

    Toast.showMessage('Parcelas geradas com sucesso.', ToastType.info);
  }
}

class _InstallmentsPreviewSection extends StatelessWidget {
  final FormAccountsPayableStore formStore;
  final FormAccountsPayableValidator validator;
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
      (acc, installment) => acc + installment.amount,
    );

    final errorMessage = showValidationMessages
        ? validator.errorByKey(formStore.state, 'installments')
        : null;

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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
}
