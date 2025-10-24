import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_payable_state.dart';

class FormAccountsPayableValidator
    extends LucidValidator<FormAccountsPayableState> {
  FormAccountsPayableValidator() {
    ruleFor((m) => m.supplierId, key: 'supplierId')
        .notEmpty(message: 'O fornecedor é obrigatório');

    ruleFor((m) => m.description, key: 'description')
        .notEmpty(message: 'A descrição é obrigatória');

    ruleFor((m) => m, key: 'documentType').must(
      (state) => !state.includeDocument || state.documentType != null,
      'Selecione o tipo de documento',
      'documentType_required',
    );

    ruleFor((m) => m, key: 'documentNumber').must(
      (state) => !state.includeDocument || state.documentNumber.isNotEmpty,
      'Informe o número do documento',
      'documentNumber_required',
    );

    ruleFor((m) => m, key: 'documentIssueDate').must(
      (state) => !state.includeDocument || state.documentIssueDate.isNotEmpty,
      'Informe a data de emissão',
      'documentIssueDate_required',
    );

    ruleFor((m) => m, key: 'totalAmount').must(
      (state) {
        if (state.paymentMode == AccountsPayablePaymentMode.single ||
            state.paymentMode == AccountsPayablePaymentMode.automatic) {
          return state.totalAmount > 0;
        }
        return true;
      },
      'Informe um valor maior que zero',
      'totalAmount_required',
    );

    ruleFor((m) => m, key: 'singleDueDate').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.single ||
          state.singleDueDate.isNotEmpty,
      'Informe a data de vencimento',
      'singleDueDate_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) =>
          state.paymentMode == AccountsPayablePaymentMode.single ||
          state.installments.isNotEmpty,
      'Gere ou adicione ao menos uma parcela',
      'installments_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) =>
          state.paymentMode == AccountsPayablePaymentMode.single ||
          state.installments.every(
            (installment) =>
                installment.amount > 0 && installment.dueDate.isNotEmpty,
          ),
      'Preencha valor e vencimento de cada parcela',
      'installments_contents',
    );

    ruleFor((m) => m, key: 'automaticInstallments').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.automatic ||
          state.automaticInstallments > 0,
      'Informe a quantidade de parcelas',
      'automaticInstallments_required',
    );

    ruleFor((m) => m, key: 'automaticInstallmentAmount').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.automatic ||
          state.automaticInstallmentAmount > 0,
      'Informe o valor por parcela',
      'automaticInstallmentAmount_required',
    );

    ruleFor((m) => m, key: 'automaticFirstDueDate').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.automatic ||
          state.automaticFirstDueDate.isNotEmpty,
      'Informe a data da primeira parcela',
      'automaticFirstDueDate_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) {
        if (state.paymentMode != AccountsPayablePaymentMode.automatic) {
          return true;
        }
        if (state.installments.isEmpty) {
          return false;
        }
        return state.installments.length == state.automaticInstallments;
      },
      'A quantidade de parcelas geradas deve corresponder ao total informado',
      'installments_count_mismatch',
    );
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
