class MemberModel {
  String memberId;
  String name;
  String email;
  String phone;
  DateTime createdAt;
  String dni;
  DateTime conversionDate;
  DateTime baptismDate;
  DateTime birthdate;
  bool isMinister;
  bool isTreasurer;
  Church church;
  Region region;

  MemberModel({
    required this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.dni,
    required this.conversionDate,
    required this.baptismDate,
    required this.birthdate,
    required this.isMinister,
    required this.isTreasurer,
    required this.church,
    required this.region,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberId: json['memberId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      dni: json['dni'],
      conversionDate: DateTime.parse(json['conversionDate']),
      baptismDate: DateTime.parse(json['baptismDate']),
      birthdate: DateTime.parse(json['birthdate']),
      isMinister: json['isMinister'],
      isTreasurer: json['isTreasurer'],
      church: Church.fromJson(json['church']),
      region: Region.fromJson(json['region']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'dni': dni,
      'conversionDate': conversionDate.toIso8601String(),
      'baptismDate': baptismDate.toIso8601String(),
      'birthdate': birthdate.toIso8601String(),
      'isMinister': isMinister,
      'isTreasurer': isTreasurer,
      'church': church.toJson(),
      'region': region.toJson(),
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
