class MemberRegistrationFormState {
  String fullName;
  String phone;
  String? email;
  String? dni;
  DateTime? birthdate;
  String? gender;
  bool lgpdConsentAccepted;
  bool makeRequest;

  // Address
  String? addressStreet;
  String? addressNumber;
  String? addressComplement;
  String? addressDistrict;
  String? addressCity;
  String? addressState;
  String? addressZipCode;

  MemberRegistrationFormState({
    required this.fullName,
    required this.phone,
    this.email,
    this.dni,
    this.birthdate,
    this.gender,
    required this.lgpdConsentAccepted,
    required this.makeRequest,
    this.addressStreet,
    this.addressNumber,
    this.addressComplement,
    this.addressDistrict,
    this.addressCity,
    this.addressState,
    this.addressZipCode,
  });

  factory MemberRegistrationFormState.init() {
    return MemberRegistrationFormState(
      fullName: '',
      phone: '',
      lgpdConsentAccepted: false,
      makeRequest: false,
    );
  }

  MemberRegistrationFormState copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? dni,
    DateTime? birthdate,
    String? gender,
    bool? lgpdConsentAccepted,
    bool? makeRequest,
    String? addressStreet,
    String? addressNumber,
    String? addressComplement,
    String? addressDistrict,
    String? addressCity,
    String? addressState,
    String? addressZipCode,
  }) {
    return MemberRegistrationFormState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dni: dni ?? this.dni,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      lgpdConsentAccepted: lgpdConsentAccepted ?? this.lgpdConsentAccepted,
      makeRequest: makeRequest ?? this.makeRequest,
      addressStreet: addressStreet ?? this.addressStreet,
      addressNumber: addressNumber ?? this.addressNumber,
      addressComplement: addressComplement ?? this.addressComplement,
      addressDistrict: addressDistrict ?? this.addressDistrict,
      addressCity: addressCity ?? this.addressCity,
      addressState: addressState ?? this.addressState,
      addressZipCode: addressZipCode ?? this.addressZipCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (dni != null && dni!.isNotEmpty) 'dni': dni,
      if (birthdate != null) 'birthdate': birthdate!.toIso8601String(),
      if (gender != null && gender!.isNotEmpty) 'gender': gender,
      'lgpdConsentAccepted': lgpdConsentAccepted.toString(),
      if (addressStreet != null && addressStreet!.isNotEmpty)
        'addressStreet': addressStreet,
      if (addressNumber != null && addressNumber!.isNotEmpty)
        'addressNumber': addressNumber,
      if (addressComplement != null && addressComplement!.isNotEmpty)
        'addressComplement': addressComplement,
      if (addressDistrict != null && addressDistrict!.isNotEmpty)
        'addressDistrict': addressDistrict,
      if (addressCity != null && addressCity!.isNotEmpty)
        'addressCity': addressCity,
      if (addressState != null && addressState!.isNotEmpty)
        'addressState': addressState,
      if (addressZipCode != null && addressZipCode!.isNotEmpty)
        'addressZipCode': addressZipCode,
    };
  }
}
