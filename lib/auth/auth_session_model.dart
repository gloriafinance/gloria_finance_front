class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String createdAt;
  final bool isActive;
  final String userId;
  final String churchId;
  String? memberId;

  AuthSessionModel({
    required this.churchId,
    required this.token,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isActive,
    required this.userId,
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
    );
  }

  static AuthSessionModel fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
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
    return true;
  }

  isMember() {
    return true;
  }

  isTreasurer() {
    return true;
  }

  isSuperUser() {
    return true;
  }
}

class Profile {
  final String profileType;
  final List<String> actions;

  Profile({required this.profileType, required this.actions});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileType: json['profileType'],
      actions:
          json['actions'] != null ? List<String>.from(json['actions']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'profileType': profileType, 'actions': actions};
  }
}
