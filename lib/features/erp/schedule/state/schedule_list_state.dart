import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';

class ScheduleListState {
  final List<ScheduleItemConfig> items;
  final bool loading;
  final ScheduleItemType? typeFilter;
  final ScheduleVisibility? visibilityFilter;
  final ScheduleItemStatus? statusFilter;
  final String searchQuery;

  const ScheduleListState({
    required this.items,
    required this.loading,
    this.typeFilter,
    this.visibilityFilter,
    this.statusFilter,
    required this.searchQuery,
  });

  factory ScheduleListState.initial() {
    return const ScheduleListState(
      items: [],
      loading: false,
      typeFilter: null,
      visibilityFilter: null,
      statusFilter: null,
      searchQuery: '',
    );
  }

  ScheduleListState copyWith({
    List<ScheduleItemConfig>? items,
    bool? loading,
    ScheduleItemType? typeFilter,
    ScheduleVisibility? visibilityFilter,
    ScheduleItemStatus? statusFilter,
    bool clearStatusFilter = false,
    String? searchQuery,
  }) {
    return ScheduleListState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      typeFilter: typeFilter ?? this.typeFilter,
      visibilityFilter: visibilityFilter ?? this.visibilityFilter,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<ScheduleItemConfig> get filteredItems {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final filtered =
        normalizedQuery.isEmpty
            ? List<ScheduleItemConfig>.from(items)
            : items.where((item) {
              return item.title.toLowerCase().contains(normalizedQuery);
            }).toList();

    filtered.sort((left, right) {
      final rankDiff =
          _statusRank(left.status).compareTo(_statusRank(right.status));
      if (rankDiff != 0) return rankDiff;
      return left.title.toLowerCase().compareTo(right.title.toLowerCase());
    });

    return filtered;
  }

  int _statusRank(ScheduleItemStatus status) {
    switch (status) {
      case ScheduleItemStatus.active:
        return 0;
      case ScheduleItemStatus.suspended:
        return 1;
      case ScheduleItemStatus.finalized:
        return 2;
    }
  }
}
