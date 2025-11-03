import 'package:church_finance_bk/settings/members/models/member_model.dart';
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

  void addInstallment(InstallmentModel installment) {
    final updated = [...state.installments, installment];
    _setInstallments(updated);
  }

  void removeInstallment(int index) {
    final List<InstallmentModel> updatedInstallments = [...state.installments];
    updatedInstallments.removeAt(index);
    state = state.copyWith(installments: updatedInstallments);
    notifyListeners();
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
    final generated = _buildAutomaticInstallments();

    if (generated.isEmpty) {
      return false;
    }

    _setInstallments(generated);
    return true;
  }

  List<InstallmentModel> _buildAutomaticInstallments() {
    if (state.automaticInstallments <= 0 ||
        state.automaticInstallmentAmount <= 0 ||
        state.automaticFirstDueDate.isEmpty) {
      return [];
    }

    DateTime firstDueDate;
    try {
      firstDueDate = DateFormat('dd/MM/yyyy').parse(state.automaticFirstDueDate);
    } catch (_) {
      return [];
    }

    return List.generate(state.automaticInstallments, (index) {
      final dueDate = DateTime(
        firstDueDate.year,
        firstDueDate.month + index,
        firstDueDate.day,
      );

      return InstallmentModel(
        amount: state.automaticInstallmentAmount,
        dueDate: DateFormat('dd/MM/yyyy').format(dueDate),
        sequence: index + 1,
      );
    });
  }

  void _setInstallments(List<InstallmentModel> installments) {
    state = state.copyWith(installments: installments);
    notifyListeners();
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

  Future<void> save() async {
    try {
      state = state.copyWith(
        makeRequest: true,
      );
      notifyListeners();

      await service.sendAccountsReceivable(state.toJson());

      state = FormAccountsReceivableState.init();
      notifyListeners();
    } catch (e) {
      print("ERROR: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      rethrow;
    }
  }
}
