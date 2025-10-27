import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../models/patrimony_asset_enums.dart';
import '../../../../models/patrimony_asset_model.dart';
import '../../../../models/patrimony_inventory_import_result.dart';
import '../../../../services/patrimony_service.dart';
import '../state/patrimony_assets_list_state.dart';

class PatrimonyAssetsListStore extends ChangeNotifier {
  final PatrimonyService service;
  PatrimonyAssetsListState state = PatrimonyAssetsListState.initial();

  PatrimonyAssetsListStore({PatrimonyService? service})
      : service = service ?? PatrimonyService();

  bool get downloadingSummary => state.downloadingSummary;

  bool get downloadingChecklist => state.downloadingChecklist;

  bool get importingInventory => state.importingInventory;

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

  void updateAssetEntry(PatrimonyAssetModel updated) {
    final updatedResults = state.assets.results
        .map((asset) => asset.assetId == updated.assetId ? updated : asset)
        .toList();

    state = state.copyWith(
      assets: state.assets.copyWith(results: updatedResults),
    );
    notifyListeners();
  }

  void clearFilters() {
    state = PatrimonyAssetsListState.initial().copyWith(perPage: state.perPage);
    notifyListeners();
    applyFilters();
  }

  Future<void> applyFilters() async {
    await loadAssets(page: 1);
  }

  Future<bool> downloadInventorySummary(String format) async {
    if (state.downloadingSummary) {
      return false;
    }

    state = state.copyWith(downloadingSummary: true);
    notifyListeners();

    try {
      final success = await service.downloadInventorySummary(
        format: format,
        status: state.status,
        category: state.category,
      );
      return success;
    } catch (e) {
      return false;
    } finally {
      state = state.copyWith(downloadingSummary: false);
      notifyListeners();
    }
  }

  Future<bool> downloadPhysicalChecklist() async {
    if (state.downloadingChecklist) {
      return false;
    }

    state = state.copyWith(downloadingChecklist: true);
    notifyListeners();

    try {
      final success = await service.downloadPhysicalChecklist(
        status: state.status,
        category: state.category,
      );
      return success;
    } catch (e) {
      return false;
    } finally {
      state = state.copyWith(downloadingChecklist: false);
      notifyListeners();
    }
  }

  Future<PatrimonyInventoryImportResult?> importInventoryChecklist(
    MultipartFile file,
  ) async {
    if (state.importingInventory) {
      return null;
    }

    state = state.copyWith(importingInventory: true);
    notifyListeners();

    PatrimonyInventoryImportResult? result;

    try {
      result = await service.importInventoryChecklist(file: file);
    } catch (e) {
      result = null;
    } finally {
      state = state.copyWith(importingInventory: false);
      notifyListeners();
    }

    if (result != null) {
      // Refresh the list to reflect the updates performed by the import.
      // ignore: unawaited_futures
      unawaited(loadAssets(page: state.page));
    }

    return result;
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
