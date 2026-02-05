import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/cost_center_service.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:flutter/material.dart';

import '../state/cost_center_form_state.dart';

class CostCenterFormStore extends ChangeNotifier {
  final CostCenterService service;
  CostCenterFormState state;

  CostCenterFormStore({CostCenterModel? costCenter})
    : service = CostCenterService(),
      state =
          costCenter != null
              ? CostCenterFormState.fromModel(costCenter)
              : CostCenterFormState.init() {}

  void setCostCenterId(String value) {
    state = state.copyWith(costCenterId: value.trim());
    notifyListeners();
  }

  void setName(String value) {
    state = state.copyWith(name: value.trim());
    notifyListeners();
  }

  void setDescription(String value) {
    state = state.copyWith(description: value.trim());
    notifyListeners();
  }

  void setCategory(CostCenterCategory category) {
    state = state.copyWith(category: category);
    notifyListeners();
  }

  void setResponsibleMember(MemberModel member, String displayName) {
    print('Setting responsible member: ${member.memberId} - $displayName');
    state = state.copyWith(
      responsibleMemberId: member.memberId,
      responsibleMemberName: displayName,
    );
    notifyListeners();
  }

  void setActive(bool value) {
    state = state.copyWith(active: value);
    notifyListeners();
  }

  Future<bool> submit(bool isEdit) async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      final payload = state.toPayload(session.churchId);

      await service.saveCostCenter(payload, isEdit);

      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      debugPrint('ERROR saveCostCenter: $e');
      return false;
    }
  }
}
