class MemberProfilePhotoUpdateResult {
  final String profilePhoto;
  final String profilePhotoUrl;

  const MemberProfilePhotoUpdateResult({
    required this.profilePhoto,
    required this.profilePhotoUrl,
  });

  factory MemberProfilePhotoUpdateResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return MemberProfilePhotoUpdateResult(
      profilePhoto: json['profilePhoto']?.toString() ?? '',
      profilePhotoUrl: json['profilePhotoUrl']?.toString() ?? '',
    );
  }
}
