class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String createdAt;
  final bool isActive;
  final String userId;
  final String churchId;
  final List<Profile> profiles;
  String? memberId;

  AuthSessionModel(
      {required this.churchId,
      required this.token,
      required this.name,
      required this.email,
      required this.createdAt,
      required this.isActive,
      required this.userId,
      required this.profiles,
      this.memberId});

  factory AuthSessionModel.empty() {
    return AuthSessionModel(
      token: "",
      name: "",
      email: "",
      createdAt: "",
      isActive: false,
      userId: "",
      churchId: '',
      profiles: [],
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
      List<Profile>? profiles,
      String? memberId}) {
    return AuthSessionModel(
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      churchId: churchId ?? this.churchId,
      profiles: profiles ?? this.profiles,
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
      profiles: (json['profiles'] as List<dynamic>)
          .map((profile) => Profile.fromJson(profile))
          .toList(),
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
      'profiles': profiles.map((profile) => profile.toJson()).toList(),
      'memberId': memberId,
    };
  }

  bool isSessionStarted() {
    return token != "";
  }

  String getName() {
    return name;
  }

  isSuperUser() {
    return profiles
        .where((element) => element.profileType == 'SUPERUSER')
        .isNotEmpty;
  }

  isAdmin() {
    return profiles
        .where((element) => element.profileType == 'ADMIN')
        .isNotEmpty;
  }

  isMember() {
    return profiles
        .where((element) => element.profileType == 'MEMBER')
        .isNotEmpty;
  }

  isTreasurer() {
    return profiles
        .where((element) => element.profileType == 'TREASURER')
        .isNotEmpty;
  }
}

class Profile {
  final String profileType;
  final List<String> actions;

  Profile({
    required this.profileType,
    required this.actions,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileType: json['profileType'],
      actions:
          json['actions'] != null ? List<String>.from(json['actions']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileType': profileType,
      'actions': actions,
    };
  }
}
