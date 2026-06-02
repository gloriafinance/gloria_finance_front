import '../models/member_model.dart';

class PendingReviewMemberDetailState {
  final String memberId;
  final MemberModel? member;
  final bool loading;
  final bool saving;
  final String? error;

  PendingReviewMemberDetailState({
    required this.memberId,
    required this.member,
    required this.loading,
    required this.saving,
    required this.error,
  });

  factory PendingReviewMemberDetailState.empty(String memberId) {
    return PendingReviewMemberDetailState(
      memberId: memberId,
      member: null,
      loading: false,
      saving: false,
      error: null,
    );
  }

  PendingReviewMemberDetailState copyWith({
    MemberModel? member,
    bool? loading,
    bool? saving,
    String? error,
    bool clearError = false,
  }) {
    return PendingReviewMemberDetailState(
      memberId: memberId,
      member: member ?? this.member,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: clearError ? null : error ?? this.error,
    );
  }
}
