import 'package:flutter/material.dart';

import '../../../supplier_service.dart';
import '../state/suppliers_list_state.dart';

class SuppliersListStore extends ChangeNotifier {
  var service = SupplierService();
  SuppliersListState state = SuppliersListState.empty();

  searchSuppliers() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      var suppliers = await service.getSuppliers();
      state = state.copyWith(suppliers: suppliers, makeRequest: false);
    } catch (e) {
      print("ERRROR ==== ${e}");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
