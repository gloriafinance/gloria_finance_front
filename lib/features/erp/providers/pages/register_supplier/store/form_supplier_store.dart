import 'package:flutter/material.dart';

import '../../../supplier_service.dart';
import '../state/form_supplier_state.dart';

class FormSupplierStore extends ChangeNotifier {
  var service = SupplierService();
  FormSupplierState state = FormSupplierState.init();

  void setDni(String dni) {
    state = state.copyWith(dni: dni);
    notifyListeners();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
    notifyListeners();
  }

  void setStreet(String street) {
    state = state.copyWith(street: street);
    notifyListeners();
  }

  void setNumber(String number) {
    state = state.copyWith(number: number);
    notifyListeners();
  }

  void setCity(String city) {
    state = state.copyWith(city: city);
    notifyListeners();
  }

  void setState(String stateName) {
    state = state.copyWith(state: stateName);
    notifyListeners();
  }

  void setZipCode(String zipCode) {
    state = state.copyWith(zipCode: zipCode);
    notifyListeners();
  }

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
    notifyListeners();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
    notifyListeners();
  }

  // Añadir este método
  void setType(String type) {
    state = state.copyWith(type: type);
    notifyListeners();
  }

  Future<bool> save() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await service.saveSupplier(state.toJson());

      state = FormSupplierState.init();
      state = state.copyWith(makeRequest: false);

      notifyListeners();

      return true;
    } catch (e) {
      print("ERROR: $e");
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }
}
