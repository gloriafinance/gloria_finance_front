import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_tax.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';

import '../../../../models/installment_model.dart';
import '../../../accounts_payable_service.dart';
import '../state/form_accounts_payable_state.dart';

class FormAccountsPayableStore extends ChangeNotifier {
  final AccountsPayableService service = AccountsPayableService();
  FormAccountsPayableState state = FormAccountsPayableState.init();

  void setSupplier(String supplierId, String supplierName) {
    state = state.copyWith(
      supplierId: supplierId,
      supplierName: supplierName,
    );
    notifyListeners();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
    notifyListeners();
  }

  void setPaymentMode(AccountsPayablePaymentMode mode) {
    if (state.paymentMode == mode) return;

    switch (mode) {
      case AccountsPayablePaymentMode.single:
        state = state.copyWith(
          paymentMode: mode,
          installments: [],
          automaticInstallments: 0,
          automaticFirstDueDate: '',
          automaticInstallmentAmount: 0,
          totalAmount: 0,
        );
        _updateInstallmentPreview();
        break;
      case AccountsPayablePaymentMode.manual:
        state = state.copyWith(
          paymentMode: mode,
          installments: [],
          totalAmount: 0,
          singleDueDate: '',
          automaticInstallments: 0,
          automaticFirstDueDate: '',
          automaticInstallmentAmount: 0,
        );
        notifyListeners();
        break;
      case AccountsPayablePaymentMode.automatic:
        state = state.copyWith(
          paymentMode: mode,
          installments: [],
          totalAmount: 0,
          singleDueDate: '',
          automaticInstallments: 0,
          automaticFirstDueDate: '',
          automaticInstallmentAmount: 0,
        );
        notifyListeners();
        break;
    }
  }

  void setIncludeDocument(bool value) {
    state = state.copyWith(includeDocument: value);

    if (!value) {
      state = state.copyWith(
        resetDocumentType: true,
        documentNumber: '',
        documentIssueDate: '',
      );
    }

    notifyListeners();
  }

  void setDocumentType(AccountsPayableDocumentType? type) {
    if (type == null) {
      state = state.copyWith(resetDocumentType: true);
    } else {
      state = state.copyWith(documentType: type);
    }
    notifyListeners();
  }

  void setDocumentNumber(String number) {
    state = state.copyWith(documentNumber: number);
    notifyListeners();
  }

  void setDocumentIssueDate(String date) {
    state = state.copyWith(documentIssueDate: date);
    notifyListeners();
  }

  void setTaxStatus(AccountsPayableTaxStatus status) {
    var taxes = state.taxes;
    var taxExempt = state.taxExempt;

    if (status == AccountsPayableTaxStatus.exempt ||
        status == AccountsPayableTaxStatus.notApplicable) {
      taxes = const <AccountsPayableTaxLine>[];
      taxExempt = true;
    } else {
      taxExempt = false;
    }

    state = state.copyWith(
      taxStatus: status,
      taxExempt: taxExempt,
      taxes: taxes,
      taxExemptionReason:
          status == AccountsPayableTaxStatus.exempt ? state.taxExemptionReason : '',
      taxCstCode: status == AccountsPayableTaxStatus.taxed ||
              status == AccountsPayableTaxStatus.substitution
          ? state.taxCstCode
          : '',
      taxCfop: status == AccountsPayableTaxStatus.taxed ||
              status == AccountsPayableTaxStatus.substitution
          ? state.taxCfop
          : '',
    );
    notifyListeners();
  }

  void setTaxExempt(bool value) {
    if (value == state.taxExempt) return;

    if (value) {
      final nextStatus = state.taxStatus == AccountsPayableTaxStatus.exempt ||
              state.taxStatus == AccountsPayableTaxStatus.notApplicable
          ? state.taxStatus
          : AccountsPayableTaxStatus.exempt;

      state = state.copyWith(
        taxExempt: true,
        taxStatus: nextStatus,
        taxes: const <AccountsPayableTaxLine>[],
        taxCstCode: '',
        taxCfop: '',
      );
    } else {
      final nextStatus = state.taxStatus == AccountsPayableTaxStatus.taxed ||
              state.taxStatus == AccountsPayableTaxStatus.substitution
          ? state.taxStatus
          : AccountsPayableTaxStatus.taxed;

      state = state.copyWith(
        taxExempt: false,
        taxStatus: nextStatus,
        taxExemptionReason: '',
      );
    }

    notifyListeners();
  }

  void setTaxExemptionReason(String value) {
    state = state.copyWith(taxExemptionReason: value);
    notifyListeners();
  }

  void setTaxObservation(String value) {
    state = state.copyWith(taxObservation: value);
    notifyListeners();
  }

  void setTaxCstCode(String value) {
    state = state.copyWith(taxCstCode: value);
    notifyListeners();
  }

  void setTaxCfop(String value) {
    state = state.copyWith(taxCfop: value);
    notifyListeners();
  }

  void addTaxLine(AccountsPayableTaxLine line) {
    final updated = [...state.taxes, line];
    state = state.copyWith(taxes: updated);
    notifyListeners();
  }

