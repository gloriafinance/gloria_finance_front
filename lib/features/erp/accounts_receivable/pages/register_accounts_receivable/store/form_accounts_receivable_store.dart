import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/installment_model.dart';
import '../../../accounts_receivable_service.dart';
import '../../../models/index.dart';
import '../state/form_accounts_receivable_state.dart';

class FormAccountsReceivableStore extends ChangeNotifier {
  var service = AccountsReceivableService();
  FormAccountsReceivableState state = FormAccountsReceivableState.init();

  void setDebtorType(DebtorType debtorType) {
    state = state.copyWith(
      debtorType: debtorType,
      debtorDNI: '',
      debtorName: '',
    );
    notifyListeners();
  }

  void setAvailabilityAccountId(String availabilityAccountId) {
    state = state.copyWith(availabilityAccountId: availabilityAccountId);
    notifyListeners();
  }

  void setFile(MultipartFile file) {
    state = state.copyWith(file: file);
    notifyListeners();
  }

  void setIsMovementBank(bool isMovementBank) {
    state = state.copyWith(isMovementBank: isMovementBank);
    notifyListeners();
  }

  void setDebtorDNI(String debtorDNI) {
    state = state.copyWith(debtorDNI: debtorDNI);
    //notifyListeners();
  }

  void setDebtorPhone(String debtorPhone) {
    state = state.copyWith(debtorPhone: debtorPhone);
    //notifyListeners();
  }

  void setDebtorName(String debtorName) {
    state = state.copyWith(debtorName: debtorName);
    //notifyListeners();
  }

  void setDebtorEmail(String debtorEmail) {
    state = state.copyWith(debtorEmail: debtorEmail);
    //notifyListeners();
  }

  void setDebtorAddress(String debtorAddress) {
    state = state.copyWith(debtorAddress: debtorAddress);
    //notifyListeners();
  }

  void setFinancialConceptId(String financialConceptId) {
    state = state.copyWith(financialConceptId: financialConceptId);
    notifyListeners();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setType(AccountsReceivableType type) {
    state = state.copyWith(type: type);
    notifyListeners();
  }

  void setPaymentMode(AccountsReceivablePaymentMode paymentMode) {
    if (paymentMode == state.paymentMode) {
      return;
    }

    switch (paymentMode) {
      case AccountsReceivablePaymentMode.single:
        state = state.copyWith(
          paymentMode: paymentMode,
          installments: const <InstallmentModel>[],
          totalAmount: 0,
          singleDueDate: '',
          automaticInstallments: 0,
          automaticInstallmentAmount: 0,
          automaticFirstDueDate: '',
        );
        _updateSingleInstallment();
        break;
      case AccountsReceivablePaymentMode.automatic:
        state = state.copyWith(
          paymentMode: paymentMode,
          installments: const <InstallmentModel>[],
          totalAmount: 0,
          singleDueDate: '',
          automaticInstallments: 0,
          automaticInstallmentAmount: 0,
          automaticFirstDueDate: '',
        );
        notifyListeners();
        break;
    }
  }

  void setTotalAmount(double amount) {
    if (amount == state.totalAmount) {
      return;
    }

    state = state.copyWith(totalAmount: amount);
    _updateSingleInstallment();
  }

  void setSingleDueDate(String dueDate) {
    if (dueDate == state.singleDueDate) {
      return;
    }

    state = state.copyWith(singleDueDate: dueDate);
    _updateSingleInstallment();
  }

  void setAutomaticInstallments(int count) {
    state = state.copyWith(automaticInstallments: count);
    notifyListeners();
  }

  void setAutomaticInstallmentAmount(double amount) {
    state = state.copyWith(automaticInstallmentAmount: amount);
    notifyListeners();
  }

  void setAutomaticFirstDueDate(String dueDate) {
    state = state.copyWith(automaticFirstDueDate: dueDate);
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

  List<InstallmentModel> _buildAutomaticInstallments(
    FormAccountsReceivableState currentState,
  ) {
    final isContribution =
        currentState.type == AccountsReceivableType.CONTRIBUTION;
    final hasValidAmount =
        isContribution
            ? currentState.automaticInstallmentAmount >= 0
            : currentState.automaticInstallmentAmount > 0;

    if (currentState.automaticInstallments <= 0 ||
        !hasValidAmount ||
        currentState.automaticFirstDueDate.isEmpty) {
      return [];
    }

    DateTime firstDueDate;
    try {
      firstDueDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(currentState.automaticFirstDueDate);
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

  void _setInstallments(
    List<InstallmentModel> installments, {
    bool notify = true,
  }) {
    final normalized =
        installments.asMap().entries.map((entry) {
          final installment = entry.value;
          return installment.copyWith(sequence: entry.key + 1);
        }).toList();

    final total = normalized.fold<double>(0, (sum, installment) {
      return sum + installment.amount;
    });

    state = state.copyWith(
      installments: normalized,
      totalAmount:
          state.paymentMode == AccountsReceivablePaymentMode.single
              ? state.totalAmount
              : total,
    );

    if (notify) {
      notifyListeners();
    }
  }

  void _updateSingleInstallment({bool notify = true}) {
    if (state.paymentMode != AccountsReceivablePaymentMode.single) {
      return;
    }

    if (state.totalAmount > 0 && state.singleDueDate.isNotEmpty) {
      _setInstallments([
        InstallmentModel(
          amount: state.totalAmount,
          dueDate: state.singleDueDate,
        ),
      ], notify: false);
    } else {
      _setInstallments(const <InstallmentModel>[], notify: false);
    }

    if (notify) {
      notifyListeners();
    }
  }

  void setMember(MemberModel member) {
    state = state.copyWith(
      debtorDNI: member.dni,
      debtorName: member.name,
      debtorType: DebtorType.MEMBER,
      debtorPhone: member.phone ?? '',
      debtorEmail: member.email ?? '',
      debtorAddress: member.address.trim(),
    );
    notifyListeners();
  }

  void setSymbolFormatMoney(String symbol) {
    state = state.copyWith(symbolFormatMoney: symbol);
    notifyListeners();
  }

  Future<void> save() async {
    try {
      final preparedState = _prepareStateForSubmission();
      state = preparedState.copyWith(makeRequest: true);
      notifyListeners();

      await service.sendAccountsReceivable(preparedState.toJson());

      state = FormAccountsReceivableState.init();
      notifyListeners();
    } catch (e) {
      print("ERROR: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      rethrow;
    }
  }

  FormAccountsReceivableState _prepareStateForSubmission() {
    var currentState = state;

    if (currentState.paymentMode == AccountsReceivablePaymentMode.single) {
      _updateSingleInstallment(notify: false);
      currentState = state;
    }

    if (currentState.paymentMode == AccountsReceivablePaymentMode.automatic &&
        currentState.installments.isEmpty) {
      final generated = _buildAutomaticInstallments(currentState);
      if (generated.isNotEmpty) {
        final total = generated.fold<double>(
          0,
          (sum, installment) => sum + installment.amount,
        );
        currentState = currentState.copyWith(
          installments: generated,
          totalAmount: total,
        );
      }
    }

    return currentState;
  }
}
