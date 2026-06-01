class MemberRegistrationLinkModel {
  final String churchId;
  final String churchName;
  final String token;
  final String registrationPath;

  MemberRegistrationLinkModel({
    required this.churchId,
    required this.churchName,
    required this.token,
    required this.registrationPath,
  });

  factory MemberRegistrationLinkModel.fromJson(Map<String, dynamic> json) {
    final churchId = json['churchId'] as String?;
    final churchName = json['churchName'] as String?;
    final token = json['token'] as String?;
    final registrationPath = json['registrationPath'] as String?;

    if (churchId == null ||
        churchName == null ||
        token == null ||
        registrationPath == null) {
      throw FormatException(
        'Invalid MemberRegistrationLinkModel payload: $json',
      );
    }

    return MemberRegistrationLinkModel(
      churchId: churchId,
      churchName: churchName,
      token: token,
      registrationPath: registrationPath,
    );
  }

  String get registrationUrl =>
      'https://gloriafinance.com.br$registrationPath';
}
