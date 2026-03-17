import 'package:flutter/material.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/service/member_devotional_service.dart';
import 'package:gloria_finance/features/member_experience/devotional/state/member_devotional_detail_state.dart';

class MemberDevotionalDetailStore extends ChangeNotifier {
  final MemberDevotionalService _service;
  final String devotionalId;

  MemberDevotionalDetailState state = MemberDevotionalDetailState.initial();

  MemberDevotionalDetailStore({
    required this.devotionalId,
    MemberDevotionalService? service,
  }) : _service = service ?? MemberDevotionalService();

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    notifyListeners();

    try {
      final sessionFuture = AuthPersistence().restore();
      final detailFuture = _service.fetchDevotionalDetail(devotionalId);
      final communityFuture = _service.fetchDevotionalCommunity(devotionalId);

      final detail = await detailFuture;
      final session = await sessionFuture;
      MemberDevotionalCommunityModel community;

      try {
        community = await communityFuture;
      } catch (_) {
        community = MemberDevotionalCommunityModel.empty(detail.devotionalId);
      }

      state = state.copyWith(
        detail: detail,
        community: community,
        viewerMemberId: session.memberId,
        isLoading: false,
      );
      notifyListeners();
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString(), isLoading: false);
      notifyListeners();
    }
  }

  Future<void> toggleReaction(String reactionId) async {
    if (state.isUpdatingReaction) return;

    state = state.copyWith(isUpdatingReaction: true);
    notifyListeners();

    try {
      final community =
          state.community.viewerReactionType == reactionId
              ? await _service.clearReaction(devotionalId)
              : await _service.setReaction(devotionalId, reactionId);

      state = state.copyWith(community: community, isUpdatingReaction: false);
      notifyListeners();
    } catch (error) {
      state = state.copyWith(isUpdatingReaction: false);
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> submitComment(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty || state.isSubmittingComment) return false;

    state = state.copyWith(isSubmittingComment: true);
    notifyListeners();

    try {
      final community =
          state.isEditingComment
              ? await _service.updateComment(
                devotionalId,
                state.editingCommentId!,
                trimmedMessage,
              )
              : await _service.createComment(devotionalId, trimmedMessage);

      state = state.copyWith(
        community: community,
        isSubmittingComment: false,
        clearEditingCommentId: true,
      );
      notifyListeners();
      return true;
    } catch (error) {
      state = state.copyWith(isSubmittingComment: false);
      notifyListeners();
      rethrow;
    }
  }

  void beginEditingComment(MemberDevotionalCommentModel comment) {
    state = state.copyWith(editingCommentId: comment.commentId);
    notifyListeners();
  }

  void cancelEditingComment() {
    if (!state.isEditingComment) return;
    state = state.copyWith(clearEditingCommentId: true);
    notifyListeners();
  }

  bool canEditComment(MemberDevotionalCommentModel comment) {
    final viewerMemberId = state.viewerMemberId;
    return viewerMemberId != null &&
        viewerMemberId.isNotEmpty &&
        comment.memberId == viewerMemberId;
  }
}
