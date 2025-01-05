import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:flutter/cupertino.dart';

import '../models/contribution_model.dart';
import '../services/contribution_service.dart';
import '../states/contributions_pagination_state.dart';

class ContributionPaginationStore extends ChangeNotifier {
  final ContributionService service = ContributionService();
  ContributionPaginationState state = ContributionPaginationState.empty();

  void setStatus(String status) {
    final v =
        ContributionStatus.values.firstWhere((e) => e.friendlyName == status);
    state = state.copyWith(status: v.toString().split('.').last);
    notifyListeners();
  }

  void setStartDate(String startDate) {
    state = state.copyWith(startDate: startDate);
    notifyListeners();
  }

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage);
    notifyListeners();
    searchContributions();
  }

  void nextPage() {
    state = state.copyWith(page: state.filter.page + 1);
    notifyListeners();

    searchContributions();
  }

  void prevPage() {
    if (state.filter.page > 1) {
      state = state.copyWith(page: state.filter.page - 1);
      notifyListeners();

      searchContributions();
    }
  }

  void apply() {
    notifyListeners();
    searchContributions();
  }

  updateStatusContributionModel(String contributionId, String status) {
    final List<ContributionModel> contributions =
        state.paginate.results.map<ContributionModel>((e) {
      if (e.contributionId == contributionId) {
        final v = ContributionStatus.values
            .firstWhere((e) => e.friendlyName == status);
        return e.copyWith(status: v.toString().split('.').last);
      }
      return e;
    }).toList();

    state = state.copyWith(
        paginate: state.paginate.copyWith(results: contributions));

    notifyListeners();
  }

  Future<void> searchContributions() async {
    try {
      final session = await AuthStore().restore();
      service.tokenAPI = session.token;

      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final paginate = await service.searchContributions(state.filter);

      state = state.copyWith(makeRequest: false, paginate: paginate);
      notifyListeners();
    } catch (e) {
      print("Error al buscar contribuciones: $e");

      // Manejo de errores
      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
