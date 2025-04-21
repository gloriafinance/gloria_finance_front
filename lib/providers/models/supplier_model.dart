enum SupplierType {
  SUPPLIER,
  TECHNOLOGY_PROVIDER,
  FINANCIAL_PROVIDER,
  LOGISTICS_PROVIDER,
  CONSULTING_PROVIDER,
  MAINTENANCE_PROVIDER
}

extension SupplierTypeExtension on SupplierType {
  String get apiValue {
    return toString().split('.').last;
  }

  String get friendlyName {
    switch (this) {
      case SupplierType.SUPPLIER:
        return 'Fornecedor de Bens';
      case SupplierType.TECHNOLOGY_PROVIDER:
        return 'Fornecedor de Tecnologia';
      case SupplierType.FINANCIAL_PROVIDER:
        return 'Fornecedor Financeiro';
      case SupplierType.LOGISTICS_PROVIDER:
        return 'Fornecedor de Logística';
      case SupplierType.CONSULTING_PROVIDER:
        return 'Fornecedor de Consultoria';
      case SupplierType.MAINTENANCE_PROVIDER:
        return 'Fornecedor de Manutenção';
    }
  }
}

class SupplierAddress {
  final String street;
  final String number;
  final String city;
  final String state;
  final String zipCode;

  SupplierAddress({
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory SupplierAddress.fromJson(Map<String, dynamic> json) {
    return SupplierAddress(
      street: json['street'],
      number: json['number'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'number': number,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }
}

class SupplierModel {
  final String? supplierId;
  final String type;
  final String dni;
  final String name;
  final SupplierAddress address;
  final String phone;
  final String email;

  SupplierModel({
    this.supplierId,
    required this.type,
    required this.dni,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  SupplierModel.fromMap(Map<String, dynamic> json)
      : supplierId = json['supplierId'],
        type = json['type'],
        dni = json['dni'],
        name = json['name'],
        address = SupplierAddress.fromJson(json['address']),
        phone = json['phone'],
        email = json['email'];

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dni': dni,
      'name': name,
      'address': address.toJson(),
      'phone': phone,
      'email': email,
    };
  }
}
