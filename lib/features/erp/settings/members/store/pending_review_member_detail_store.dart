import 'package:flutter/material.dart';

import '../services/pending_review_member_service.dart';
import '../state/pending_review_member_detail_state.dart';

class PendingReviewMemberDetailStore extends ChangeNotifier {
  final PendingReviewMemberService service;
  PendingReviewMemberDetailState state;

  PendingReviewMemberDetailStore({
    required String memberId,
    PendingReviewMemberService? service,
  }) : service = service ?? PendingReviewMemberService(),
       state = PendingReviewMemberDetailState.empty(memberId);

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);
    notifyListeners();

    try {
      final member = await service.getPendingMember(state.memberId);
      state = state.copyWith(member: member, loading: false, clearError: true);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<bool> approve() async {
    state = state.copyWith(saving: true, clearError: true);
    notifyListeners();

    try {
      await service.approve(state.memberId);
      state = state.copyWith(saving: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> reject() async {
    state = state.copyWith(saving: true, clearError: true);
    notifyListeners();

    try {
      await service.reject(state.memberId);
      state = state.copyWith(saving: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      notifyListeners();
      return false;
    }
  }
}
