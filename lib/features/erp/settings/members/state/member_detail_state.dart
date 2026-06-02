import '../models/member_model.dart';

class MemberDetailState {
  final String memberId;
  final MemberModel? member;
  final bool loading;
  final String? error;

  MemberDetailState({
    required this.memberId,
    required this.member,
    required this.loading,
    required this.error,
  });

  factory MemberDetailState.empty(String memberId, {MemberModel? member}) {
    return MemberDetailState(
      memberId: memberId,
      member: member,
      loading: false,
      error: null,
    );
  }

  MemberDetailState copyWith({
    MemberModel? member,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return MemberDetailState(
      memberId: memberId,
      member: member ?? this.member,
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
    );
  }
}
