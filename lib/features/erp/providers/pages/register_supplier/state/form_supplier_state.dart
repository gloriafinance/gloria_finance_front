class FormSupplierState {
  bool makeRequest;
  String type;
  String dni;
  String name;
  String street;
  String number;
  String city;
  String state;
  String zipCode;
  String phone;
  String email;

  FormSupplierState({
    required this.makeRequest,
    required this.type,
    required this.dni,
    required this.name,
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.email,
  });

  factory FormSupplierState.init() {
    return FormSupplierState(
      makeRequest: false,
      type: '',
      dni: '',
      name: '',
      street: '',
      number: '',
      city: '',
      state: '',
      zipCode: '',
      phone: '',
      email: '',
    );
  }

  FormSupplierState copyWith({
    bool? makeRequest,
    String? type,
    String? dni,
    String? name,
    String? street,
    String? number,
    String? city,
    String? state,
    String? zipCode,
    String? phone,
    String? email,
  }) {
    return FormSupplierState(
      makeRequest: makeRequest ?? this.makeRequest,
      type: type ?? this.type,
      dni: dni ?? this.dni,
      name: name ?? this.name,
      street: street ?? this.street,
      number: number ?? this.number,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dni': dni,
      'name': name,
      'address': {
        'street': street,
        'number': number,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      },
      'phone': phone,
      'email': email,
    };
  }
}
