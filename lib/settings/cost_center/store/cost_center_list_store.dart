import 'package:flutter/material.dart';

import '../cost_center_service.dart';
import '../state/cost_center_list_state.dart';

class CostCenterListStore extends ChangeNotifier {
  var state = CostCenterListState.empty();
  var service = CostCenterService();

  searchCostCenters() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final costCenters = await service.searchCostCenters();
      state = state.copyWith(makeRequest: false, costCenters: costCenters);

      notifyListeners();
    } catch (e) {
      state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
