class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String createdAt;
  final bool isActive;
  final String userId;
  final String churchId;
  final List<String> roles;
  String? memberId;

  AuthSessionModel({
    required this.churchId,
    required this.token,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isActive,
    required this.userId,
    required this.roles,
    this.memberId,
  });

  factory AuthSessionModel.empty() {
    return AuthSessionModel(
      token: "",
      name: "",
      email: "",
      createdAt: "",
      isActive: false,
      userId: "",
      churchId: '',
      roles: [],
    );
  }

  AuthSessionModel copyWith({
    String? token,
    String? churchId,
    String? name,
    String? email,
    String? createdAt,
    bool? isActive,
    String? userId,
    String? memberId,
    List<String>? roles,
  }) {
    return AuthSessionModel(
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      churchId: churchId ?? this.churchId,
      memberId: memberId ?? this.memberId,
      roles: roles ?? this.roles,
    );
  }

  static AuthSessionModel fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      token: json['token'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      userId: json['userId'],
      churchId: json['churchId'],
      memberId: json['memberId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roles': roles,
      'token': token,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'isActive': isActive,
      'userId': userId,
      'churchId': churchId,
      'memberId': memberId,
    };
  }

  bool isSessionStarted() {
    return token != "";
  }

  String getName() {
    return name;
  }

  isAdmin() {
    return roles.contains('ADMIN');
  }

  isMember() {
    return roles.contains('MEMBER');
  }

  isTreasurer() {
    return roles.contains('TREASURER');
  }

  isPastor() {
    return roles.contains('PASTOR');
  }
}
