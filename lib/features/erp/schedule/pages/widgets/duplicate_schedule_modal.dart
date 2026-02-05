import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/pages/widgets/duplicate_schedule_components.dart';
import 'package:gloria_finance/features/erp/schedule/store/schedule_list_store.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DuplicateScheduleModal extends StatefulWidget {
  final ScheduleItemConfig originalItem;

  const DuplicateScheduleModal({super.key, required this.originalItem});

  @override
  State<DuplicateScheduleModal> createState() => _DuplicateScheduleModalState();
}

class _DuplicateScheduleModalState extends State<DuplicateScheduleModal> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _locationName;
  late String _observations;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _durationMinutes = 0;

  late DayOfWeek _selectedDay;
  late ScheduleVisibility _selectedVisibility;
  bool _openFullEdit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _title = '${widget.originalItem.title} (cópia)';
    _locationName = widget.originalItem.location.name;
    _observations = widget.originalItem.observations ?? '';

    _selectedDay = widget.originalItem.recurrencePattern.dayOfWeek;
    _selectedVisibility = widget.originalItem.visibility;
    _durationMinutes = widget.originalItem.recurrencePattern.durationMinutes;

    final timeParts = widget.originalItem.recurrencePattern.time.split(':');
    if (timeParts.length == 2) {
      _startTime = TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 10,
        minute: int.tryParse(timeParts[1]) ?? 0,
      );
    }

    if (_startTime != null) {
      final totalMinutes =
          _startTime!.hour * 60 + _startTime!.minute + _durationMinutes;
      _endTime = TimeOfDay(
        hour: (totalMinutes ~/ 60) % 24,
        minute: totalMinutes % 60,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateDuration() {
    if (_startTime != null && _endTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
      // Handle overnight case if needed, but assuming same day for now as per ScheduleForm
      int duration = endMinutes - startMinutes;
      if (duration < 0) {
        duration += 24 * 60;
      }

      if (duration > 0) {
        setState(() => _durationMinutes = duration);
      }
    }
  }

  Future<void> _handleDuplicate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startTime == null || _endTime == null) {
      return; // Validation handled by UI ideally, but safety check
    }

    setState(() => _isLoading = true);

    final store = Provider.of<ScheduleListStore>(context, listen: false);
    final l10n = context.l10n;
    final navigator = Navigator.of(context, rootNavigator: true);
    final goRouter = GoRouter.of(context);

    try {
      final payload = ScheduleItemPayload(
        type: widget.originalItem.type,
        title: _title,
        description: widget.originalItem.description,
        location: Location(
          name: _locationName,
          address: widget.originalItem.location.address,
        ),
        recurrencePattern: RecurrencePattern(
          type: widget.originalItem.recurrencePattern.type,
          dayOfWeek: _selectedDay,
          time:
              '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
          durationMinutes: _durationMinutes,
          timezone: widget.originalItem.recurrencePattern.timezone,
          startDate: DateTime.now().toIso8601String().split('T')[0],
          endDate: widget.originalItem.recurrencePattern.endDate,
        ),
        visibility: _selectedVisibility,
        director: widget.originalItem.director,
        preacher: widget.originalItem.preacher,
        observations: _observations.isNotEmpty ? _observations : null,
      );

      final newItem = await store.duplicateItem(payload);

      if (navigator.mounted) {
        navigator.pop();
      }

      if (_openFullEdit) {
        goRouter.go('/schedule/${newItem.scheduleItemId}/edit', extra: newItem);
      } else {
        Toast.showMessage(
          l10n.schedule_duplicate_toast_success,
          ToastType.info,
        );
      }
    } catch (e) {
      if (mounted) {
        Toast.showMessage(l10n.schedule_duplicate_toast_error, ToastType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Text(
                l10n.schedule_duplicate_subtitle(widget.originalItem.title),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: AppFonts.fontText,
                ),
              ),
              const SizedBox(height: 24),

              // Summary Card
              DuplicateEventSummary(
                originalItem: widget.originalItem,
                l10n: l10n,
              ),
              const SizedBox(height: 24),

              // Adjustments Section
              Text(
                l10n.schedule_duplicate_adjustments_title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontTitle,
                ),
              ),
              const SizedBox(height: 16),

              // Form Fields
              Input(
                label: l10n.schedule_form_field_title,
                initialValue: _title,
                onChanged: (val) => _title = val,
                onValidator:
                    (val) =>
                        val == null || val.isEmpty
                            ? l10n.schedule_form_error_required
                            : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Dropdown(
                      label: l10n.schedule_form_field_day_of_week,
                      initialValue: _getDayName(_selectedDay, l10n),
                      items:
                          DayOfWeek.values
                              .map((d) => _getDayName(d, l10n))
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDay = DayOfWeek.values.firstWhere(
                            (d) => _getDayName(d, l10n) == val,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TimePickerInput(
                      label: l10n.schedule_form_start_time,
                      time: _startTime,
                      onTimeSelected: (picked) {
                        setState(() {
                          _startTime = picked;
                          if (_endTime != null) _updateDuration();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TimePickerInput(
                      label: l10n.schedule_form_end_time,
                      time: _endTime,
                      onTimeSelected: (picked) {
                        setState(() {
                          _endTime = picked;
                          _updateDuration();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Input(
                      label: l10n.schedule_form_field_location_name,
                      initialValue: _locationName,
                      onChanged: (val) => _locationName = val,
                      onValidator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? l10n.schedule_form_error_required
                                  : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Dropdown(
                      label: l10n.schedule_form_field_visibility,
                      initialValue: _getVisibilityLabel(
                        _selectedVisibility,
                        l10n,
                      ),
                      items:
                          ScheduleVisibility.values
                              .map((v) => _getVisibilityLabel(v, l10n))
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedVisibility = ScheduleVisibility.values
                              .firstWhere(
                                (v) => _getVisibilityLabel(v, l10n) == val,
                              );
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Input(
                label: l10n.schedule_form_field_observations,
                initialValue: _observations,
                onChanged: (val) => _observations = val,
                maxLines: 2,
              ),

              const SizedBox(height: 24),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.schedule_duplicate_open_edit),
                value: _openFullEdit,
                activeColor: AppColors.purple,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) => setState(() => _openFullEdit = val ?? true),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: l10n.common_cancel,
                      backgroundColor: Colors.grey,
                      typeButton: CustomButton.outline,
                      textColor: Colors.black87,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: Loading())
                            : CustomButton(
                              text: l10n.schedule_duplicate_action_create,
                              backgroundColor: AppColors.green,
                              textColor: Colors.black,
                              onPressed: _handleDuplicate,
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
