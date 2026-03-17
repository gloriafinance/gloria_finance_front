import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';

class MemberDevotionalDetailState {
  final bool isLoading;
  final bool isUpdatingReaction;
  final bool isSubmittingComment;
  final String? errorMessage;
  final String? viewerMemberId;
  final String? editingCommentId;
  final MemberDevotionalDetailModel? detail;
  final MemberDevotionalCommunityModel community;

  const MemberDevotionalDetailState({
    required this.isLoading,
    required this.isUpdatingReaction,
    required this.isSubmittingComment,
    required this.errorMessage,
    required this.viewerMemberId,
    required this.editingCommentId,
    required this.detail,
    required this.community,
  });

  factory MemberDevotionalDetailState.initial() {
    return MemberDevotionalDetailState(
      isLoading: true,
      isUpdatingReaction: false,
      isSubmittingComment: false,
      errorMessage: null,
      viewerMemberId: null,
      editingCommentId: null,
      detail: null,
      community: MemberDevotionalCommunityModel.empty(),
    );
  }

  MemberDevotionalDetailState copyWith({
    bool? isLoading,
    bool? isUpdatingReaction,
    bool? isSubmittingComment,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? viewerMemberId,
    bool clearViewerMemberId = false,
    String? editingCommentId,
    bool clearEditingCommentId = false,
    MemberDevotionalDetailModel? detail,
    bool clearDetail = false,
    MemberDevotionalCommunityModel? community,
  }) {
    return MemberDevotionalDetailState(
      isLoading: isLoading ?? this.isLoading,
      isUpdatingReaction: isUpdatingReaction ?? this.isUpdatingReaction,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      viewerMemberId:
          clearViewerMemberId ? null : (viewerMemberId ?? this.viewerMemberId),
      editingCommentId:
          clearEditingCommentId
              ? null
              : (editingCommentId ?? this.editingCommentId),
      detail: clearDetail ? null : (detail ?? this.detail),
      community: community ?? this.community,
    );
  }

  bool get isEditingComment => editingCommentId != null;
}
