import 'package:church_finance_bk/features/erp/schedule/models/schedule_models.dart';
import 'package:church_finance_bk/features/erp/schedule/service/schedule_service.dart';
import 'package:church_finance_bk/features/erp/schedule/state/schedule_form_state.dart';
import 'package:flutter/foundation.dart';

class ScheduleFormStore extends ChangeNotifier {
  final ScheduleService service = ScheduleService();
  ScheduleFormState state;

  ScheduleFormStore({String? scheduleItemId, ScheduleItemConfig? initialData})
    : state =
          initialData != null
              ? ScheduleFormState.fromItem(initialData)
              : ScheduleFormState.initial(scheduleItemId: scheduleItemId);

  // Setters de campos
  void setType(ScheduleItemType value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('type');
    state = state.copyWith(type: value, validationErrors: errors);
    notifyListeners();
  }

  void setTitle(String value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('title');
    state = state.copyWith(title: value, validationErrors: errors);
    notifyListeners();
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
    notifyListeners();
  }

  void setLocationName(String value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('locationName');
    state = state.copyWith(locationName: value, validationErrors: errors);
    notifyListeners();
  }

  void setLocationAddress(String value) {
    state = state.copyWith(locationAddress: value);
    notifyListeners();
  }

  void setDayOfWeek(DayOfWeek value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('dayOfWeek');
    state = state.copyWith(dayOfWeek: value, validationErrors: errors);
    notifyListeners();
  }

  void setTime(String value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('time');
    state = state.copyWith(time: value, validationErrors: errors);
    notifyListeners();
  }

  void setDurationMinutes(int value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('durationMinutes');
    state = state.copyWith(durationMinutes: value, validationErrors: errors);
    notifyListeners();
  }

  void setTimezone(String value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('timezone');
    state = state.copyWith(timezone: value, validationErrors: errors);
    notifyListeners();
  }

  void setStartDate(DateTime value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('startDate');
    state = state.copyWith(startDate: value, validationErrors: errors);
    notifyListeners();
  }

  void setEndDate(DateTime? value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('endDate');
    state = state.copyWith(endDate: value, validationErrors: errors);
    notifyListeners();
  }

  void setHasEndDate(bool value) {
    state = state.copyWith(hasEndDate: value, clearEndDate: !value);
    notifyListeners();
  }

  void setVisibility(ScheduleVisibility value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('visibility');
    state = state.copyWith(visibility: value, validationErrors: errors);
    notifyListeners();
  }

  void setDirector(String value) {
    final errors = Map<String, String?>.from(state.validationErrors)
      ..remove('director');
    state = state.copyWith(director: value, validationErrors: errors);
    notifyListeners();
  }

  void setPreacher(String value) {
    state = state.copyWith(preacher: value);
    notifyListeners();
  }

  void setObservations(String value) {
    state = state.copyWith(observations: value);
    notifyListeners();
  }

  /// Cargar datos para edición
  Future<void> loadForEdit() async {
    if (state.scheduleItemId == null) return;

    state = state.copyWith(loading: true);
    notifyListeners();

    try {
      final item = await service.getScheduleItemById(state.scheduleItemId!);
      state = ScheduleFormState.fromItem(item);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false);
      notifyListeners();
      rethrow;
    }
  }

  /// Validar formulario
  bool validate() {
    final errors = <String, String?>{};

    if (state.title.trim().isEmpty) {
      errors['title'] = 'schedule_form_error_title_required';
    }

    if (state.locationName.trim().isEmpty) {
      errors['locationName'] = 'schedule_form_error_location_name_required';
    }

    if (state.director.trim().isEmpty) {
      errors['director'] = 'schedule_form_error_director_required';
    }

    if (state.durationMinutes <= 0) {
      errors['durationMinutes'] = 'schedule_form_error_duration_invalid';
    }

    if (state.hasEndDate &&
        state.endDate != null &&
        state.endDate!.isBefore(state.startDate)) {
      errors['endDate'] = 'schedule_form_error_end_date_before_start';
    }

    state = state.copyWith(validationErrors: errors);
    notifyListeners();
    return errors.isEmpty;
  }

  /// Enviar formulario (crear o actualizar)
  Future<bool> submit() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(submitting: true);
    notifyListeners();

    try {
      final location = Location(
        name: state.locationName.trim(),
        address:
            state.locationAddress.trim().isEmpty
                ? null
                : state.locationAddress.trim(),
      );

      final recurrencePattern = RecurrencePattern(
        type: RecurrenceType.weekly,
        dayOfWeek: state.dayOfWeek,
        time: state.time,
        durationMinutes: state.durationMinutes,
        timezone: state.timezone,
        startDate: _formatDate(state.startDate),
        endDate:
            state.hasEndDate && state.endDate != null
                ? _formatDate(state.endDate!)
                : null,
      );

      if (state.isEditMode) {
        // Actualizar
        final payload = ScheduleItemUpdatePayload(
          title: state.title.trim(),
          description:
              state.description.trim().isEmpty
                  ? null
                  : state.description.trim(),
          location: location,
          recurrencePattern: recurrencePattern,
          visibility: state.visibility,
          director: state.director.trim(),
          preacher:
              state.preacher.trim().isEmpty ? null : state.preacher.trim(),
          observations:
              state.observations.trim().isEmpty
                  ? null
                  : state.observations.trim(),
        );
        await service.updateScheduleItem(state.scheduleItemId!, payload);
      } else {
        // Crear
        final payload = ScheduleItemPayload(
          type: state.type,
          title: state.title.trim(),
          description:
              state.description.trim().isEmpty
                  ? null
                  : state.description.trim(),
          location: location,
          recurrencePattern: recurrencePattern,
          visibility: state.visibility,
          director: state.director.trim(),
          preacher:
              state.preacher.trim().isEmpty ? null : state.preacher.trim(),
          observations:
              state.observations.trim().isEmpty
                  ? null
                  : state.observations.trim(),
        );
        await service.createScheduleItem(payload);
      }

      state = state.copyWith(submitting: false);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(submitting: false);
      notifyListeners();
      return false;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Resetear formulario
  void reset() {
    state = ScheduleFormState.initial(scheduleItemId: state.scheduleItemId);
    notifyListeners();
  }
}
