import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/features/erp/schedule/models/schedule_models.dart';
import 'package:church_finance_bk/features/erp/schedule/store/schedule_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleFilters extends StatelessWidget {
  const ScheduleFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Consumer<ScheduleListStore>(
      builder: (context, store, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _searchInput(store, l10n)),
                const SizedBox(width: 16),
                Expanded(child: _typeDropdown(store, l10n)),
                const SizedBox(width: 16),
                Expanded(child: _visibilityDropdown(store, l10n)),
                const SizedBox(width: 16),
                Expanded(child: _statusDropdown(store, l10n)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _clearButton(store, l10n),
                const SizedBox(width: 12),
                _applyButton(store, l10n),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _searchInput(ScheduleListStore store, l10n) {
    return Input(
      label: l10n.schedule_filters_search,
      initialValue: store.state.searchQuery,
      onChanged: store.setSearchQuery,
      icon: Icons.search,
    );
  }

  Widget _typeDropdown(ScheduleListStore store, l10n) {
    return Dropdown(
      label: l10n.schedule_filters_type,
      initialValue:
          store.state.typeFilter != null
              ? _getTypeLabel(store.state.typeFilter!, l10n)
              : null,
      items: [
        for (final type in ScheduleItemType.values) _getTypeLabel(type, l10n),
      ],
      onChanged: (selectedLabel) {
        final type = ScheduleItemType.values.firstWhere(
          (t) => _getTypeLabel(t, l10n) == selectedLabel,
        );
        store.setTypeFilter(type);
      },
    );
  }

  Widget _visibilityDropdown(ScheduleListStore store, l10n) {
    return Dropdown(
      label: l10n.schedule_filters_visibility,
      initialValue:
          store.state.visibilityFilter != null
              ? _getVisibilityLabel(store.state.visibilityFilter!, l10n)
              : null,
      items: [
        for (final vis in ScheduleVisibility.values)
          _getVisibilityLabel(vis, l10n),
      ],
      onChanged: (selectedLabel) {
        final vis = ScheduleVisibility.values.firstWhere(
          (v) => _getVisibilityLabel(v, l10n) == selectedLabel,
        );
        store.setVisibilityFilter(vis);
      },
    );
  }

  Widget _statusDropdown(ScheduleListStore store, l10n) {
    return Dropdown(
      label: l10n.schedule_filters_status,
      initialValue: _getStatusLabel(store.state.isActiveFilter, l10n),
      items: [
        l10n.schedule_status_all,
        l10n.schedule_status_active,
        l10n.schedule_status_inactive,
      ],
      onChanged: (value) {
        if (value == l10n.schedule_status_active) {
          store.setIsActiveFilter(true);
        } else if (value == l10n.schedule_status_inactive) {
          store.setIsActiveFilter(false);
        } else {
          store.setIsActiveFilter(null);
        }
      },
    );
  }

  Widget _clearButton(ScheduleListStore store, l10n) {
    return ButtonActionTable(
      icon: Icons.clear,
      color: AppColors.mustard,
      text: l10n.common_clear_filters,
      onPressed: store.clearFilters,
    );
  }

  Widget _applyButton(ScheduleListStore store, l10n) {
    return ButtonActionTable(
      color: AppColors.blue,
      text: l10n.common_apply_filters,
      icon: Icons.search,
      onPressed: () => store.fetchScheduleItems(),
    );
  }

  String _getStatusLabel(bool? isActive, l10n) {
    if (isActive == null) return l10n.schedule_status_all;
    return isActive
        ? l10n.schedule_status_active
        : l10n.schedule_status_inactive;
  }

  String _getTypeLabel(ScheduleItemType type, l10n) {
    switch (type) {
      case ScheduleItemType.service:
        return l10n.schedule_type_service;
      case ScheduleItemType.cell:
        return l10n.schedule_type_cell;
      case ScheduleItemType.ministryMeeting:
        return l10n.schedule_type_ministry_meeting;
      case ScheduleItemType.regularEvent:
        return l10n.schedule_type_regular_event;
      case ScheduleItemType.other:
        return l10n.schedule_type_other;
    }
  }

  String _getVisibilityLabel(ScheduleVisibility visibility, l10n) {
    switch (visibility) {
      case ScheduleVisibility.public:
        return l10n.schedule_visibility_public;
      case ScheduleVisibility.internalLeaders:
        return l10n.schedule_visibility_internal_leaders;
    }
  }
}
