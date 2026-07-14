import '../models/member_model.dart';

class MemberDetailState {
  final String memberId;
  final MemberModel? member;
  final bool loading;
  final bool deleting;
  final String? error;
  final String? deleteError;

  MemberDetailState({
    required this.memberId,
    required this.member,
    required this.loading,
    required this.deleting,
    required this.error,
    required this.deleteError,
  });

  factory MemberDetailState.empty(String memberId, {MemberModel? member}) {
    return MemberDetailState(
      memberId: memberId,
      member: member,
      loading: false,
      deleting: false,
      error: null,
      deleteError: null,
    );
  }

  MemberDetailState copyWith({
    MemberModel? member,
    bool? loading,
    bool? deleting,
    String? error,
    String? deleteError,
    bool clearError = false,
    bool clearDeleteError = false,
  }) {
    return MemberDetailState(
      memberId: memberId,
      member: member ?? this.member,
      loading: loading ?? this.loading,
      deleting: deleting ?? this.deleting,
      error: clearError ? null : error ?? this.error,
      deleteError: clearDeleteError ? null : deleteError ?? this.deleteError,
    );
  }
}
