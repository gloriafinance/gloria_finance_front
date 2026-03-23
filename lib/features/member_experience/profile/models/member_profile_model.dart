class MemberProfileModel {
  final String memberId;
  final String name;
  final String email;
  final String phone;
  final String dni;
  final String createdAt;
  final String conversionDate;
  final String baptismDate;
  final String birthdate;
  final MemberProfileChurchModel? church;
  final bool active;

  MemberProfileModel({
    required this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    required this.createdAt,
    required this.conversionDate,
    required this.baptismDate,
    required this.birthdate,
    this.church,
    required this.active,
  });

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) {
    return MemberProfileModel(
      memberId: json['memberId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dni: json['dni'] ?? '',
      createdAt: json['createdAt'] ?? '',
      conversionDate: json['conversionDate'] ?? '',
      baptismDate: json['baptismDate'] ?? '',
      birthdate: json['birthdate'] ?? '',
      church:
          json['church'] != null
              ? MemberProfileChurchModel.fromJson(json['church'])
              : null,
      active: json['active'] ?? false,
    );
  }
}

class MemberProfileChurchModel {
  final String churchId;
  final String name;

  MemberProfileChurchModel({required this.churchId, required this.name});

  factory MemberProfileChurchModel.fromJson(Map<String, dynamic> json) {
    return MemberProfileChurchModel(
      churchId: json['churchId'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
