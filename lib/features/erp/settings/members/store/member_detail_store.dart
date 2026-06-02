import 'package:flutter/material.dart';

import '../models/member_model.dart';
import '../services/member_detail_service.dart';
import '../state/member_detail_state.dart';

class MemberDetailStore extends ChangeNotifier {
  final MemberDetailService service;
  MemberDetailState state;

  MemberDetailStore({
    required String memberId,
    MemberModel? initialMember,
    MemberDetailService? service,
  }) : service = service ?? MemberDetailService(),
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
}
