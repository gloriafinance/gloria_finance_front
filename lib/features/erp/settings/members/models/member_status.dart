enum MemberStatus {
  pendingReview('PENDING_REVIEW'),
  approved('APPROVED'),
  inactive('INACTIVE');

  final String value;
  const MemberStatus(this.value);

  static MemberStatus fromString(String? raw) {
    if (raw == null || raw.isEmpty) {
      throw ArgumentError('MemberStatus is required');
    }
    for (final status in values) {
      if (status.value == raw) {
        return status;
      }
    }
    throw ArgumentError('Invalid MemberStatus: $raw');
  }

  bool get isApproved => this == approved;
  bool get isInactive => this == inactive;
  bool get isPendingReview => this == pendingReview;
}
