import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/store/schedule_form_store.dart';
import 'package:gloria_finance/features/erp/schedule/store/schedule_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final formKey = GlobalKey<FormState>();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    final store = context.read<ScheduleFormStore>();
    final timeParts = store.state.time.split(':');
    if (timeParts.length == 2) {
      startTime = TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 10,
        minute: int.tryParse(timeParts[1]) ?? 0,
      );
    }
    // Calculate end time from duration
    if (startTime != null) {
      final totalMinutes =
          startTime!.hour * 60 +
          startTime!.minute +
          store.state.durationMinutes;
      endTime = TimeOfDay(
        hour: (totalMinutes ~/ 60) % 24,
        minute: totalMinutes % 60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formStore = context.watch<ScheduleFormStore>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child:
            isMobile(context)
                ? _buildMobileLayout(formStore)
                : _buildDesktopLayout(formStore),
      ),
    );
  }

  Widget _buildMobileLayout(ScheduleFormStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTypeField(formStore),
        const SizedBox(height: 24),
        _buildTitleField(formStore),
        const SizedBox(height: 16),
        _buildDescriptionField(formStore),
        const SizedBox(height: 16),
        _buildLocationFields(formStore),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.schedule_form_weekly_recurrence),
        const SizedBox(height: 12),
        _buildWeeklyRecurrenceSelector(formStore),
        const SizedBox(height: 24),
        _buildTimeFields(formStore),
        const SizedBox(height: 24),
        _buildDateFields(formStore),
        const SizedBox(height: 16),
        _buildVisibilityField(formStore),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.schedule_form_section_responsibility),
        const SizedBox(height: 12),
        _buildDirectorField(formStore),
        const SizedBox(height: 16),
        _buildPreacherField(formStore),
        const SizedBox(height: 16),
        _buildObservationsField(formStore),
        const SizedBox(height: 32),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildDesktopLayout(ScheduleFormStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTypeField(formStore),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildTitleField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildVisibilityField(formStore)),
          ],
        ),
        const SizedBox(height: 16),
        _buildDescriptionField(formStore),
        const SizedBox(height: 16),
        _buildLocationFields(formStore),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.schedule_form_weekly_recurrence),
        const SizedBox(height: 12),
        _buildWeeklyRecurrenceSelector(formStore),
        const SizedBox(height: 24),
        _buildTimeFields(formStore),
        const SizedBox(height: 24),
        _buildDateFields(formStore),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.schedule_form_section_responsibility),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDirectorField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildPreacherField(formStore)),
          ],
        ),
        const SizedBox(height: 16),
        _buildObservationsField(formStore),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(width: 300, child: _buildSubmitButton(formStore)),
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
        color: AppColors.purple,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTypeField(ScheduleFormStore formStore) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_form_type,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children:
              ScheduleItemType.values.map((type) {
                final isSelected = formStore.state.type == type;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => formStore.setType(type),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.purple : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.purple
                                    : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.purple.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getTypeIcon(type),
                              color:
                                  isSelected ? Colors.white : AppColors.purple,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getTypeLabel(type, l10n),
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildWeeklyRecurrenceSelector(ScheduleFormStore formStore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          DayOfWeek.values.map((day) {
            final isSelected = formStore.state.dayOfWeek == day;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => formStore.setDayOfWeek(day),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.purple : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.purple : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _getDayAbbreviation(day),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTimeFields(ScheduleFormStore formStore) {
    return Row(
      children: [
        Expanded(
          child: _buildTimePickerField(
            label: context.l10n.schedule_form_start_time,
            time: startTime ?? const TimeOfDay(hour: 10, minute: 0),
            onTimeSelected: (time) {
              setState(() {
                startTime = time;
                if (endTime != null) {
                  _updateDuration(formStore);
                }
              });
              formStore.setTime(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              );
            },
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildTimePickerField(
            label: context.l10n.schedule_form_end_time,
            time: endTime ?? const TimeOfDay(hour: 12, minute: 0),
            onTimeSelected: (time) {
              setState(() {
                endTime = time;
                _updateDuration(formStore);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      time.format(context),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _updateDuration(ScheduleFormStore formStore) {
    if (startTime != null && endTime != null) {
      final startMinutes = startTime!.hour * 60 + startTime!.minute;
      final endMinutes = endTime!.hour * 60 + endTime!.minute;
      final duration = endMinutes - startMinutes;
      if (duration > 0) {
        formStore.setDurationMinutes(duration);
      }
    }
  }

  Widget _buildTitleField(ScheduleFormStore formStore) {
    return Input(
      label: context.l10n.schedule_form_title,
      initialValue: formStore.state.title,
      onValidator: _requiredValidator,
      onChanged: formStore.setTitle,
    );
  }

  Widget _buildDescriptionField(ScheduleFormStore formStore) {
    return Input(
      label: context.l10n.schedule_form_description,
      initialValue: formStore.state.description,
      onChanged: formStore.setDescription,
      maxLines: 3,
    );
  }

  Widget _buildVisibilityField(ScheduleFormStore formStore) {
    final l10n = context.l10n;
    return Dropdown(
      label: l10n.schedule_form_visibility,
      initialValue: _getVisibilityLabel(formStore.state.visibility, l10n),
      items: [
        for (final vis in ScheduleVisibility.values)
          _getVisibilityLabel(vis, l10n),
      ],
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.schedule_form_error_visibility_required;
        }
        return null;
      },
      onChanged: (value) {
        final selected = ScheduleVisibility.values.firstWhere(
          (vis) => _getVisibilityLabel(vis, l10n) == value,
        );
        formStore.setVisibility(selected);
      },
    );
  }

  Widget _buildLocationFields(ScheduleFormStore formStore) {
    return Column(
      children: [
        Input(
          label: context.l10n.schedule_form_field_location_name,
          initialValue: formStore.state.locationName,
          onValidator: _requiredValidator,
          onChanged: formStore.setLocationName,
        ),
        const SizedBox(height: 16),
        Input(
          label: context.l10n.schedule_form_field_location_address,
          initialValue: formStore.state.locationAddress,
          onChanged: formStore.setLocationAddress,
        ),
      ],
    );
  }

  Widget _buildDateFields(ScheduleFormStore formStore) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectStartDate(formStore),
                child: AbsorbPointer(
                  child: Input(
                    label: context.l10n.schedule_form_field_start_date,
                    initialValue: dateFormat.format(formStore.state.startDate),
                    icon: Icons.calendar_today,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (formStore.state.hasEndDate)
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectEndDate(formStore),
                  child: AbsorbPointer(
                    child: Input(
                      label: context.l10n.schedule_form_field_end_date,
                      initialValue:
                          formStore.state.endDate != null
                              ? dateFormat.format(formStore.state.endDate!)
                              : '',
                      icon: Icons.calendar_today,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              context.l10n.schedule_form_field_has_end_date,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: formStore.state.hasEndDate,
              onChanged: formStore.setHasEndDate,
              activeTrackColor: AppColors.purple.withOpacity(0.5),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: WidgetStateProperty.all(
                formStore.state.hasEndDate ? AppColors.purple : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectorField(ScheduleFormStore formStore) {
    return Input(
      label: context.l10n.schedule_form_field_director,
      initialValue: formStore.state.director,
      onValidator: _requiredValidator,
      onChanged: formStore.setDirector,
    );
  }

  Widget _buildPreacherField(ScheduleFormStore formStore) {
    return Input(
      label: context.l10n.schedule_form_field_preacher,
      initialValue: formStore.state.preacher,
      onValidator: _requiredValidator, // AHORA ES REQUERIDO
      onChanged: formStore.setPreacher,
    );
  }

  Widget _buildObservationsField(ScheduleFormStore formStore) {
    return Input(
      label: context.l10n.schedule_form_field_observations,
      initialValue: formStore.state.observations,
      onChanged: formStore.setObservations,
      maxLines: 3,
    );
  }

  Widget _buildSubmitButton(ScheduleFormStore formStore) {
    if (formStore.state.submitting) {
      return const Loading();
    }

    return CustomButton(
      text: context.l10n.schedule_form_save,
      backgroundColor: AppColors.green,
      textColor: Colors.black,
      onPressed: () => _save(formStore),
    );
  }

  Future<void> _selectStartDate(ScheduleFormStore formStore) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: formStore.state.startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      formStore.setStartDate(picked);
    }
  }

  Future<void> _selectEndDate(ScheduleFormStore formStore) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: formStore.state.endDate ?? formStore.state.startDate,
      firstDate: formStore.state.startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      formStore.setEndDate(picked);
    }
  }

  Future<void> _save(ScheduleFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success = await formStore.submit();

    if (!mounted) return;

    if (success) {
      Toast.showMessage(context.l10n.schedule_form_toast_saved, ToastType.info);

      // Refresh list before navigating
      final listStore = context.read<ScheduleListStore>();
      await listStore.fetchScheduleItems();

      if (!mounted) return;
      context.go('/schedule');
    } else {
      Toast.showMessage('Error al guardar el evento', ToastType.error);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.schedule_form_error_required;
    }
    return null;
  }

  IconData _getTypeIcon(ScheduleItemType type) {
    switch (type) {
      case ScheduleItemType.service:
        return Icons.church;
      case ScheduleItemType.cell:
        return Icons.groups;
      case ScheduleItemType.ministryMeeting:
        return Icons.meeting_room;
      case ScheduleItemType.regularEvent:
        return Icons.event;
      case ScheduleItemType.other:
        return Icons.more_horiz;
    }
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

  String _getDayAbbreviation(DayOfWeek dayOfWeek) {
    final l10n = context.l10n;
    switch (dayOfWeek) {
      case DayOfWeek.sunday:
        return l10n.schedule_day_abbr_sunday;
      case DayOfWeek.monday:
        return l10n.schedule_day_abbr_monday;
      case DayOfWeek.tuesday:
        return l10n.schedule_day_abbr_tuesday;
      case DayOfWeek.wednesday:
        return l10n.schedule_day_abbr_wednesday;
      case DayOfWeek.thursday:
        return l10n.schedule_day_abbr_thursday;
      case DayOfWeek.friday:
        return l10n.schedule_day_abbr_friday;
      case DayOfWeek.saturday:
        return l10n.schedule_day_abbr_saturday;
    }
  }
}
