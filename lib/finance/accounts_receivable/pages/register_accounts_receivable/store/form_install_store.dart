import 'package:flutter/material.dart';

import '../../../models/index.dart';

class FormInstallStore extends ChangeNotifier {
  String _installmentDate = '';
  double _installmentValue = 0;
  bool _addData = false;

  String get installmentDate => _installmentDate;

  double get installmentValue => _installmentValue;

  bool get hasData => _addData;

  void setInstallmentDate(String date) {
    print('Setting installment date: $date');
    _installmentDate = date;
    notifyListeners();
  }

  void setInstallmentValue(double value) {
    _installmentValue = value;
  }

  void clear() {
    _installmentDate = '';
    _installmentValue = 0;
    _addData = false;
    notifyListeners();
  }

  InstallmentModel getInstallment() {
    notifyListeners();

    return InstallmentModel(
      dueDate: _installmentDate,
      amount: _installmentValue,
    );
  }
}
