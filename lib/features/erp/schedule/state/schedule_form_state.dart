import 'package:church_finance_bk/features/erp/schedule/models/schedule_models.dart';

class ScheduleFormState {
  final bool loading;
  final bool submitting;
  final String? scheduleItemId; // null = crear, non-null = editar

  // Campos del formulario
  final ScheduleItemType type;
  final String title;
  final String description;
  final String locationName;
  final String locationAddress;
  final DayOfWeek dayOfWeek;
  final String time;
  final int durationMinutes;
  final String timezone;
  final DateTime startDate;
  final DateTime? endDate;
  final bool hasEndDate;
  final ScheduleVisibility visibility;
  final String director;
  final String preacher;
  final String observations;

  // Validaciones
  final Map<String, String?> validationErrors;

  const ScheduleFormState({
    required this.loading,
    required this.submitting,
    required this.scheduleItemId,
    required this.type,
    required this.title,
    required this.description,
    required this.locationName,
    required this.locationAddress,
    required this.dayOfWeek,
    required this.time,
    required this.durationMinutes,
    required this.timezone,
    required this.startDate,
    required this.endDate,
    required this.hasEndDate,
    required this.visibility,
    required this.director,
    required this.preacher,
    required this.observations,
    required this.validationErrors,
  });

  factory ScheduleFormState.initial({String? scheduleItemId}) {
    return ScheduleFormState(
      loading: false,
      submitting: false,
      scheduleItemId: scheduleItemId,
      type: ScheduleItemType.service,
      title: '',
      description: '',
      locationName: '',
      locationAddress: '',
      dayOfWeek: DayOfWeek.sunday,
      time: '10:00',
      durationMinutes: 90,
      timezone: 'America/Sao_Paulo',
      startDate: DateTime.now(),
      endDate: null,
      hasEndDate: false,
      visibility: ScheduleVisibility.public,
      director: '',
      preacher: '',
      observations: '',
      validationErrors: const {},
    );
  }

  bool get isEditMode => scheduleItemId != null;

  ScheduleFormState copyWith({
    bool? loading,
    bool? submitting,
    String? scheduleItemId,
    ScheduleItemType? type,
    String? title,
    String? description,
    String? locationName,
    String? locationAddress,
    DayOfWeek? dayOfWeek,
    String? time,
    int? durationMinutes,
    String? timezone,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasEndDate,
    bool clearEndDate = false,
    ScheduleVisibility? visibility,
    String? director,
    String? preacher,
    String? observations,
    Map<String, String?>? validationErrors,
  }) {
    return ScheduleFormState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      scheduleItemId: scheduleItemId ?? this.scheduleItemId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      time: time ?? this.time,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      timezone: timezone ?? this.timezone,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      hasEndDate: hasEndDate ?? this.hasEndDate,
      visibility: visibility ?? this.visibility,
      director: director ?? this.director,
      preacher: preacher ?? this.preacher,
      observations: observations ?? this.observations,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  factory ScheduleFormState.fromItem(ScheduleItemConfig item) {
    return ScheduleFormState(
      loading: false,
      submitting: false,
      scheduleItemId: item.scheduleItemId,
      type: item.type,
      title: item.title,
      description: item.description ?? '',
      locationName: item.location.name,
      locationAddress: item.location.address ?? '',
      dayOfWeek: item.recurrencePattern.dayOfWeek,
      time: item.recurrencePattern.time,
      durationMinutes: item.recurrencePattern.durationMinutes,
      timezone: item.recurrencePattern.timezone,
      startDate: DateTime.parse(item.recurrencePattern.startDate),
      endDate:
          item.recurrencePattern.endDate != null
              ? DateTime.parse(item.recurrencePattern.endDate!)
              : null,
      hasEndDate: item.recurrencePattern.endDate != null,
      visibility: item.visibility,
      director: item.director,
      preacher: item.preacher ?? '',
      observations: item.observations ?? '',
      validationErrors: const {},
    );
  }
}
