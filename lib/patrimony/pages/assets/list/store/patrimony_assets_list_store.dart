import 'package:flutter/material.dart';

import '../../../../models/patrimony_asset_enums.dart';
import '../../../../services/patrimony_service.dart';
import '../state/patrimony_assets_list_state.dart';

class PatrimonyAssetsListStore extends ChangeNotifier {
  final PatrimonyService service;
  PatrimonyAssetsListState state = PatrimonyAssetsListState.initial();

  PatrimonyAssetsListStore({PatrimonyService? service})
      : service = service ?? PatrimonyService();

  Future<void> loadAssets({int? page}) async {
    state = state.copyWith(loading: true, hasError: false);
    notifyListeners();

    try {
      final response = await service.fetchAssets(
        page: page ?? state.page,
        perPage: state.perPage,
        search: state.search.isEmpty ? null : state.search,
        status: state.status,
        category: state.category,
      );

      state = state.copyWith(
        loading: false,
        assets: response,
        page: page ?? state.page,
        hasError: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, hasError: true);
    }

    notifyListeners();
  }

  void setSearch(String value) {
    state = state.copyWith(search: value);
    notifyListeners();
  }

  Future<void> applySearch() async {
    state = state.copyWith(page: 1);
    await applyFilters();
  }

  void setStatusByLabel(String? label) {
    final apiValue = PatrimonyAssetStatusCollection.apiValueFromLabel(label);

    state = state.copyWith(
      status: apiValue,
      page: 1,
      clearStatus: label == null,
    );
    notifyListeners();
    applyFilters();
  }

  void setCategoryByLabel(String? label) {
    final apiValue = PatrimonyAssetCategoryCollection.apiValueFromLabel(label);
    state = state.copyWith(
      category: apiValue,
      page: 1,
      clearCategory: label == null,
    );
    notifyListeners();
    applyFilters();
  }

  void goToNextPage() {
    if (!state.assets.nextPag) {
      return;
    }

    final nextPage = state.page + 1;
    state = state.copyWith(page: nextPage);
    notifyListeners();
    loadAssets(page: nextPage);
  }

  void goToPreviousPage() {
    if (state.page <= 1) {
      return;
    }

    final prevPage = state.page - 1;
    state = state.copyWith(page: prevPage);
    notifyListeners();
    loadAssets(page: prevPage);
  }

  void changePerPage(int perPage) {
    state = state.copyWith(perPage: perPage, page: 1);
    notifyListeners();
    applyFilters();
  }

  void refresh() {
    loadAssets(page: state.page);
  }

  void clearFilters() {
    state = PatrimonyAssetsListState.initial().copyWith(perPage: state.perPage);
    notifyListeners();
    applyFilters();
  }

  Future<void> applyFilters() async {
    await loadAssets(page: 1);
  }

  String? get statusLabel {
    final selected = PatrimonyAssetStatus.values.firstWhere(
      (status) => status.apiValue == state.status,
      orElse: () => PatrimonyAssetStatus.active,
    );

    return state.status == null ? null : selected.label;
  }

  String? get categoryLabel {
    final selected = PatrimonyAssetCategory.values.firstWhere(
      (category) => category.apiValue == state.category,
      orElse: () => PatrimonyAssetCategory.other,
    );

    return state.category == null ? null : selected.label;
  }
}
