import 'package:gloria_finance/features/erp/settings/members/models/member_status.dart';

class MemberProfileModel {
  final String memberId;
  final String name;
  final String email;
  final String phone;
  final String dni;
  final String? profilePhoto;
  final String createdAt;
  final String conversionDate;
  final String baptismDate;
  final String birthdate;
  final MemberProfileChurchModel? church;
  final MemberStatus status;

  MemberProfileModel({
    required this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    this.profilePhoto,
    required this.createdAt,
    required this.conversionDate,
    required this.baptismDate,
    required this.birthdate,
    this.church,
    required this.status,
  });

  MemberProfileModel copyWith({
    String? memberId,
    String? name,
    String? email,
    String? phone,
    String? dni,
    String? profilePhoto,
    String? createdAt,
    String? conversionDate,
    String? baptismDate,
    String? birthdate,
    MemberProfileChurchModel? church,
    MemberStatus? status,
  }) {
    return MemberProfileModel(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dni: dni ?? this.dni,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      conversionDate: conversionDate ?? this.conversionDate,
      baptismDate: baptismDate ?? this.baptismDate,
      birthdate: birthdate ?? this.birthdate,
      church: church ?? this.church,
      status: status ?? this.status,
    );
  }

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) {
    return MemberProfileModel(
      memberId: json['memberId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dni: json['dni'] ?? '',
      profilePhoto: json['profilePhoto'] as String?,
      createdAt: json['createdAt'] ?? '',
      conversionDate: json['conversionDate'] ?? '',
      baptismDate: json['baptismDate'] ?? '',
      birthdate: json['birthdate'] ?? '',
      church:
          json['church'] != null
              ? MemberProfileChurchModel.fromJson(json['church'])
              : null,
      status: MemberStatus.fromString(json['status']),
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
