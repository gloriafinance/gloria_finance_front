class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String phone;
  final String churchId;
  final String churchName;
  final bool isTreasurer;
  final bool isMinister;

  AuthSessionModel({
    required this.token,
    required this.name,
    required this.email,
    required this.phone,
    required this.isTreasurer,
    required this.isMinister,
    required this.churchId,
    required this.churchName,
  });

  factory AuthSessionModel.init() {
    return AuthSessionModel(
      token: "",
      name: "",
      email: "",
      phone: "",
      isTreasurer: false,
      isMinister: false,
      churchId: "",
      churchName: "",
    );
  }

  AuthSessionModel copyWith(
      {String? token,
      String? name,
      String? email,
      bool? isTreasurer,
      bool? isMinister,
      String? church}) {
    return AuthSessionModel(
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? phone,
      isTreasurer: isTreasurer ?? this.isTreasurer,
      isMinister: isMinister ?? this.isMinister,
      churchId: church ?? churchId,
      churchName: church ?? churchName,
    );
  }

  static fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
        token: json['token'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        isTreasurer: json['isTreasurer'],
        isMinister: json['isMinister'],
        churchId: json['church']['churchId'],
        churchName: json['church']['churchName']
    );

  }

  bool isSessionStarted() {
    return token != "";
  }

  String getName() {
    return name;
  }
}
