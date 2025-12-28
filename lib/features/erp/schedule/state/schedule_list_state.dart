import 'package:church_finance_bk/features/erp/schedule/models/schedule_models.dart';

class ScheduleListState {
  final List<ScheduleItemConfig> items;
  final bool loading;
  final ScheduleItemType? typeFilter;
  final ScheduleVisibility? visibilityFilter;
  final bool? isActiveFilter;
  final String searchQuery;

  const ScheduleListState({
    required this.items,
    required this.loading,
    this.typeFilter,
    this.visibilityFilter,
    this.isActiveFilter,
    required this.searchQuery,
  });

  factory ScheduleListState.initial() {
    return const ScheduleListState(
      items: [],
      loading: false,
      typeFilter: null,
      visibilityFilter: null,
      isActiveFilter: null, // Por defecto mostrar todos
      searchQuery: '',
    );
  }

  ScheduleListState copyWith({
    List<ScheduleItemConfig>? items,
    bool? loading,
    ScheduleItemType? typeFilter,
    ScheduleVisibility? visibilityFilter,
    bool? isActiveFilter,
    String? searchQuery,
  }) {
    return ScheduleListState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      typeFilter: typeFilter ?? this.typeFilter,
      visibilityFilter: visibilityFilter ?? this.visibilityFilter,
      isActiveFilter: isActiveFilter ?? this.isActiveFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Items filtrados por búsqueda
  List<ScheduleItemConfig> get filteredItems {
    if (searchQuery.isEmpty) return items;

    return items.where((item) {
      return item.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}
