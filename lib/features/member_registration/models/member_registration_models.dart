class PublicChurchInfo {
  final String churchId;
  final String churchName;

  PublicChurchInfo({required this.churchId, required this.churchName});

  factory PublicChurchInfo.fromJson(Map<String, dynamic> json) {
    return PublicChurchInfo(
      churchId: json['churchId'] as String,
      churchName: json['churchName'] as String,
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