  void updateTaxLine(int index, AccountsPayableTaxLine line) {
    if (index < 0 || index >= state.taxes.length) return;
    final updated = [...state.taxes];
    updated[index] = line;
    state = state.copyWith(taxes: updated);
    notifyListeners();
  }

  void removeTaxLine(int index) {
    if (index < 0 || index >= state.taxes.length) return;
    final updated = [...state.taxes];
    updated.removeAt(index);
    state = state.copyWith(taxes: updated);
    notifyListeners();
  }

  void setTotalAmount(double amount) {
    state = state.copyWith(totalAmount: amount);
    _updateInstallmentPreview();
  }

  void setSingleDueDate(String dueDate) {
    state = state.copyWith(singleDueDate: dueDate);
    _updateInstallmentPreview();
  }

  void setAutomaticInstallments(int count) {
    state = state.copyWith(automaticInstallments: count);
    notifyListeners();
  }

  void setAutomaticFirstDueDate(String dueDate) {
    state = state.copyWith(automaticFirstDueDate: dueDate);
    notifyListeners();
  }

  void setAutomaticInstallmentAmount(double amount) {
    state = state.copyWith(automaticInstallmentAmount: amount);
    notifyListeners();
  }

  bool generateAutomaticInstallments() {
    final generated = _buildAutomaticInstallments(state);

    if (generated.isEmpty) {
      return false;
    }

    _setInstallments(generated);
    return true;
  }

  void addInstallment(double amount, String dueDate) {
    final newInstallment = InstallmentModel(
      amount: amount,
      dueDate: dueDate,
    );
    final installments = [...state.installments, newInstallment];
    _setInstallments(installments);
  }

  void removeInstallment(int index) {
    if (index >= 0 && index < state.installments.length) {
      final installments = [...state.installments];
      installments.removeAt(index);
      _setInstallments(installments);
    }
  }

  void updateInstallment(int index, double amount, String dueDate) {
    if (index >= 0 && index < state.installments.length) {
      final installments = [...state.installments];
      installments[index] = InstallmentModel(
        amount: amount,
        dueDate: dueDate,
      );
      _setInstallments(installments);
    }
  }

  Future<bool> save() async {
    final preparedState = _prepareStateForSubmission();

    try {
      state = preparedState.copyWith(makeRequest: true);
      notifyListeners();

      await service.saveAccountPayable(preparedState.toJson());

      state = FormAccountsPayableState.init();
      notifyListeners();
      return true;
    } catch (e) {
      print("ERROR: $e");
      state = preparedState.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  void _updateInstallmentPreview({bool notify = true}) {
    if (state.paymentMode == AccountsPayablePaymentMode.single) {
      if (state.totalAmount > 0 && state.singleDueDate.isNotEmpty) {
        _setInstallments([
          InstallmentModel(
            amount: state.totalAmount,
            dueDate: state.singleDueDate,
          )
        ],
            notify: false);
      } else {
        _setInstallments([], notify: false);
      }
    }

    if (notify) {
      notifyListeners();
    }
  }

  List<InstallmentModel> _buildAutomaticInstallments(
      FormAccountsPayableState currentState) {
    if (currentState.automaticInstallments <= 0 ||
        currentState.automaticInstallmentAmount <= 0 ||
        currentState.automaticFirstDueDate.isEmpty) {
      return [];
    }

    DateTime firstDueDate;
    try {
      firstDueDate =
          DateFormat('dd/MM/yyyy').parse(currentState.automaticFirstDueDate);
    } catch (_) {
      return [];
    }

    return List.generate(currentState.automaticInstallments, (index) {
      final dueDate = DateTime(
        firstDueDate.year,
        firstDueDate.month + index,
        firstDueDate.day,
      );

      return InstallmentModel(
        amount: currentState.automaticInstallmentAmount,
        dueDate: DateFormat('dd/MM/yyyy').format(dueDate),
        sequence: index + 1,
      );
    });
  }

  FormAccountsPayableState _prepareStateForSubmission() {
    var currentState = state;

    if (currentState.paymentMode == AccountsPayablePaymentMode.single) {
      _updateInstallmentPreview(notify: false);
      currentState = state;
    }

    if (currentState.paymentMode == AccountsPayablePaymentMode.automatic &&
        currentState.installments.isEmpty) {
      final generated = _buildAutomaticInstallments(currentState);
      currentState = currentState.copyWith(installments: generated);
    }

    return currentState;
  }

  void _setInstallments(List<InstallmentModel> installments,
      {bool notify = true}) {
    final normalized = installments.asMap().entries.map((entry) {
      final installment = entry.value;
      return installment.copyWith(sequence: entry.key + 1);
    }).toList();

    final total = normalized.fold<double>(
      0,
      (acc, installment) => acc + installment.amount,
    );

    state = state.copyWith(
      installments: normalized,
      totalAmount: state.paymentMode == AccountsPayablePaymentMode.single
          ? state.totalAmount
          : total,
    );

    if (notify) {
      notifyListeners();
    }
  }
}
