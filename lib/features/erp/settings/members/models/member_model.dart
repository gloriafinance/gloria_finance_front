String? _readStringOrNull(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final stringValue = value.toString().trim();
    if (stringValue.isEmpty || stringValue == 'null') continue;
    return stringValue;
  }
  return null;
}

String _buildAddress(Map<String, dynamic> json) {
  final directAddress = _readStringOrNull(json, ['address']);
  if (directAddress != null) {
    return directAddress;
  }

  final street = _readStringOrNull(json, ['addressStreet', 'street']);
  final number = _readStringOrNull(json, ['addressNumber', 'number']);
  final complement =
      _readStringOrNull(json, ['addressComplement', 'complement']);
  final district = _readStringOrNull(json, ['addressDistrict', 'district']);
  final city = _readStringOrNull(json, ['addressCity', 'city']);
  final state = _readStringOrNull(json, ['addressState', 'state']);
  final zipCode =
      _readStringOrNull(json, ['addressZipCode', 'zipCode', 'postalCode']);

  final cityState = [
    if (city != null) city,
    if (state != null) state,
  ];

  final segments = [
    street,
    number,
    complement,
    district,
    if (cityState.isNotEmpty) cityState.join('/'),
    zipCode,
  ].whereType<String>().toList();

  return segments.isEmpty ? '' : segments.join(', ');
}

class MemberModel {
  String memberId;
  String name;
  String email;
  String phone;
  String address;
  String dni;
  String conversionDate;
  String? baptismDate;
  String birthdate;
  bool isMinister;
  bool isTreasurer;
  bool active = true;

  // Church church;
  // Region region;

  MemberModel({
    required this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    required this.conversionDate,
    this.baptismDate,
    required this.birthdate,
    required this.isMinister,
    required this.isTreasurer,
    required this.active,
    required this.address
    // required this.church,
    // required this.region,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberId: json['memberId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dni: json['dni'],
      conversionDate: json['conversionDate'],
      baptismDate: json['baptismDate'],
      birthdate: json['birthdate'],
      isMinister: json['isMinister'],
      isTreasurer: json['isTreasurer'] ?? false,
      active: json['active'] ?? true,
      address: _buildAddress(json),
      //church: Church.fromJson(json['church']),
      //region: Region.fromJson(json['region']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'name': name,
      'email': email,
      'phone': phone,
      'dni': dni,
      'conversionDate': conversionDate,
      'baptismDate': baptismDate,
      'birthdate': birthdate,
      'isMinister': isMinister,
      'isTreasurer': isTreasurer,
      'active': active,
      'address': address,
      // 'church': church.toJson(),
      // 'region': region.toJson(),
    };
  }
}

class Church {
  String name;
  String churchId;

  Church({
    required this.name,
    required this.churchId,
  });

  factory Church.fromJson(Map<String, dynamic> json) {
    return Church(
      name: json['name'],
      churchId: json['churchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'churchId': churchId,
    };
  }
}

class Region {
  String regionId;
  String name;
  DateTime createdAt;

  Region({
    required this.regionId,
    required this.name,
    required this.createdAt,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      regionId: json['regionId'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regionId': regionId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
