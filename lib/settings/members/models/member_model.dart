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
      address: json['address'] ?? '',
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
