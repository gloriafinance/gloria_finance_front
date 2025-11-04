String? _readStringOrNull(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final stringValue = value.toString();
    if (stringValue.isEmpty || stringValue == 'null') continue;
    return stringValue;
  }
  return null;
}

String _readString(
  Map<String, dynamic> json,
  List<String> keys, {
  String fallback = '',
}) {
  return _readStringOrNull(json, keys) ?? fallback;
}

Map<String, dynamic>? _mapOrNull(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value as Map);
  }
  return null;
}

enum SupplierType {
  SUPPLIER,
  TECHNOLOGY_PROVIDER,
  FINANCIAL_PROVIDER,
  LOGISTICS_PROVIDER,
  CONSULTING_PROVIDER,
  MAINTENANCE_PROVIDER,
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
      street: _readString(json, ['street', 'addressStreet']),
      number: _readString(json, ['number', 'addressNumber']),
      city: _readString(json, ['city', 'addressCity']),
      state: _readString(json, ['state', 'addressState']),
      zipCode: _readString(json, ['zipCode', 'postalCode']),
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
  final SupplierAddress? address;
  final String phone;
  final String? email;

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
    : supplierId = _readStringOrNull(json, ['supplierId', 'id']),
      type = _readString(json, [
        'type',
        'supplierType',
      ], fallback: SupplierType.SUPPLIER.apiValue),
      dni = _readString(json, ['dni', 'supplierDNI']),
      name = _readString(json, ['name', 'supplierName']),
      address =
          (() {
            final addressJson = _mapOrNull(json['address']);
            if (addressJson == null) return null;
            return SupplierAddress.fromJson(addressJson);
          })(),
      phone = _readString(json, ['phone', 'supplierPhone']),
      email = _readStringOrNull(json, ['email', 'supplierEmail']);

  getType() {
    return SupplierType.values
        .firstWhere(
          (e) => e.apiValue == type,
          orElse: () => SupplierType.SUPPLIER,
        )
        .friendlyName;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dni': dni,
      'name': name,
      'address': address?.toJson(),
      'phone': phone,
      'email': email,
    };
  }
}
