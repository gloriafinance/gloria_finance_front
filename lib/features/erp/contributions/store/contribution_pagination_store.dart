import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../contribution_service.dart';
import '../models/contribution_model.dart';
import '../state/contributions_pagination_state.dart';

class ContributionPaginationStore extends ChangeNotifier {
  final ContributionService service = ContributionService();
  ContributionPaginationState state = ContributionPaginationState.empty();

  void setStatus(ContributionStatus status) {
    state = state.copyWith(status: status.toString().split('.').last);
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

  _updateStatusContributionModel(
    String contributionId,
    ContributionStatus status,
  ) {
    final List<ContributionModel> contributions =
        state.paginate.results.map<ContributionModel>((ContributionModel e) {
          if (e.contributionId == contributionId) {
            return e.copyWith(status: status.toString().split('.').last);
          }
          return e;
        }).toList();

    state = state.copyWith(
      paginate: state.paginate.copyWith(results: contributions),
    );

    notifyListeners();
  }

  Future<void> updateStatusContribution(
    String contributionId,
    ContributionStatus status,
  ) async {
    try {
      await service.updateContributionStatus(contributionId, status);
      _updateStatusContributionModel(contributionId, status);
    } catch (e) {
      Toast.showMessage(
        "Erro ao atualizar o status da contribuição",
        ToastType.error,
      );
    }
  }

  Future<void> searchContributions() async {
    try {
      final session = await AuthPersistence().restore();

      state = state.copyWith(makeRequest: true);

      //TODO si se agrega un filtro por miembro, esta condicion debe cambiar.
      if (session.isMember()) {
        state = state.copyWith(memberId: session.memberId);
      }

      notifyListeners();

      final paginate = await service.listContributions(state.filter);

      state = state.copyWith(makeRequest: false, paginate: paginate);
      notifyListeners();
    } catch (e) {
      print("Error al buscar contribuciones: $e");

      state = state.copyWith(makeRequest: false);
      notifyListeners();
    }
  }
}
