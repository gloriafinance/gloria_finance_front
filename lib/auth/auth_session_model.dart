class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String createdAt;
  final bool isActive;
  final String userId;
  final bool isSuperuser;
  final String churchId;

  AuthSessionModel({
    required this.churchId,
    required this.token,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isActive,
    required this.userId,
    required this.isSuperuser,
  });

  factory AuthSessionModel.empty() {
    return AuthSessionModel(
      token: "",
      name: "",
      email: "",
      createdAt: "",
      isActive: false,
      userId: "",
      isSuperuser: false,
      churchId: '',
    );
  }

  AuthSessionModel copyWith(
      {String? token,
      String? churchId,
      String? name,
      String? email,
      String? createdAt,
      bool? isActive,
      String? userId,
      bool? isSuperuser}) {
    return AuthSessionModel(
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      churchId: '',
    );
  }

  static fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: json['token'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      userId: json['userId'],
      isSuperuser: json['isSuperuser'],
      churchId: json['churchId'],
    );
  }

  toJson() {
    return {
      'token': token,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'isActive': isActive,
      'userId': userId,
      'isSuperuser': isSuperuser,
      'churchId': churchId,
    };
  }

  bool isSessionStarted() {
    return token != "";
  }

  String getName() {
    return name;
  }
}
