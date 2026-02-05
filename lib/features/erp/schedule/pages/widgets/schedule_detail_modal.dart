import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:flutter/material.dart';

class ScheduleDetailModal extends StatelessWidget {
  final ScheduleItemConfig item;

  const ScheduleDetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badges row: Type, Visibility, Status
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge(
                    _getTypeLabel(item.type, l10n),
                    AppColors.purple.withOpacity(0.1),
                    AppColors.purple,
                    Icons.circle,
                  ),
                  _buildBadge(
                    _getVisibilityLabel(item.visibility, l10n),
                    Colors.blue.withOpacity(0.1),
                    Colors.blue,
                    Icons.public,
                  ),
                  _buildBadge(
                    item.isActive
                        ? l10n.schedule_status_active
                        : l10n.schedule_status_inactive,
                    item.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    item.isActive ? Colors.green : Colors.grey,
                    Icons.circle,
                    iconSize: 8,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 24),

              // Resumo section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildResumoSection(l10n)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildLocalSection(l10n)),
                ],
              ),

              const SizedBox(height: 24),

              // Responsáveis section
              _buildSectionTitle(l10n.schedule_detail_responsibility),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildResponsavel(
                    l10n.schedule_detail_director,
                    item.director,
                    Icons.person,
                  ),
                  const SizedBox(width: 24),
                  if (item.preacher != null && item.preacher!.isNotEmpty)
                    _buildResponsavel(
                      l10n.schedule_detail_preacher,
                      item.preacher!,
                      Icons.person,
                    ),
                ],
              ),

              if (item.description != null && item.description!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSectionTitle(l10n.schedule_detail_description),
                const SizedBox(height: 8),
                Text(
                  item.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontFamily: AppFonts.fontText,
                  ),
                ),
              ],

              if (item.observations != null &&
                  item.observations!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSectionTitle(l10n.schedule_detail_observations),
                const SizedBox(height: 8),
                Text(
                  item.observations!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontFamily: AppFonts.fontText,
                  ),
                ),
              ],

              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Footer metadata
              Text(
                '${l10n.schedule_detail_created_at} ${convertDateFormatToDDMMYYYY(item.createdAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: AppFonts.fontText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(
    String label,
    Color bgColor,
    Color textColor,
    IconData icon, {
    double iconSize = 16,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.fontSubTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoSection(l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.schedule_detail_summary),
        const SizedBox(height: 12),
        _buildInfoRow(
          l10n.schedule_detail_when,
          '${_getDayName(item.recurrencePattern.dayOfWeek, l10n)} • ${item.recurrencePattern.time} • ${item.recurrencePattern.durationMinutes} min',
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          l10n.schedule_detail_timezone,
          item.recurrencePattern.timezone,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          l10n.schedule_detail_start,
          convertDateFormatToDDMMYYYY(item.recurrencePattern.startDate),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          l10n.schedule_detail_end,
          item.recurrencePattern.endDate != null
              ? convertDateFormatToDDMMYYYY(item.recurrencePattern.endDate!)
              : l10n.schedule_detail_no_end_date,
        ),
      ],
    );
  }

  Widget _buildLocalSection(l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.schedule_detail_location_info),
        const SizedBox(height: 12),
        Text(
          item.location.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: AppFonts.fontSubTitle,
          ),
        ),
        if (item.location.address != null &&
            item.location.address!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            item.location.address!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: AppFonts.fontText,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResponsavel(String role, String name, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: AppFonts.fontText,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: AppFonts.fontTitle,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: AppFonts.fontText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.fontSubTitle,
            ),
          ),
        ),
      ],
    );
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

  String _getDayName(DayOfWeek day, l10n) {
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
