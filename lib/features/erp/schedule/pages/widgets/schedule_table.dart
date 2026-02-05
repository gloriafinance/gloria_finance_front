import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/confirmation_dialog.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/store/schedule_list_store.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'duplicate_schedule_modal.dart';
import 'schedule_detail_modal.dart';

class ScheduleTable extends StatelessWidget {
  const ScheduleTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleListStore>(
      builder: (context, store, _) {
        final state = store.state;
        final l10n = context.l10n;

        if (state.loading) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: const CircularProgressIndicator(),
          );
        }

        if (state.filteredItems.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(l10n.schedule_table_empty, textAlign: TextAlign.center),
          );
        }

        return SingleChildScrollView(
          child: CustomTable(
            headers: [
              l10n.schedule_table_header_title,
              l10n.schedule_table_header_type,
              l10n.schedule_table_header_day,
              l10n.schedule_table_header_time,
              l10n.schedule_table_header_location,
              l10n.schedule_table_header_director,
              l10n.common_status,
            ],
            data: FactoryDataTable(
              data: state.filteredItems,
              dataBuilder:
                  (item) =>
                      _buildRow(context, item as ScheduleItemConfig, l10n),
            ),
            actionBuilders: [
              (item) => _buildViewAction(context, item),
              (item) => _buildEditAction(context, item),
              (item) => _buildDuplicateAction(context, item),
              (item) => _buildToggleActiveAction(context, item),
            ],
            paginate: null, // Sin paginación por ahora
          ),
        );
      },
    );
  }

  List<dynamic> _buildRow(
    BuildContext context,
    ScheduleItemConfig item,
    AppLocalizations l10n,
  ) {
    return [
      item.title,
      _getTypeLabel(item.type, l10n),
      _getDayLabel(item.recurrencePattern.dayOfWeek, l10n),
      item.recurrencePattern.time,
      item.location.name,
      item.director,
      _statusTag(item, l10n),
    ];
  }

  Widget _statusTag(ScheduleItemConfig item, AppLocalizations l10n) {
    final color = item.isActive ? AppColors.green : AppColors.grey;
    final label =
        item.isActive
            ? l10n.schedule_status_active
            : l10n.schedule_status_inactive;
    return SizedBox(width: 100, child: tagStatus(color, label));
  }

  String _getTypeLabel(ScheduleItemType type, AppLocalizations l10n) {
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

  String _getDayLabel(DayOfWeek day, AppLocalizations l10n) {
    switch (day) {
      case DayOfWeek.sunday:
        return l10n.schedule_day_sunday;
      case DayOfWeek.monday:
        return l10n.schedule_day_monday;
      case DayOfWeek.tuesday:
        return l10n.schedule_day_tuesday;
      case DayOfWeek.wednesday:
        return l10n.schedule_day_wednesday;
      case DayOfWeek.thursday:
        return l10n.schedule_day_thursday;
      case DayOfWeek.friday:
        return l10n.schedule_day_friday;
      case DayOfWeek.saturday:
        return l10n.schedule_day_saturday;
    }
  }

  ButtonActionTable _buildViewAction(BuildContext context, dynamic item) {
    final scheduleItem = item as ScheduleItemConfig;
    return ButtonActionTable(
      color: AppColors.blue,
      text: context.l10n.common_view,
      icon: Icons.visibility_outlined,
      onPressed: () => _showDetailModal(context, scheduleItem),
    );
  }

  ButtonActionTable _buildEditAction(BuildContext context, dynamic item) {
    final scheduleItem = item as ScheduleItemConfig;
    return ButtonActionTable(
      color: AppColors.purple,
      text: context.l10n.common_edit,
      icon: Icons.edit_outlined,
      onPressed:
          () => context.go(
            '/schedule/${scheduleItem.scheduleItemId}/edit',
            extra: scheduleItem,
          ),
    );
  }

  ButtonActionTable _buildDuplicateAction(BuildContext context, dynamic item) {
    final scheduleItem = item as ScheduleItemConfig;
    final l10n = context.l10n;
    final store = context.read<ScheduleListStore>();

    return ButtonActionTable(
      color: Colors.blueAccent,
      text: l10n.schedule_duplicate_title,
      icon: Icons.copy,
      onPressed: () {
        ModalPage(
          title: l10n.schedule_duplicate_title,
          body: ChangeNotifierProvider<ScheduleListStore>.value(
            value: store,
            child: DuplicateScheduleModal(originalItem: scheduleItem),
          ),
          width: 600,
        ).show(context);
      },
    );
  }

  ButtonActionTable _buildToggleActiveAction(
    BuildContext context,
    dynamic item,
  ) {
    final scheduleItem = item as ScheduleItemConfig;
    final store = Provider.of<ScheduleListStore>(context, listen: false);
    final l10n = context.l10n;

    if (!scheduleItem.isActive) {
      return ButtonActionTable(
        color: AppColors.green,
        text: l10n.schedule_action_reactivate,
        icon: Icons.restore,
        onPressed: () async {
          final confirmed = await confirmationDialog(
            context,
            l10n.schedule_reactivate_confirm_message,
          );
          if (confirmed == true && context.mounted) {
            await store.reactivateItem(scheduleItem.scheduleItemId);
          }
        },
      );
    }

    return ButtonActionTable(
      color: AppColors.mustard,
      text: l10n.schedule_action_deactivate,
      icon: Icons.delete_outline,
      onPressed: () async {
        final confirmed = await confirmationDialog(
          context,
          l10n.schedule_delete_confirm_message,
        );
        if (confirmed == true && context.mounted) {
          await store.deleteItem(scheduleItem.scheduleItemId);
        }
      },
    );
  }

  void _showDetailModal(BuildContext context, ScheduleItemConfig scheduleItem) {
    final store = Provider.of<ScheduleListStore>(context, listen: false);
    final l10n = context.l10n;

    ModalPage(
      title: scheduleItem.title,
      body: ScheduleDetailModal(item: scheduleItem),
      width: 900,
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            context.go(
              '/schedule/${scheduleItem.scheduleItemId}/edit',
              extra: scheduleItem,
            );
          },
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: Text(l10n.common_edit),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.purple,
            side: const BorderSide(color: AppColors.purple),
          ),
        ),
        const SizedBox(width: 8),
        if (scheduleItem.isActive)
          OutlinedButton.icon(
            onPressed: () async {
              final confirmed = await confirmationDialog(
                context,
                l10n.schedule_delete_confirm_message,
              );
              if (confirmed == true && context.mounted) {
                await store.deleteItem(scheduleItem.scheduleItemId);
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            },
            icon: const Icon(Icons.block, size: 18),
            label: Text(l10n.schedule_action_deactivate),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () async {
              final confirmed = await confirmationDialog(
                context,
                l10n.schedule_reactivate_confirm_message,
              );
              if (confirmed == true && context.mounted) {
                await store.reactivateItem(scheduleItem.scheduleItemId);
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            },
            icon: const Icon(Icons.restore, size: 18),
            label: Text(l10n.schedule_action_reactivate),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.green,
              side: const BorderSide(color: AppColors.green),
            ),
          ),
      ],
    ).show(context);
  }
}
