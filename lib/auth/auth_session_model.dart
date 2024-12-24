class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String createdAt;
  final bool isActive;
  final String userId;
  final bool isSuperuser;

  AuthSessionModel({
    required this.token,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isActive,
    required this.userId,
    required this.isSuperuser,
  });

  factory AuthSessionModel.init() {
    return AuthSessionModel(
      token: "",
      name: "",
      email: "",
      createdAt: "",
      isActive: false,
      userId: "",
      isSuperuser: false,
    );
  }

  AuthSessionModel copyWith(
      {String? token,
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
    );
  }

  static fromJson(Map<String, dynamic> json) {
    print("json:");
    print(json['email']);

    return AuthSessionModel(
      token: json['token'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      userId: json['userId'],
      isSuperuser: json['isSuperuser'],
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
    };
  }

  bool isSessionStarted() {
    return token != "";
  }

  String getName() {
    return name;
  }
}
