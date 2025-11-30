import 'package:church_finance_bk/features/erp/accounts_receivable/models/accounts_receivable_payment_mode.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_receivable_state.dart';

class FormAccountsReceivableValidator
    extends LucidValidator<FormAccountsReceivableState> {
  FormAccountsReceivableValidator() {
    ruleFor(
      (m) => m.description,
      key: 'description',
    ).notEmpty(message: 'Descrição é obrigatória');

    ruleFor(
      (m) => m.financialConceptId,
      key: 'financialConceptId',
    ).notEmpty(message: 'Selecione um conceito financeiro');

    ruleFor(
      (m) => m.debtorName,
      key: 'debtorName',
    ).notEmpty(message: 'Nome do devedor é obrigatório');

    ruleFor(
      (m) => m.debtorDNI,
      key: 'debtorDNI',
    ).notEmpty(message: 'Identificador do devedor é obrigatório');

    ruleFor(
      (m) => m.debtorPhone,
      key: 'debtorPhone',
    ).notEmpty(message: 'Telefone do devedor é obrigatório');

    ruleFor(
      (m) => m.debtorEmail,
      key: 'debtorEmail',
    ).notEmpty(message: 'Email do devedor é obrigatório');

    ruleFor((m) => m, key: 'totalAmount').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.single ||
          state.totalAmount > 0,
      'Informe o valor total',
      'totalAmount_required',
    );

    ruleFor((m) => m, key: 'singleDueDate').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.single ||
          state.singleDueDate.isNotEmpty,
      'Informe a data de vencimento',
      'singleDueDate_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) =>
          state.paymentMode == AccountsReceivablePaymentMode.single ||
          state.installments.isNotEmpty,
      'Gere as parcelas para continuar',
      'installments_required',
    );

    ruleFor((m) => m, key: 'installments_contents').must(
      (state) =>
          state.paymentMode == AccountsReceivablePaymentMode.single ||
          state.installments.every(
            (installment) =>
                installment.amount > 0 && installment.dueDate.isNotEmpty,
          ),
      'Preencha valor e vencimento de cada parcela',
      'installments_invalid',
    );

    ruleFor((m) => m, key: 'automaticInstallments').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.automatic ||
          state.automaticInstallments > 0,
      'Informe a quantidade de parcelas',
      'automaticInstallments_required',
    );

    ruleFor((m) => m, key: 'automaticInstallmentAmount').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.automatic ||
          state.automaticInstallmentAmount > 0,
      'Informe o valor por parcela',
      'automaticInstallmentAmount_required',
    );

    ruleFor((m) => m, key: 'automaticFirstDueDate').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.automatic ||
          state.automaticFirstDueDate.isNotEmpty,
      'Informe a data da primeira parcela',
      'automaticFirstDueDate_required',
    );

    ruleFor((m) => m, key: 'installments_count').must(
      (state) {
        if (state.paymentMode != AccountsReceivablePaymentMode.automatic) {
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

  Map<String, String> validateState(FormAccountsReceivableState state) {
    final Map<String, String> errors = {};

    if (state.description.isEmpty) {
      errors['description'] = 'Descrição é obrigatória';
    }

    if (state.financialConceptId.isEmpty) {
      errors['financialConceptId'] = 'Selecione um conceito financeiro';
    }

    if (state.debtorName.isEmpty) {
      errors['debtorName'] = 'Nome do devedor é obrigatório';
    }

    if (state.debtorDNI.isEmpty) {
      errors['debtorDNI'] = 'Identificador do devedor é obrigatório';
    }

    if (state.debtorPhone.isEmpty) {
      errors['debtorPhone'] = 'Telefone do devedor é obrigatório';
    }

    if (state.debtorEmail.isEmpty) {
      errors['debtorEmail'] = 'Email do devedor é obrigatório';
    }

    switch (state.paymentMode) {
      case AccountsReceivablePaymentMode.single:
        if (state.totalAmount <= 0) {
          errors['totalAmount'] = 'Informe o valor total';
        }
        if (state.singleDueDate.isEmpty) {
          errors['singleDueDate'] = 'Informe a data de vencimento';
        }
        break;
      case AccountsReceivablePaymentMode.automatic:
        if (state.automaticInstallments <= 0) {
          errors['automaticInstallments'] = 'Informe a quantidade de parcelas';
        }
        if (state.automaticInstallmentAmount <= 0) {
          errors['automaticInstallmentAmount'] = 'Informe o valor por parcela';
        }
        if (state.automaticFirstDueDate.isEmpty) {
          errors['automaticFirstDueDate'] =
              'Informe a data da primeira parcela';
        }
        if (state.installments.isEmpty) {
          errors['installments'] = 'Gere as parcelas para continuar';
        }
        break;
    }

    return errors;
  }

  String? errorByKey(FormAccountsReceivableState state, String key) {
    final errors = validateState(state);
    return errors[key];
  }
}
