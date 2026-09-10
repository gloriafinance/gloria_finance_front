class PublicChurchInfo {
  final String churchId;
  final String churchName;
  final String country;

  PublicChurchInfo({
    required this.churchId,
    required this.churchName,
    required this.country,
  });

  factory PublicChurchInfo.fromJson(Map<String, dynamic> json) {
    return PublicChurchInfo(
      churchId: json['churchId'] as String,
      churchName: json['churchName'] as String,
      country: json['country'] as String,
    );
  }
}

class MemberRegistrationResponse {
  final String message;

  MemberRegistrationResponse({required this.message});

  factory MemberRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return MemberRegistrationResponse(message: json['message'] as String);
  }
}
