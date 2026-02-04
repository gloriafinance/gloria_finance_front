import 'package:dio/dio.dart';

import '../../../../models/installment_model.dart';
import '../../../models/index.dart';

class FormAccountsReceivableState {
  bool makeRequest;
  DebtorType debtorType;
  AccountsReceivableType type;
  String debtorDNI;
  String debtorName;
  String description;
  String debtorPhone;
  String debtorEmail;
  String debtorAddress;
  String financialConceptId;
  AccountsReceivablePaymentMode paymentMode;
  double totalAmount;
  String singleDueDate;
  int automaticInstallments;
  double automaticInstallmentAmount;
  String automaticFirstDueDate;
  List<InstallmentModel> installments;
  String symbolFormatMoney = '';
  bool isMovementBank = false;
  String availabilityAccountId;
  MultipartFile? file;

  FormAccountsReceivableState({
    required this.makeRequest,
    required this.debtorType,
    required this.type,
    required this.debtorDNI,
    required this.debtorName,
    required this.description,
    required this.installments,
    required this.debtorPhone,
    required this.debtorEmail,
    required this.debtorAddress,
    required this.financialConceptId,
    required this.paymentMode,
    required this.totalAmount,
    required this.singleDueDate,
    required this.automaticInstallments,
    required this.automaticInstallmentAmount,
    required this.automaticFirstDueDate,
    required this.symbolFormatMoney,
    required this.isMovementBank,
    required this.availabilityAccountId,
    this.file,
  });

  factory FormAccountsReceivableState.init() {
    return FormAccountsReceivableState(
      makeRequest: false,
      debtorType: DebtorType.MEMBER,
      type: AccountsReceivableType.CONTRIBUTION,
      debtorDNI: '',
      debtorName: '',
      description: '',
      installments: [],
      debtorPhone: '',
      debtorEmail: '',
      debtorAddress: '',
      financialConceptId: '',
      paymentMode: AccountsReceivablePaymentMode.single,
      totalAmount: 0,
      singleDueDate: '',
      automaticInstallments: 0,
      automaticInstallmentAmount: 0,
      automaticFirstDueDate: '',
      symbolFormatMoney: '',
      isMovementBank: false,
      availabilityAccountId: '',
    );
  }

  FormAccountsReceivableState copyWith({
    bool? makeRequest,
    DebtorType? debtorType,
    AccountsReceivableType? type,
    String? debtorDNI,
    String? debtorName,
    String? description,
    List<InstallmentModel>? installments,
    String? debtorPhone,
    String? debtorEmail,
    String? debtorAddress,
    String? financialConceptId,
    AccountsReceivablePaymentMode? paymentMode,
    double? totalAmount,
    String? singleDueDate,
    int? automaticInstallments,
    double? automaticInstallmentAmount,
    String? automaticFirstDueDate,
    String? symbolFormatMoney,
    bool? isMovementBank,
    String? availabilityAccountId,
    MultipartFile? file,
  }) {
    return FormAccountsReceivableState(
      makeRequest: makeRequest ?? this.makeRequest,
      debtorType: debtorType ?? this.debtorType,
      type: type ?? this.type,
      debtorDNI: debtorDNI ?? this.debtorDNI,
      debtorName: debtorName ?? this.debtorName,
      description: description ?? this.description,
      installments: installments ?? this.installments,
      debtorPhone: debtorPhone ?? this.debtorPhone,
      debtorEmail: debtorEmail ?? this.debtorEmail,
      debtorAddress: debtorAddress ?? this.debtorAddress,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      paymentMode: paymentMode ?? this.paymentMode,
      totalAmount: totalAmount ?? this.totalAmount,
      singleDueDate: singleDueDate ?? this.singleDueDate,
      automaticInstallments:
          automaticInstallments ?? this.automaticInstallments,
      automaticInstallmentAmount:
          automaticInstallmentAmount ?? this.automaticInstallmentAmount,
      automaticFirstDueDate:
          automaticFirstDueDate ?? this.automaticFirstDueDate,
      symbolFormatMoney: symbolFormatMoney ?? this.symbolFormatMoney,
      isMovementBank: isMovementBank ?? this.isMovementBank,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      file: file ?? this.file,
    );
  }

  toJson() {
    final effectiveInstallments = _resolveInstallments();

    return {
      'debtor': {
        'debtorType': debtorType.apiValue,
        'debtorDNI': debtorDNI,
        'name': debtorName,
        'email': debtorEmail,
        'phone': debtorPhone,
      },
      'description': description,
      'financialConceptId': financialConceptId,
      'installments': effectiveInstallments.map((e) => e.toJson()).toList(),
      'type': type.apiValue,
      "availabilityAccountId": availabilityAccountId,
      "file": file,
    };
  }

  List<InstallmentModel> _resolveInstallments() {
    if (paymentMode == AccountsReceivablePaymentMode.single) {
      if (installments.isNotEmpty) {
        return installments;
      }

      if (totalAmount > 0 && singleDueDate.isNotEmpty) {
        return [InstallmentModel(amount: totalAmount, dueDate: singleDueDate)];
      }

      return const [];
    }

    return installments;
  }
}
