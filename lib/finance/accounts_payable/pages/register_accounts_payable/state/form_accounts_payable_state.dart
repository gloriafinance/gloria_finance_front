import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:church_finance_bk/helpers/index.dart';

import '../../../../models/installment_model.dart';

class FormAccountsPayableState {
  bool makeRequest;
  String supplierId;
  String supplierName; // Para mostrar en la UI
  String description;
  List<InstallmentModel> installments;
  AccountsPayablePaymentMode paymentMode;
  bool includeDocument;
  AccountsPayableDocumentType? documentType;
  String documentNumber;
  String documentIssueDate;
  double totalAmount;
  String singleDueDate;
  int automaticInstallments;
  String automaticFirstDueDate;
  double automaticInstallmentAmount;

  FormAccountsPayableState({
    required this.makeRequest,
    required this.supplierId,
    required this.supplierName,
    required this.description,
    required this.installments,
    required this.paymentMode,
    required this.includeDocument,
    required this.documentType,
    required this.documentNumber,
    required this.documentIssueDate,
    required this.totalAmount,
    required this.singleDueDate,
    required this.automaticInstallments,
    required this.automaticFirstDueDate,
    required this.automaticInstallmentAmount,
  });

  factory FormAccountsPayableState.init() {
    return FormAccountsPayableState(
      makeRequest: false,
      supplierId: '',
      supplierName: '',
      description: '',
      installments: [],
      paymentMode: AccountsPayablePaymentMode.single,
      includeDocument: false,
      documentType: null,
      documentNumber: '',
      documentIssueDate: '',
      totalAmount: 0,
      singleDueDate: '',
      automaticInstallments: 0,
      automaticFirstDueDate: '',
      automaticInstallmentAmount: 0,
    );
  }

  FormAccountsPayableState copyWith({
    bool? makeRequest,
    String? supplierId,
    String? supplierName,
    String? description,
    List<InstallmentModel>? installments,
    AccountsPayablePaymentMode? paymentMode,
    bool? includeDocument,
    AccountsPayableDocumentType? documentType,
    bool resetDocumentType = false,
    String? documentNumber,
    String? documentIssueDate,
    double? totalAmount,
    String? singleDueDate,
    int? automaticInstallments,
    String? automaticFirstDueDate,
    double? automaticInstallmentAmount,
  }) {
    return FormAccountsPayableState(
      makeRequest: makeRequest ?? this.makeRequest,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      description: description ?? this.description,
      installments: installments ?? this.installments,
      paymentMode: paymentMode ?? this.paymentMode,
      includeDocument: includeDocument ?? this.includeDocument,
      documentType: resetDocumentType
          ? null
          : (documentType ?? this.documentType),
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
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'supplierId': supplierId,
      'description': description,
    };

    if (includeDocument && documentType != null) {
      final issueDate = documentIssueDate.isNotEmpty
          ? convertDateFormat(documentIssueDate)
          : null;

      payload['document'] = {
        'type': documentType!.apiValue,
        'number': documentNumber,
        if (issueDate != null) 'issueDate': issueDate,
      };
    }

    final installmentsPayload = installments.asMap().entries.map((entry) {
      final installment = entry.value;
      final dueDate = installment.dueDate.isNotEmpty
          ? convertDateFormat(installment.dueDate)
          : '';
      return {
        'sequence': installment.sequence ?? entry.key + 1,
        'amount': installment.amount,
        'dueDate': dueDate,
      };
    }).toList();

    final payment = <String, dynamic>{
      'mode': paymentMode.apiValue,
    };

    switch (paymentMode) {
      case AccountsPayablePaymentMode.single:
        final dueDate =
            singleDueDate.isNotEmpty ? convertDateFormat(singleDueDate) : '';
        payment['single'] = {
          'amount': totalAmount,
          'dueDate': dueDate,
        };
        break;
      case AccountsPayablePaymentMode.manual:
        payment['manual'] = {
          'totalAmount': _sumInstallments,
          'installments': installmentsPayload,
        };
        break;
      case AccountsPayablePaymentMode.automatic:
        payment['automatic'] = {
          'installmentsCount': automaticInstallments,
          'amountPerInstallment': automaticInstallmentAmount,
          'firstDueDate': automaticFirstDueDate.isNotEmpty
              ? convertDateFormat(automaticFirstDueDate)
              : '',
          'totalAmount': _automaticTotalAmount,
          'installments': installmentsPayload,
        };
        break;
    }

    payload['payment'] = payment;

    return payload;
  }

  double get _sumInstallments {
    return installments.fold<double>(0, (acc, item) => acc + item.amount);
  }

  double get _automaticTotalAmount {
    if (installments.isNotEmpty) {
      return _sumInstallments;
    }
    return automaticInstallments * automaticInstallmentAmount;
  }

  bool get isValid {
    if (supplierId.isEmpty || description.isEmpty) {
      return false;
    }

    if (includeDocument) {
      if (documentType == null ||
          documentNumber.isEmpty ||
          documentIssueDate.isEmpty) {
        return false;
      }
    }

    final hasValidInstallments = installments.isNotEmpty &&
        installments.every((installment) =>
            installment.amount > 0 && installment.dueDate.isNotEmpty);

    switch (paymentMode) {
      case AccountsPayablePaymentMode.single:
        return totalAmount > 0 &&
            singleDueDate.isNotEmpty &&
            hasValidInstallments;
      case AccountsPayablePaymentMode.manual:
        return hasValidInstallments;
      case AccountsPayablePaymentMode.automatic:
        return automaticInstallments > 0 &&
            automaticInstallmentAmount > 0 &&
            automaticFirstDueDate.isNotEmpty &&
            hasValidInstallments &&
            installments.length == automaticInstallments;
    }
  }
}
