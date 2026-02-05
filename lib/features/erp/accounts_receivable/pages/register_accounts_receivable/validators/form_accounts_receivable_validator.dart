import 'package:gloria_finance/features/erp/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/models/accounts_receivable_payment_mode.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_receivable_state.dart';

class FormAccountsReceivableValidator
    extends LucidValidator<FormAccountsReceivableState> {
  final String descriptionRequired;
  final String financialConceptRequired;
  final String debtorNameRequired;
  final String debtorDniRequired;
  final String debtorPhoneRequired;
  final String debtorEmailRequired;
  final String totalAmountRequired;
  final String singleDueDateRequired;
  final String installmentsRequired;
  final String installmentsInvalid;
  final String automaticInstallmentsRequired;
  final String automaticAmountRequired;
  final String automaticFirstDueDateRequired;
  final String installmentsCountMismatch;

  FormAccountsReceivableValidator({
    required this.descriptionRequired,
    required this.financialConceptRequired,
    required this.debtorNameRequired,
    required this.debtorDniRequired,
    required this.debtorPhoneRequired,
    required this.debtorEmailRequired,
    required this.totalAmountRequired,
    required this.singleDueDateRequired,
    required this.installmentsRequired,
    required this.installmentsInvalid,
    required this.automaticInstallmentsRequired,
    required this.automaticAmountRequired,
    required this.automaticFirstDueDateRequired,
    required this.installmentsCountMismatch,
  }) {
    ruleFor(
      (m) => m.description,
      key: 'description',
    ).notEmpty(message: descriptionRequired);

    // ruleFor((m) => m, key: 'financialConceptId').must(
    //   (state) => state.type != AccountsReceivableType.LOAN,
    //   financialConceptRequired,
    //   'financialConcept_required',
    // );

    ruleFor(
      (m) => m.debtorName,
      key: 'debtorName',
    ).notEmpty(message: debtorNameRequired);

    ruleFor(
      (m) => m.debtorDNI,
      key: 'debtorDNI',
    ).notEmpty(message: debtorDniRequired);

    ruleFor(
      (m) => m.debtorPhone,
      key: 'debtorPhone',
    ).notEmpty(message: debtorPhoneRequired);

    ruleFor(
      (m) => m.debtorEmail,
      key: 'debtorEmail',
    ).notEmpty(message: debtorEmailRequired);

    ruleFor((m) => m, key: 'totalAmount').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.single ||
          state.type == AccountsReceivableType.CONTRIBUTION ||
          state.totalAmount > 0,
      totalAmountRequired,
      'totalAmount_required',
    );

    ruleFor((m) => m, key: 'singleDueDate').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.single ||
          state.singleDueDate.isNotEmpty,
      singleDueDateRequired,
      'singleDueDate_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) =>
          state.paymentMode == AccountsReceivablePaymentMode.single ||
          state.installments.isNotEmpty,
      installmentsRequired,
      'installments_required',
    );

    ruleFor((m) => m, key: 'installments_contents').must(
      (state) =>
          state.paymentMode == AccountsReceivablePaymentMode.single ||
          state.installments.every(
            (installment) =>
                installment.dueDate.isNotEmpty &&
                (state.type == AccountsReceivableType.CONTRIBUTION ||
                    installment.amount > 0),
          ),
      installmentsInvalid,
      'installments_invalid',
    );

    ruleFor((m) => m, key: 'automaticInstallments').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.automatic ||
          state.automaticInstallments > 0,
      automaticInstallmentsRequired,
      'automaticInstallments_required',
    );

    ruleFor((m) => m, key: 'automaticInstallmentAmount').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.automatic ||
          state.type == AccountsReceivableType.CONTRIBUTION ||
          state.automaticInstallmentAmount > 0,
      automaticAmountRequired,
      'automaticInstallmentAmount_required',
    );

    ruleFor((m) => m, key: 'automaticFirstDueDate').must(
      (state) =>
          state.paymentMode != AccountsReceivablePaymentMode.automatic ||
          state.automaticFirstDueDate.isNotEmpty,
      automaticFirstDueDateRequired,
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
      installmentsCountMismatch,
      'installments_count_mismatch',
    );
  }

  Map<String, String> validateState(FormAccountsReceivableState state) {
    final Map<String, String> errors = {};

    if (state.description.isEmpty) {
      errors['description'] = descriptionRequired;
    }

    if (state.financialConceptId.isEmpty) {
      errors['financialConceptId'] = financialConceptRequired;
    }

    if (state.debtorName.isEmpty) {
      errors['debtorName'] = debtorNameRequired;
    }

    if (state.debtorDNI.isEmpty) {
      errors['debtorDNI'] = debtorDniRequired;
    }

    if (state.debtorPhone.isEmpty) {
      errors['debtorPhone'] = debtorPhoneRequired;
    }

    if (state.debtorEmail.isEmpty) {
      errors['debtorEmail'] = debtorEmailRequired;
    }

    final isContribution = state.type == AccountsReceivableType.CONTRIBUTION;

    switch (state.paymentMode) {
      case AccountsReceivablePaymentMode.single:
        if (!isContribution && state.totalAmount <= 0) {
          errors['totalAmount'] = totalAmountRequired;
        }
        if (state.singleDueDate.isEmpty) {
          errors['singleDueDate'] = singleDueDateRequired;
        }
        break;
      case AccountsReceivablePaymentMode.automatic:
        if (state.automaticInstallments <= 0) {
          errors['automaticInstallments'] = automaticInstallmentsRequired;
        }
        if (!isContribution && state.automaticInstallmentAmount <= 0) {
          errors['automaticInstallmentAmount'] = automaticAmountRequired;
        }
        if (state.automaticFirstDueDate.isEmpty) {
          errors['automaticFirstDueDate'] = automaticFirstDueDateRequired;
        }
        if (state.installments.isEmpty) {
          errors['installments'] = installmentsRequired;
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
