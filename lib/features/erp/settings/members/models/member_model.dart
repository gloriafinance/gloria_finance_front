import 'member_status.dart';

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
  final rawAddress = json['address'];
  if (rawAddress is String) {
    final directAddress = rawAddress.trim();
    if (directAddress.isNotEmpty && directAddress != 'null') {
      return directAddress;
    }
  }

  final addressJson =
      rawAddress is Map<String, dynamic> ? rawAddress : <String, dynamic>{};

  String? readAddressField(List<String> keys) {
    return _readStringOrNull(addressJson, keys) ?? _readStringOrNull(json, keys);
  }

  final directAddress =
      _readStringOrNull(addressJson, ['formattedAddress']) ??
      _readStringOrNull(json, ['formattedAddress']);
  if (directAddress != null) {
    return directAddress;
  }

  final street = readAddressField(['addressStreet', 'street']);
  final number = readAddressField(['addressNumber', 'number']);
  final complement = readAddressField(['addressComplement', 'complement']);
  final district = readAddressField(['addressDistrict', 'district']);
  final city = readAddressField(['addressCity', 'city']);
  final state = readAddressField(['addressState', 'state']);
  final zipCode = readAddressField(['addressZipCode', 'zipCode', 'postalCode']);

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

bool? _readBoolOrNull(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
  }
  return null;
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
  MemberStatus status;
  String? createdAt;
  String? profilePhoto;
  String? gender;
  Church? church;
  LgpdConsentInfo? lgpdConsent;

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
    required this.status,
    required this.address,
    this.createdAt,
    this.profilePhoto,
    this.gender,
    this.church,
    this.lgpdConsent,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberId: json['memberId'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dni: json['dni'] ?? '',
      conversionDate: json['conversionDate'] ?? '',
      baptismDate: _readStringOrNull(json, ['baptismDate']),
      birthdate: json['birthdate'] ?? '',
      isMinister: json['isMinister'] ?? false,
      isTreasurer: json['isTreasurer'] ?? false,
      status: MemberStatus.fromString(json['status']),
      address: _buildAddress(json),
      createdAt: _readStringOrNull(json, ['createdAt']),
      profilePhoto: _readStringOrNull(json, ['profilePhoto']),
      gender: _readStringOrNull(json, ['gender']),
      church:
          json['church'] is Map<String, dynamic>
              ? Church.fromJson(json['church'])
              : null,
      lgpdConsent:
          json['lgpdConsent'] is Map<String, dynamic>
              ? LgpdConsentInfo.fromJson(json['lgpdConsent'])
              : null,
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
      'status': status.value,
      'address': address,
      'createdAt': createdAt,
      'profilePhoto': profilePhoto,
      'gender': gender,
      'church': church?.toJson(),
      'lgpdConsent': lgpdConsent?.toJson(),
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

class LgpdConsentInfo {
  bool accepted;
  String? acceptedAt;
  String? source;

  LgpdConsentInfo({
    required this.accepted,
    this.acceptedAt,
    this.source,
  });

  factory LgpdConsentInfo.fromJson(Map<String, dynamic> json) {
    return LgpdConsentInfo(
      accepted: _readBoolOrNull(json, ['accepted']) ?? false,
      acceptedAt: _readStringOrNull(json, ['acceptedAt']),
      source: _readStringOrNull(json, ['source']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accepted': accepted,
      'acceptedAt': acceptedAt,
      'source': source,
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
