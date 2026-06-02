import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/member_registration_models.dart';
import '../service/member_registration_service.dart';
import '../state/member_registration_form_state.dart';

class MemberRegistrationStore extends ChangeNotifier {
  final MemberRegistrationService _service;

  bool loading = false;
  String? error;
  PublicChurchInfo? churchInfo;
  bool submitted = false;
  MemberRegistrationFormState formState = MemberRegistrationFormState.init();

  MemberRegistrationStore({MemberRegistrationService? service})
      : _service = service ?? MemberRegistrationService();

  Future<void> loadChurchInfo(String token) async {
    loading = true;
    error = null;
    churchInfo = null;
    notifyListeners();

    try {
      churchInfo = await _service.getChurchInfo(token);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = 'token_invalid';
      notifyListeners();
    }
  }

  Future<bool> submit(
    String token,
    Uint8List photoBytes,
    String photoName,
    String photoMimeType,
  ) async {
    formState = formState.copyWith(makeRequest: true);
    error = null;
    notifyListeners();

    try {
      await _service.submitRegistration(
        token: token,
        fields: formState.toJson(),
        photoBytes: photoBytes,
        photoName: photoName,
        photoMimeType: photoMimeType,
      );
      formState = formState.copyWith(makeRequest: false);
      submitted = true;
      notifyListeners();
      return true;
    } catch (e) {
      formState = formState.copyWith(makeRequest: false);
      error = 'submit_failed';
      notifyListeners();
      return false;
    }
  }

  void setFullName(String value) {
    formState = formState.copyWith(fullName: value);
    notifyListeners();
  }

  void setPhone(String value) {
    formState = formState.copyWith(phone: value);
    notifyListeners();
  }

  void setEmail(String value) {
    formState = formState.copyWith(email: value);
    notifyListeners();
  }

  void setDni(String value) {
    formState = formState.copyWith(dni: value);
    notifyListeners();
  }

  void setBirthdate(DateTime? value) {
    formState = formState.copyWith(birthdate: value);
    notifyListeners();
  }

  void setGender(String? value) {
    formState = formState.copyWith(gender: value);
    notifyListeners();
  }

  void setLgpdConsent(bool value) {
    formState = formState.copyWith(lgpdConsentAccepted: value);
    notifyListeners();
  }

  void setAddressStreet(String value) {
    formState = formState.copyWith(addressStreet: value);
    notifyListeners();
  }

  void setAddressNumber(String value) {
    formState = formState.copyWith(addressNumber: value);
    notifyListeners();
  }

  void setAddressComplement(String value) {
    formState = formState.copyWith(addressComplement: value);
    notifyListeners();
  }

  void setAddressDistrict(String value) {
    formState = formState.copyWith(addressDistrict: value);
    notifyListeners();
  }

  void setAddressCity(String value) {
    formState = formState.copyWith(addressCity: value);
    notifyListeners();
  }

  void setAddressState(String value) {
    formState = formState.copyWith(addressState: value);
    notifyListeners();
  }

  void setAddressZipCode(String value) {
    formState = formState.copyWith(addressZipCode: value);
    notifyListeners();
  }
}
