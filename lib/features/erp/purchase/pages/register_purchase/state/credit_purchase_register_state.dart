import 'package:dio/dio.dart';

import 'purchase_register_form_state.dart';

class CreditPurchaseRegisterState {
  final bool makeRequest;
  final String costCenterId;
  final String purchaseDate;
  final double total;
  final double tax;
  final List<MultipartFile> files;
  final List<PurchaseItem> items;
  final String symbolFormatMoney;

  CreditPurchaseRegisterState({
    required this.makeRequest,
    required this.costCenterId,
    required this.purchaseDate,
    required this.total,
    required this.tax,
    required this.files,
    required this.items,
    required this.symbolFormatMoney,
  });

  factory CreditPurchaseRegisterState.init({String symbolFormatMoney = ''}) {
    return CreditPurchaseRegisterState(
      makeRequest: false,
      costCenterId: '',
      purchaseDate: '',
      total: 0,
      tax: 0,
      files: const [],
      items: const [],
      symbolFormatMoney: symbolFormatMoney,
    );
  }

  CreditPurchaseRegisterState copyWith({
    bool? makeRequest,
    String? costCenterId,
    String? purchaseDate,
    double? total,
    double? tax,
    List<MultipartFile>? files,
    List<PurchaseItem>? items,
    String? symbolFormatMoney,
  }) {
    return CreditPurchaseRegisterState(
      makeRequest: makeRequest ?? this.makeRequest,
      costCenterId: costCenterId ?? this.costCenterId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      files: files ?? this.files,
      items: items ?? this.items,
      symbolFormatMoney: symbolFormatMoney ?? this.symbolFormatMoney,
    );
  }
}
