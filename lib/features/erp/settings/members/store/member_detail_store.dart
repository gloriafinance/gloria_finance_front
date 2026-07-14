import 'package:flutter/material.dart';

import '../models/member_model.dart';
import '../services/member_deletion_service.dart';
import '../services/member_detail_service.dart';
import '../state/member_detail_state.dart';

class MemberDetailStore extends ChangeNotifier {
  final MemberDetailService service;
  final MemberDeletionService deletionService;
  MemberDetailState state;

  MemberDetailStore({
    required String memberId,
    MemberModel? initialMember,
    MemberDetailService? service,
    MemberDeletionService? deletionService,
  }) : service = service ?? MemberDetailService(),
       deletionService = deletionService ?? MemberDeletionService(),
       state = MemberDetailState.empty(memberId, member: initialMember);

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);
    notifyListeners();

    try {
      final member = await service.getMember(state.memberId);
      state = state.copyWith(member: member, loading: false, clearError: true);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<bool> delete() async {
    if (state.deleting) return false;

    state = state.copyWith(deleting: true, clearError: true);
    notifyListeners();

    try {
      await deletionService.deleteMember(state.memberId);
      state = state.copyWith(deleting: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(deleting: false, error: e.toString());
      notifyListeners();
      return false;
    }
  }
}
