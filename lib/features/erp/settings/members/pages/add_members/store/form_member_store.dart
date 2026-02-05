import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:gloria_finance/features/erp/settings/members/pages/add_members/state/form_member_state.dart';
import 'package:flutter/material.dart';

import '../../../services/save_member_service.dart';

class FormMemberStore extends ChangeNotifier {
  final SaveMemberService service;
  FormMemberState state;

  FormMemberStore({MemberModel? member})
    : service = SaveMemberService(),
      state =
          member != null
              ? FormMemberState.fromModel(member)
              : FormMemberState.init();

  void setName(String name) {
    state = state.copyWith(name: name);
    notifyListeners();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
    notifyListeners();
  }

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
    notifyListeners();
  }

  void setDni(String dni) {
    state = state.copyWith(dni: dni);
    notifyListeners();
  }

  void setConversionDate(String conversionDate) {
    state = state.copyWith(conversionDate: conversionDate);
    notifyListeners();
  }

  void setBaptismDate(String baptismDate) {
    state = state.copyWith(baptismDate: baptismDate);
    notifyListeners();
  }

  void setBirthdate(String birthdate) {
    state = state.copyWith(birthdate: birthdate);
    notifyListeners();
  }

  void setActive(bool active) {
    state = state.copyWith(active: active);
    notifyListeners();
  }

  Future<bool> save() async {
    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      await service.saveMember(state.toJson());

      state = FormMemberState.init();
      state = state.copyWith(makeRequest: false);

      notifyListeners();

      return true;
    } catch (e) {
      print("ERRROR ${e}");
      state = state.copyWith(makeRequest: false);

      notifyListeners();

      return false;
    }
  }
}
