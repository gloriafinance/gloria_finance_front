class FormMemberState {
  String name;
  String email;
  String phone;
  String dni;
  String conversionDate;
  String? baptismDate;
  String birthdate;
  bool active;
  bool makeRequest;

  FormMemberState(
      {required this.makeRequest,
      required this.name,
      required this.email,
      required this.phone,
      required this.dni,
      required this.conversionDate,
      this.baptismDate,
      required this.birthdate,
      required this.active});

  factory FormMemberState.init() {
    return FormMemberState(
      makeRequest: false,
      active: true,
      name: '',
      email: '',
      phone: '',
      dni: '',
      conversionDate: '',
      birthdate: '',
    );
  }

  FormMemberState copyWith({
    String? name,
    String? email,
    String? phone,
    String? dni,
    String? conversionDate,
    String? baptismDate,
    String? birthdate,
    bool? makeRequest,
    bool? active,
  }) {
    return FormMemberState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dni: dni ?? this.dni,
      conversionDate: conversionDate ?? this.conversionDate,
      baptismDate: baptismDate ?? this.baptismDate,
      birthdate: birthdate ?? this.birthdate,
      active: active ?? this.active,
      makeRequest: makeRequest ?? this.makeRequest,
    );
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
      'active': active,
    };
  }
}
