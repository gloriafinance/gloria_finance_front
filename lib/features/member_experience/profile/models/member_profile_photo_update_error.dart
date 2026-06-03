class MemberProfilePhotoUpdateError implements Exception {
  final String code;
  final String message;

  const MemberProfilePhotoUpdateError({
    required this.code,
    required this.message,
  });
}
