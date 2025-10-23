import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_payable_state.dart';

class FormAccountsPayableValidator
    extends LucidValidator<FormAccountsPayableState> {
  FormAccountsPayableValidator() {
    ruleFor((m) => m.supplierId, key: 'supplierId')
        .notEmpty(message: 'O fornecedor é obrigatório');

    ruleFor((m) => m.description, key: 'description')
        .notEmpty(message: 'A descrição é obrigatória');

    ruleFor((m) => m.documentType, key: 'documentType').when(
        (m) => m.includeDocument,
        must: (value) => value != null,
        otherwise: (_) => true,
        message: 'Selecione o tipo de documento');

    ruleFor((m) => m.documentNumber, key: 'documentNumber').when(
        (m) => m.includeDocument,
        must: (value) => value.isNotEmpty,
        otherwise: (_) => true,
        message: 'Informe o número do documento');

    ruleFor((m) => m.documentIssueDate, key: 'documentIssueDate').when(
        (m) => m.includeDocument,
        must: (value) => value.isNotEmpty,
        otherwise: (_) => true,
        message: 'Informe a data de emissão');

    ruleFor((m) => m.totalAmount, key: 'totalAmount').when(
        (m) =>
            m.paymentMode == AccountsPayablePaymentMode.single ||
            m.paymentMode == AccountsPayablePaymentMode.automatic,
        must: (value) => value > 0,
        otherwise: (_) => true,
        message: 'Informe um valor maior que zero');

    ruleFor((m) => m.singleDueDate, key: 'singleDueDate').when(
        (m) => m.paymentMode == AccountsPayablePaymentMode.single,
        must: (value) => value.isNotEmpty,
        otherwise: (_) => true,
        message: 'Informe a data de vencimento');

    ruleFor((m) => m.installments, key: 'installments').when(
        (m) => m.paymentMode != AccountsPayablePaymentMode.single,
        must: (installments) => installments.isNotEmpty,
        otherwise: (_) => true,
        message: 'Gere ou adicione ao menos uma parcela');

    ruleFor((m) => m.installments, key: 'installmentsContents').when(
      (m) => m.paymentMode != AccountsPayablePaymentMode.single,
      must: (installments) => installments.every(
        (installment) =>
            installment.amount > 0 && installment.dueDate.isNotEmpty,
      ),
      otherwise: (_) => true,
      message: 'Preencha valor e vencimento de cada parcela',
    );

    ruleFor((m) => m.automaticInstallments, key: 'automaticInstallments').when(
        (m) => m.paymentMode == AccountsPayablePaymentMode.automatic,
        must: (value) => value > 0,
        otherwise: (_) => true,
        message: 'Informe a quantidade de parcelas');

    ruleFor((m) => m.automaticInstallmentAmount,
            key: 'automaticInstallmentAmount')
        .when(
            (m) => m.paymentMode == AccountsPayablePaymentMode.automatic,
            must: (value) => value > 0,
            otherwise: (_) => true,
            message: 'Informe o valor por parcela');

    ruleFor((m) => m.automaticFirstDueDate,
            key: 'automaticFirstDueDate')
        .when(
            (m) => m.paymentMode == AccountsPayablePaymentMode.automatic,
            must: (value) => value.isNotEmpty,
            otherwise: (_) => true,
            message: 'Informe a data da primeira parcela');
  }

  Map<String, String> validateState(FormAccountsPayableState state) {
    final Map<String, String> errors = {};

    if (state.supplierId.isEmpty) {
      errors['supplierId'] = 'O fornecedor é obrigatório';
    }

    if (state.description.isEmpty) {
      errors['description'] = 'A descrição é obrigatória';
    }

    if (state.includeDocument) {
      if (state.documentType == null) {
        errors['documentType'] = 'Selecione o tipo de documento';
      }
      if (state.documentNumber.isEmpty) {
        errors['documentNumber'] = 'Informe o número do documento';
      }
      if (state.documentIssueDate.isEmpty) {
        errors['documentIssueDate'] = 'Informe a data de emissão';
      }
    }

    switch (state.paymentMode) {
      case AccountsPayablePaymentMode.single:
        if (state.totalAmount <= 0) {
          errors['totalAmount'] = 'Informe um valor maior que zero';
        }
        if (state.singleDueDate.isEmpty) {
          errors['singleDueDate'] = 'Informe a data de vencimento';
        }
        break;
      case AccountsPayablePaymentMode.manual:
        if (state.installments.isEmpty) {
          errors['installments'] = 'Adicione pelo menos uma parcela';
        }
        final hasInvalidInstallment = state.installments.any(
          (installment) =>
              installment.amount <= 0 || installment.dueDate.isEmpty,
        );
        if (hasInvalidInstallment) {
          errors['installments'] =
              'Preencha valor e vencimento de cada parcela';
        }
        break;
      case AccountsPayablePaymentMode.automatic:
        if (state.automaticInstallments <= 0) {
          errors['automaticInstallments'] =
              'Informe a quantidade de parcelas';
        }
        if (state.automaticInstallmentAmount <= 0) {
          errors['automaticInstallmentAmount'] =
              'Informe o valor por parcela';
        }
        if (state.automaticFirstDueDate.isEmpty) {
          errors['automaticFirstDueDate'] =
              'Informe a data da primeira parcela';
        }
        if (state.installments.isEmpty) {
          errors['installments'] =
              'Gere ou adicione ao menos uma parcela';
        }
        if (state.installments.any(
          (installment) =>
              installment.amount <= 0 || installment.dueDate.isEmpty,
        )) {
          errors['installments'] =
              'Preencha valor e vencimento de cada parcela';
        }
        if (state.installments.length != state.automaticInstallments) {
          errors['installments'] =
              'A quantidade de parcelas geradas deve corresponder ao total informado';
        }
        break;
    }

    return errors;
  }

  String? errorByKey(FormAccountsPayableState state, String key) {
    final errors = validateState(state);
    return errors[key];
  }
}
