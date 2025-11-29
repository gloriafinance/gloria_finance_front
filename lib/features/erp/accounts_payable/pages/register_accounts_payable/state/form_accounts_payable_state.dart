import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp//accounts_payable/models/accounts_payable_tax.dart';
import 'package:church_finance_bk/features/erp//accounts_payable/models/accounts_payable_types.dart';

import '../../../../models/installment_model.dart';

class FormAccountsPayableState {
  bool makeRequest;
  String supplierId;
  String supplierName; // Para mostrar en la UI
  String description;
  List<InstallmentModel> installments;
  AccountsPayablePaymentMode paymentMode;
  AccountsPayableDocumentType? documentType;
  String documentNumber;
  String documentIssueDate;
  double totalAmount;
  String singleDueDate;
  int automaticInstallments;
  String automaticFirstDueDate;
  double automaticInstallmentAmount;
  AccountsPayableTaxStatus taxStatus;
  bool taxExempt;
  String taxExemptionReason;
  String taxObservation;
  String taxCstCode;
  String taxCfop;
  List<AccountsPayableTaxLine> taxes;

  FormAccountsPayableState({
    required this.makeRequest,
    required this.supplierId,
    required this.supplierName,
    required this.description,
    required this.installments,
    required this.paymentMode,
    required this.documentType,
    required this.documentNumber,
    required this.documentIssueDate,
    required this.totalAmount,
    required this.singleDueDate,
    required this.automaticInstallments,
    required this.automaticFirstDueDate,
    required this.automaticInstallmentAmount,
    required this.taxStatus,
    required this.taxExempt,
    required this.taxExemptionReason,
    required this.taxObservation,
    required this.taxCstCode,
    required this.taxCfop,
    required this.taxes,
  });

  factory FormAccountsPayableState.init() {
    return FormAccountsPayableState(
      makeRequest: false,
      supplierId: '',
      supplierName: '',
      description: '',
      installments: [],
      paymentMode: AccountsPayablePaymentMode.single,
      documentType: null,
      documentNumber: '',
      documentIssueDate: '',
      totalAmount: 0,
      singleDueDate: '',
      automaticInstallments: 0,
      automaticFirstDueDate: '',
      automaticInstallmentAmount: 0,
      taxStatus: AccountsPayableTaxStatus.notApplicable,
      taxExempt: true,
      taxExemptionReason: '',
      taxObservation: '',
      taxCstCode: '',
      taxCfop: '',
      taxes: const [],
    );
  }

