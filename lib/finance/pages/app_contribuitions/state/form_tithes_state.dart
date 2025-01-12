import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FormTitheState extends ChangeNotifier {
  double amount;
  String month;
  MultipartFile? file;

  FormTitheState({
    required this.amount,
    required this.month,
    this.file,
  });

  factory FormTitheState.init() {
    return FormTitheState(
      amount: 0.0,
      month: '',
    );
  }

  copyWith({
    double? amount,
    String? month,
    MultipartFile? file,
  }) {
    this.amount = amount ?? this.amount;
    this.month = month ?? this.month;
    this.file = file ?? this.file;

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'month': month,
      'file': file,
    };
  }
}
