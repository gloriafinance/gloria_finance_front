import '../models/cost_center_model.dart';

class CostCenterListState {
  final bool makeRequest;
  final List<CostCenterModel> costCenters;

  CostCenterListState({required this.makeRequest, required this.costCenters});

  factory CostCenterListState.empty() {
    return CostCenterListState(makeRequest: false, costCenters: []);
  }

  CostCenterListState copyWith(
      {bool? makeRequest, List<CostCenterModel>? costCenters}) {
    return CostCenterListState(
      makeRequest: makeRequest ?? this.makeRequest,
      costCenters: costCenters ?? this.costCenters,
    );
  }

  bool get isLoading => makeRequest;
}
