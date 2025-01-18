import 'package:flutter/material.dart';

import '../state/purchase_register_form_state.dart';

class AddItemPurchaseFromStore extends ChangeNotifier {
  late String _product;
  late double _priceUnit = 0;
  late int _quantity = 0;
  late double _total = 0;
  late bool _addData = false;

  String get product => _product;

  double get priceUnit => _priceUnit;

  int get quantity => _quantity;

  double get total => _total;

  bool get hasData => _addData;

  void setProduct(String productName) {
    _product = productName;
  }

  void setPriceUnit(double priceUnit) {
    _priceUnit = priceUnit;

    notifyListeners();
  }

  void setQuantity(int quantity) {
    _quantity = quantity;

    notifyListeners();
  }

  void setTotal(double total) {
    _total = total;

    notifyListeners();
  }

  void clear() {
    _product = '';
    _priceUnit = 0;
    _quantity = 0;
    _total = 0;
    _addData = false;

    notifyListeners();
  }

  PurchaseItem getItem() {
    notifyListeners();

    return PurchaseItem(
      productName: _product,
      priceUnit: _priceUnit,
      quantity: _quantity,
      total: _total,
    );
  }
}