  FormAccountsPayableState copyWith({
    bool? makeRequest,
    String? supplierId,
    String? supplierName,
    String? description,
    List<InstallmentModel>? installments,
    AccountsPayablePaymentMode? paymentMode,
    AccountsPayableDocumentType? documentType,
    bool resetDocumentType = false,
    String? documentNumber,
    String? documentIssueDate,
    double? totalAmount,
    String? singleDueDate,
    int? automaticInstallments,
    String? automaticFirstDueDate,
    double? automaticInstallmentAmount,
    AccountsPayableTaxStatus? taxStatus,
    bool? taxExempt,
    String? taxExemptionReason,
    String? taxObservation,
    String? taxCstCode,
    String? taxCfop,
    List<AccountsPayableTaxLine>? taxes,
  }) {
    return FormAccountsPayableState(
      makeRequest: makeRequest ?? this.makeRequest,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      description: description ?? this.description,
      installments: installments ?? this.installments,
      paymentMode: paymentMode ?? this.paymentMode,
      documentType:
          resetDocumentType ? null : (documentType ?? this.documentType),
      documentNumber: documentNumber ?? this.documentNumber,
      documentIssueDate: documentIssueDate ?? this.documentIssueDate,
      totalAmount: totalAmount ?? this.totalAmount,
      singleDueDate: singleDueDate ?? this.singleDueDate,
      automaticInstallments:
          automaticInstallments ?? this.automaticInstallments,
      automaticFirstDueDate:
          automaticFirstDueDate ?? this.automaticFirstDueDate,
      automaticInstallmentAmount:
          automaticInstallmentAmount ?? this.automaticInstallmentAmount,
      taxStatus: taxStatus ?? this.taxStatus,
      taxExempt: taxExempt ?? this.taxExempt,
      taxExemptionReason: taxExemptionReason ?? this.taxExemptionReason,
      taxObservation: taxObservation ?? this.taxObservation,
      taxCstCode: taxCstCode ?? this.taxCstCode,
      taxCfop: taxCfop ?? this.taxCfop,
      taxes: taxes ?? this.taxes,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'supplierId': supplierId,
      'description': description,
    };

    if (documentType != null) {
      final issueDate =
          documentIssueDate.isNotEmpty
              ? convertDateFormat(documentIssueDate)
              : null;

      payload['taxDocument'] = {
        'type': documentType!.apiValue,
        if (documentNumber.isNotEmpty) 'number': documentNumber,
        if (issueDate != null && issueDate.isNotEmpty) 'date': issueDate,
      };
    }

    final installmentsPayload =
        installments.asMap().entries.map((entry) {
          final installment = entry.value;
          final dueDate =
              installment.dueDate.isNotEmpty
                  ? convertDateFormat(installment.dueDate)
                  : '';
          return {'amount': installment.amount, 'dueDate': dueDate};
        }).toList();

    switch (paymentMode) {
      case AccountsPayablePaymentMode.single:
        payload['amountTotal'] = totalAmount;
        if (singleDueDate.isNotEmpty) {
          payload['installments'] = [
            {
              'amount': totalAmount,
              'dueDate': convertDateFormat(singleDueDate),
            },
          ];
        }
        break;
      case AccountsPayablePaymentMode.manual:
        payload['installments'] = installmentsPayload;
        break;
      case AccountsPayablePaymentMode.automatic:
        payload['installments'] = installmentsPayload;
        break;
    }

    if (paymentMode != AccountsPayablePaymentMode.single &&
        installmentsPayload.isNotEmpty) {
      payload['amountTotal'] = _sumInstallments;
    }

    payload['taxMetadata'] = {
      'status': taxStatus.apiValue,
      'taxExempt': taxExempt,
      if (taxExemptionReason.isNotEmpty) 'exemptionReason': taxExemptionReason,
      if (taxObservation.isNotEmpty) 'observation': taxObservation,
      if (taxCstCode.isNotEmpty) 'cstCode': taxCstCode,
      if (taxCfop.isNotEmpty) 'cfop': taxCfop,
    };

    if (!taxExempt && taxes.isNotEmpty) {
      payload['taxes'] = taxes.map((tax) => tax.toJson()).toList();
    }

    return payload;
  }

  double get _sumInstallments {
    return installments.fold<double>(0, (acc, item) => acc + item.amount);
  }

  bool get isValid {
    if (supplierId.isEmpty || description.isEmpty) {
      return false;
    }

    if (documentType == null ||
        documentNumber.isEmpty ||
        documentIssueDate.isEmpty) {
      return false;
    }

    final hasValidInstallments =
        installments.isNotEmpty &&
        installments.every(
          (installment) =>
              installment.amount > 0 && installment.dueDate.isNotEmpty,
        );

    bool paymentValid;
    switch (paymentMode) {
      case AccountsPayablePaymentMode.single:
        paymentValid =
            totalAmount > 0 && singleDueDate.isNotEmpty && hasValidInstallments;
        break;
      case AccountsPayablePaymentMode.manual:
        paymentValid = hasValidInstallments;
        break;
      case AccountsPayablePaymentMode.automatic:
        paymentValid =
            automaticInstallments > 0 &&
            automaticInstallmentAmount > 0 &&
            automaticFirstDueDate.isNotEmpty &&
            hasValidInstallments &&
            installments.length == automaticInstallments;
        break;
    }

    if (!paymentValid) {
      return false;
    }

    final requiresTaxes =
        !taxExempt &&
        (taxStatus == AccountsPayableTaxStatus.taxed ||
            taxStatus == AccountsPayableTaxStatus.substitution);

    if (requiresTaxes) {
      final hasValidTaxes =
          taxes.isNotEmpty &&
          taxes.every(
            (tax) =>
                tax.taxType.isNotEmpty && tax.amount > 0 && tax.percentage > 0,
          );
      if (!hasValidTaxes) {
        return false;
      }
    } else if (taxExempt && taxes.isNotEmpty) {
      return false;
    }

    return true;
  }
}
