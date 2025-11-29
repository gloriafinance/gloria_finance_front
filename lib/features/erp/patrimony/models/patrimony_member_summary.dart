class PatrimonyMemberSummary {
  final String memberId;
  final String name;
  final String? email;
  final String? phone;

  const PatrimonyMemberSummary({
    required this.memberId,
    required this.name,
    this.email,
    this.phone,
  });

  factory PatrimonyMemberSummary.fromMap(Map<String, dynamic> map) {
    return PatrimonyMemberSummary(
      memberId: map['memberId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }
}
