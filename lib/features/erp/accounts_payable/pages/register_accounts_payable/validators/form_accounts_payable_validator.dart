import 'package:church_finance_bk/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../state/form_accounts_payable_state.dart';

class FormAccountsPayableValidator
    extends LucidValidator<FormAccountsPayableState> {
  final String supplierRequired;
  final String descriptionRequired;
  final String documentTypeRequired;
  final String documentNumberRequired;
  final String documentDateRequired;
  final String totalAmountRequired;
  final String singleDueDateRequired;
  final String installmentsRequired;
  final String installmentsContents;
  final String automaticInstallmentsRequired;
  final String automaticAmountRequired;
  final String automaticFirstDueDateRequired;
  final String installmentsCountMismatch;
  final String taxesRequired;
  final String taxesInvalid;
  final String taxExemptionReasonRequired;
  final String taxExemptMustNotHaveTaxes;
  final String taxStatusMismatch;

  FormAccountsPayableValidator({
    required this.supplierRequired,
    required this.descriptionRequired,
    required this.documentTypeRequired,
    required this.documentNumberRequired,
    required this.documentDateRequired,
    required this.totalAmountRequired,
    required this.singleDueDateRequired,
    required this.installmentsRequired,
    required this.installmentsContents,
    required this.automaticInstallmentsRequired,
    required this.automaticAmountRequired,
    required this.automaticFirstDueDateRequired,
    required this.installmentsCountMismatch,
    required this.taxesRequired,
    required this.taxesInvalid,
    required this.taxExemptionReasonRequired,
    required this.taxExemptMustNotHaveTaxes,
    required this.taxStatusMismatch,
  }) {
    ruleFor(
      (m) => m.supplierId,
      key: 'supplierId',
    ).notEmpty(message: supplierRequired);

    ruleFor(
      (m) => m.description,
      key: 'description',
    ).notEmpty(message: descriptionRequired);

    ruleFor((m) => m, key: 'documentType').must(
      (state) => state.documentType != null,
      documentTypeRequired,
      'documentType_required',
    );

    ruleFor((m) => m, key: 'documentNumber').must(
      (state) => state.documentNumber.isNotEmpty,
      documentNumberRequired,
      'documentNumber_required',
    );

    ruleFor((m) => m, key: 'documentIssueDate').must(
      (state) => state.documentIssueDate.isNotEmpty,
      documentDateRequired,
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
      totalAmountRequired,
      'totalAmount_required',
    );

    ruleFor((m) => m, key: 'singleDueDate').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.single ||
          state.singleDueDate.isNotEmpty,
      singleDueDateRequired,
      'singleDueDate_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) =>
          state.paymentMode == AccountsPayablePaymentMode.single ||
          state.installments.isNotEmpty,
      installmentsRequired,
      'installments_required',
    );

    ruleFor((m) => m, key: 'installments').must(
      (state) =>
          state.paymentMode == AccountsPayablePaymentMode.single ||
          state.installments.every(
            (installment) =>
                installment.amount > 0 && installment.dueDate.isNotEmpty,
          ),
      installmentsContents,
      'installments_contents',
    );

    ruleFor((m) => m, key: 'automaticInstallments').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.automatic ||
          state.automaticInstallments > 0,
      automaticInstallmentsRequired,
      'automaticInstallments_required',
    );

    ruleFor((m) => m, key: 'automaticInstallmentAmount').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.automatic ||
          state.automaticInstallmentAmount > 0,
      automaticAmountRequired,
      'automaticInstallmentAmount_required',
    );

    ruleFor((m) => m, key: 'automaticFirstDueDate').must(
      (state) =>
          state.paymentMode != AccountsPayablePaymentMode.automatic ||
          state.automaticFirstDueDate.isNotEmpty,
      automaticFirstDueDateRequired,
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
      installmentsCountMismatch,
      'installments_count_mismatch',
    );

    ruleFor((m) => m, key: 'taxes').must(
      (state) {
        if (state.taxExempt) {
          return state.taxes.isEmpty;
        }

        if (state.taxStatus == AccountsPayableTaxStatus.taxed ||
            state.taxStatus == AccountsPayableTaxStatus.substitution) {
          return state.taxes.isNotEmpty;
        }

        return true;
      },
      taxesRequired,
      'taxes_required',
    );

    ruleFor((m) => m, key: 'taxesContents').must(
      (state) {
        if (state.taxExempt) {
          return state.taxes.isEmpty;
        }

        if (state.taxes.isEmpty) {
          return false;
        }

        return state.taxes.every(
          (tax) =>
              tax.taxType.isNotEmpty && tax.percentage > 0 && tax.amount > 0,
        );
      },
      taxesInvalid,
      'taxes_invalid',
    );

    ruleFor((m) => m, key: 'taxExemptionReason').must(
      (state) {
        if (state.taxStatus == AccountsPayableTaxStatus.exempt) {
          return state.taxExemptionReason.isNotEmpty;
        }
        return true;
      },
      taxExemptionReasonRequired,
      'taxExemptionReason_required',
    );
  }

  Map<String, String> validateState(FormAccountsPayableState state) {
    final Map<String, String> errors = {};

    if (state.supplierId.isEmpty) {
      errors['supplierId'] = supplierRequired;
    }

    if (state.description.isEmpty) {
      errors['description'] = descriptionRequired;
    }

    if (state.documentType == null) {
      errors['documentType'] = documentTypeRequired;
    }
    if (state.documentNumber.isEmpty) {
      errors['documentNumber'] = documentNumberRequired;
    }
    if (state.documentIssueDate.isEmpty) {
      errors['documentIssueDate'] = documentDateRequired;
    }

    switch (state.paymentMode) {
      case AccountsPayablePaymentMode.single:
        if (state.totalAmount <= 0) {
          errors['totalAmount'] = totalAmountRequired;
        }
        if (state.singleDueDate.isEmpty) {
          errors['singleDueDate'] = singleDueDateRequired;
        }
        break;
      case AccountsPayablePaymentMode.manual:
        if (state.installments.isEmpty) {
          errors['installments'] = installmentsRequired;
        }
        final hasInvalidInstallment = state.installments.any(
          (installment) =>
              installment.amount <= 0 || installment.dueDate.isEmpty,
        );
        if (hasInvalidInstallment) {
          errors['installments'] = installmentsContents;
        }
        break;
      case AccountsPayablePaymentMode.automatic:
        if (state.automaticInstallments <= 0) {
          errors['automaticInstallments'] = automaticInstallmentsRequired;
        }
        if (state.automaticInstallmentAmount <= 0) {
          errors['automaticInstallmentAmount'] = automaticAmountRequired;
        }
        if (state.automaticFirstDueDate.isEmpty) {
          errors['automaticFirstDueDate'] = automaticFirstDueDateRequired;
        }
        if (state.installments.isEmpty) {
          errors['installments'] = installmentsRequired;
        }
        if (state.installments.any(
          (installment) =>
              installment.amount <= 0 || installment.dueDate.isEmpty,
        )) {
          errors['installments'] = installmentsContents;
        }
        if (state.installments.length != state.automaticInstallments) {
          errors['installments'] = installmentsCountMismatch;
        }
        break;
    }

    if (state.taxStatus == AccountsPayableTaxStatus.exempt) {
      if (state.taxExemptionReason.isEmpty) {
        errors['taxExemptionReason'] = taxExemptionReasonRequired;
      }
      if (state.taxes.isNotEmpty) {
        errors['taxes'] = taxExemptMustNotHaveTaxes;
      }
    }

    if (!state.taxExempt &&
        (state.taxStatus == AccountsPayableTaxStatus.taxed ||
            state.taxStatus == AccountsPayableTaxStatus.substitution)) {
      if (state.taxes.isEmpty) {
        errors['taxes'] = taxesRequired;
      } else if (state.taxes.any(
        (tax) => tax.taxType.isEmpty || tax.percentage <= 0 || tax.amount <= 0,
      )) {
        errors['taxes'] = taxesInvalid;
      }
    }

    if (state.taxExempt &&
        state.taxStatus != AccountsPayableTaxStatus.exempt &&
        state.taxStatus != AccountsPayableTaxStatus.notApplicable) {
      errors['taxStatus'] = taxStatusMismatch;
    }

    return errors;
  }

  String? errorByKey(FormAccountsPayableState state, String key) {
    final errors = validateState(state);
    return errors[key];
  }
}
