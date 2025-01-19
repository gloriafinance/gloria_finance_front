import 'package:flutter/material.dart';

class FormMemberState extends ChangeNotifier {
  String name;
  String email;
  String phone;
  String dni;
  String conversionDate;
  String? baptismDate;
  String birthdate;
  bool makeRequest = false;

  FormMemberState({
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    required this.conversionDate,
    this.baptismDate,
    required this.birthdate,
  });

  factory FormMemberState.init() {
    return FormMemberState(
      name: '',
      email: '',
      phone: '',
      dni: '',
      conversionDate: '',
      birthdate: '',
    );
  }

  copyWith({
    String? name,
    String? email,
    String? phone,
    String? dni,
    String? conversionDate,
    String? baptismDate,
    String? birthdate,
    bool? makeRequest,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.phone = phone ?? this.phone;
    this.dni = dni ?? this.dni;
    this.conversionDate = conversionDate ?? this.conversionDate;
    this.baptismDate = baptismDate ?? this.baptismDate;
    this.birthdate = birthdate ?? this.birthdate;
    this.makeRequest = makeRequest ?? this.makeRequest;

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dni': dni,
      'conversionDate': conversionDate,
      'baptismDate': baptismDate,
      'birthdate': birthdate,
    };
  }
}
