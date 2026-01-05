import 'package:church_finance_bk/core/utils/date_formatter.dart';

import '../../../models/member_model.dart';

class FormMemberState {
  String? memberId;
  String name;
  String email;
  String phone;
  String dni;
  String conversionDate;
  String? baptismDate;
  String birthdate;
  bool active;
  bool makeRequest;

  FormMemberState({
    required this.makeRequest,
    this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    required this.conversionDate,
    this.baptismDate,
    required this.birthdate,
    required this.active,
  });

  factory FormMemberState.init() {
    return FormMemberState(
      makeRequest: false,
      active: true,
      memberId: null,
      name: '',
      email: '',
      phone: '',
      dni: '',
      conversionDate: '',
      birthdate: '',
    );
  }

  factory FormMemberState.fromModel(MemberModel member) {
    return FormMemberState(
      makeRequest: false,
      memberId: member.memberId,
      name: member.name,
      email: member.email,
      phone: member.phone,
      dni: member.dni,
      conversionDate: member.conversionDate,
      baptismDate: member.baptismDate,
      birthdate: member.birthdate,
      active: member.active,
    );
  }

  FormMemberState copyWith({
    String? memberId,
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
      memberId: memberId ?? this.memberId,
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
    final payload = {
      'name': name,
      'email': email,
      'phone': phone,
      'dni': dni,
      'conversionDate': convertDateFormat(conversionDate),
      'baptismDate': convertDateFormat(baptismDate),
      'birthdate': convertDateFormat(birthdate),
      'active': active,
      'isTreasurer': false,
    };

    if (memberId != null) {
      payload['memberId'] = memberId!;
    }

    return payload;
  }
}
