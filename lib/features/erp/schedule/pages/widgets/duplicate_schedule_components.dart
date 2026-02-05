import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:flutter/material.dart';

class DuplicateEventSummary extends StatelessWidget {
  final ScheduleItemConfig originalItem;
  final AppLocalizations l10n;

  const DuplicateEventSummary({
    super.key,
    required this.originalItem,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.schedule_duplicate_summary_title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: AppFonts.fontSubTitle,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildSummaryItem(
                l10n.schedule_form_type,
                _getTypeLabel(originalItem.type, l10n),
                AppColors.purple,
              ),
              _buildSummaryItem(
                l10n.schedule_form_visibility,
                _getVisibilityLabel(originalItem.visibility, l10n),
                Colors.blue,
              ),
              _buildSummaryItem(
                l10n.schedule_form_recurrence,
                '${_getDayName(originalItem.recurrencePattern.dayOfWeek, l10n)} ${originalItem.recurrencePattern.time} • ${originalItem.recurrencePattern.durationMinutes} min',
                Colors.grey[700]!,
                isBadge: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color color, {
    bool isBadge = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: AppFonts.fontText,
          ),
        ),
        const SizedBox(height: 4),
        isBadge
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: color,
                      fontFamily: AppFonts.fontSubTitle,
                    ),
                  ),
                ],
              ),
            )
            : Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
      ],
    );
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

  String _getVisibilityLabel(
    ScheduleVisibility visibility,
    AppLocalizations l10n,
  ) {
    switch (visibility) {
      case ScheduleVisibility.public:
        return l10n.schedule_visibility_public;
      case ScheduleVisibility.internalLeaders:
        return l10n.schedule_visibility_internal_leaders;
    }
  }

  String _getDayName(DayOfWeek day, AppLocalizations l10n) {
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
}

class TimePickerInput extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const TimePickerInput({
    super.key,
    required this.label,
    required this.time,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Input(
      label: label,
      initialValue: time?.format(context) ?? '--:--',
      readOnly: true,
      onChanged: (_) {}, // Read-only
      icon: Icons.access_time,
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? const TimeOfDay(hour: 0, minute: 0),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.purple,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
    );
  }
}
