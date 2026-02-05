import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/service/schedule_service.dart';
import 'package:gloria_finance/features/erp/schedule/state/schedule_list_state.dart';
import 'package:flutter/material.dart';

class ScheduleListStore extends ChangeNotifier {
  final ScheduleService service = ScheduleService();
  ScheduleListState state = ScheduleListState.initial();

  Future<void> fetchScheduleItems({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(loading: true);
      notifyListeners();
    }

    try {
      final items = await service.getScheduleItems(
        type: state.typeFilter,
        visibility: state.visibilityFilter,
        isActive: state.isActiveFilter,
      );
      state = state.copyWith(items: items, loading: false);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false);
      notifyListeners();
      rethrow;
    }
  }

  Future<ScheduleItemConfig> getItemById(String scheduleItemId) async {
    return await service.getScheduleItemById(scheduleItemId);
  }

  Future<void> deleteItem(String scheduleItemId) async {
    try {
      await service.deleteScheduleItem(scheduleItemId);
      await fetchScheduleItems(silent: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reactivateItem(String scheduleItemId) async {
    try {
      await service.reactivateScheduleItem(scheduleItemId);
      await fetchScheduleItems(silent: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<ScheduleItemConfig> duplicateItem(ScheduleItemPayload payload) async {
    try {
      final newItem = await service.createScheduleItem(payload);
      await fetchScheduleItems(silent: true);
      return newItem;
    } catch (e) {
      rethrow;
    }
  }

  void setTypeFilter(ScheduleItemType? value) {
    state = state.copyWith(typeFilter: value);
    notifyListeners();
  }

  void setVisibilityFilter(ScheduleVisibility? value) {
    state = state.copyWith(visibilityFilter: value);
    notifyListeners();
  }

  void setIsActiveFilter(bool? value) {
    state = state.copyWith(isActiveFilter: value);
    notifyListeners();
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
    notifyListeners();
  }

  void clearFilters() {
    state = ScheduleListState.initial();
    notifyListeners();
  }
}
