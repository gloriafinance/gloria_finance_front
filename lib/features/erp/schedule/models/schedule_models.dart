// Enums y modelos para el módulo de Schedule (Agenda/Eventos)
// Mapea 1:1 con el contrato de API de /api/v1/schedule

enum ScheduleItemType { service, cell, ministryMeeting, regularEvent, other }

extension ScheduleItemTypeExtension on ScheduleItemType {
  String get friendlyName {
    switch (this) {
      case ScheduleItemType.service:
        return 'schedule_type_service'; // localización key
      case ScheduleItemType.cell:
        return 'schedule_type_cell';
      case ScheduleItemType.ministryMeeting:
        return 'schedule_type_ministry_meeting';
      case ScheduleItemType.regularEvent:
        return 'schedule_type_regular_event';
      case ScheduleItemType.other:
        return 'schedule_type_other';
    }
  }

  String get apiValue {
    switch (this) {
      case ScheduleItemType.service:
        return 'SERVICE';
      case ScheduleItemType.cell:
        return 'CELL';
      case ScheduleItemType.ministryMeeting:
        return 'MINISTRY_MEETING';
      case ScheduleItemType.regularEvent:
        return 'REGULAR_EVENT';
      case ScheduleItemType.other:
        return 'OTHER';
    }
  }

  static ScheduleItemType fromApiValue(String value) {
    return ScheduleItemType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => ScheduleItemType.other,
    );
  }
}

enum ScheduleVisibility { public, internalLeaders }

extension ScheduleVisibilityExtension on ScheduleVisibility {
  String get friendlyName {
    switch (this) {
      case ScheduleVisibility.public:
        return 'schedule_visibility_public';
      case ScheduleVisibility.internalLeaders:
        return 'schedule_visibility_internal_leaders';
    }
  }

  String get apiValue {
    switch (this) {
      case ScheduleVisibility.public:
        return 'PUBLIC';
      case ScheduleVisibility.internalLeaders:
        return 'INTERNAL_LEADERS';
    }
  }

  static ScheduleVisibility fromApiValue(String value) {
    return ScheduleVisibility.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => ScheduleVisibility.public,
    );
  }
}

enum RecurrenceType { weekly }

extension RecurrenceTypeExtension on RecurrenceType {
  String get apiValue {
    switch (this) {
      case RecurrenceType.weekly:
        return 'WEEKLY';
    }
  }

  static RecurrenceType fromApiValue(String value) {
    return RecurrenceType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => RecurrenceType.weekly,
    );
  }
}

enum DayOfWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

extension DayOfWeekExtension on DayOfWeek {
  String get friendlyName {
    switch (this) {
      case DayOfWeek.sunday:
        return 'schedule_day_sunday';
      case DayOfWeek.monday:
        return 'schedule_day_monday';
      case DayOfWeek.tuesday:
        return 'schedule_day_tuesday';
      case DayOfWeek.wednesday:
        return 'schedule_day_wednesday';
      case DayOfWeek.thursday:
        return 'schedule_day_thursday';
      case DayOfWeek.friday:
        return 'schedule_day_friday';
      case DayOfWeek.saturday:
        return 'schedule_day_saturday';
    }
  }

  String get apiValue {
    switch (this) {
      case DayOfWeek.sunday:
        return 'SUNDAY';
      case DayOfWeek.monday:
        return 'MONDAY';
      case DayOfWeek.tuesday:
        return 'TUESDAY';
      case DayOfWeek.wednesday:
        return 'WEDNESDAY';
      case DayOfWeek.thursday:
        return 'THURSDAY';
      case DayOfWeek.friday:
        return 'FRIDAY';
      case DayOfWeek.saturday:
        return 'SATURDAY';
    }
  }

  static DayOfWeek fromApiValue(String value) {
    return DayOfWeek.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => DayOfWeek.sunday,
    );
  }
}

class Location {
  final String name;
  final String? address;

  Location({required this.name, this.address});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, if (address != null) 'address': address};
  }
}

class RecurrencePattern {
  final RecurrenceType type;
  final DayOfWeek dayOfWeek;
  final String time; // formato "HH:mm"
  final int durationMinutes;
  final String timezone;
  final String startDate; // formato "yyyy-MM-dd"
  final String? endDate; // formato "yyyy-MM-dd"

  RecurrencePattern({
    required this.type,
    required this.dayOfWeek,
    required this.time,
    required this.durationMinutes,
    required this.timezone,
    required this.startDate,
    this.endDate,
  });

  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    return RecurrencePattern(
      type: RecurrenceTypeExtension.fromApiValue(json['type'] as String),
      dayOfWeek: DayOfWeekExtension.fromApiValue(json['dayOfWeek'] as String),
      time: json['time'] as String,
      durationMinutes: json['durationMinutes'] as int,
      timezone: json['timezone'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      'dayOfWeek': dayOfWeek.apiValue,
      'time': time,
      'durationMinutes': durationMinutes,
      'timezone': timezone,
      'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }
}

class ScheduleItemPayload {
  final ScheduleItemType type;
  final String title;
  final String? description;
  final Location location;
  final RecurrencePattern recurrencePattern;
  final ScheduleVisibility visibility;
  final String director;
  final String? preacher;
  final String? observations;

  ScheduleItemPayload({
    required this.type,
    required this.title,
    this.description,
    required this.location,
    required this.recurrencePattern,
    required this.visibility,
    required this.director,
    this.preacher,
    this.observations,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      'title': title,
      if (description != null) 'description': description,
      'location': location.toJson(),
      'recurrencePattern': recurrencePattern.toJson(),
      'visibility': visibility.apiValue,
      'director': director,
      if (preacher != null) 'preacher': preacher,
      if (observations != null) 'observations': observations,
    };
  }
}

class ScheduleItemUpdatePayload {
  final String? title;
  final String? description;
  final Location? location;
  final RecurrencePattern? recurrencePattern;
  final ScheduleVisibility? visibility;
  final String? director;
  final String? preacher;
  final String? observations;

  ScheduleItemUpdatePayload({
    this.title,
    this.description,
    this.location,
    this.recurrencePattern,
    this.visibility,
    this.director,
    this.preacher,
    this.observations,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location!.toJson(),
      if (recurrencePattern != null)
        'recurrencePattern': recurrencePattern!.toJson(),
      if (visibility != null) 'visibility': visibility!.apiValue,
      if (director != null) 'director': director,
      if (preacher != null) 'preacher': preacher,
      if (observations != null) 'observations': observations,
    };
  }
}

class ScheduleItemConfig {
  final String scheduleItemId;
  final String churchId;
  final ScheduleItemType type;
  final String title;
  final String? description;
  final Location location;
  final RecurrencePattern recurrencePattern;
  final ScheduleVisibility visibility;
  final String director;
  final String? preacher;
  final String? observations;
  final bool isActive;
  final String createdAt;
  final String createdByUserId;
  final String? updatedAt;
  final String? updatedByUserId;

  ScheduleItemConfig({
    required this.scheduleItemId,
    required this.churchId,
    required this.type,
    required this.title,
    this.description,
    required this.location,
    required this.recurrencePattern,
    required this.visibility,
    required this.director,
    this.preacher,
    this.observations,
    required this.isActive,
    required this.createdAt,
    required this.createdByUserId,
    this.updatedAt,
    this.updatedByUserId,
  });

  factory ScheduleItemConfig.fromJson(Map<String, dynamic> json) {
    return ScheduleItemConfig(
      scheduleItemId: json['scheduleItemId'] as String,
      churchId: json['churchId'] as String,
      type: ScheduleItemTypeExtension.fromApiValue(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      recurrencePattern: RecurrencePattern.fromJson(
        json['recurrencePattern'] as Map<String, dynamic>,
      ),
      visibility: ScheduleVisibilityExtension.fromApiValue(
        json['visibility'] as String,
      ),
      director: json['director'] as String,
      preacher: json['preacher'] as String?,
      observations: json['observations'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String,
      createdByUserId: json['createdByUserId'] as String,
      updatedAt: json['updatedAt'] as String?,
      updatedByUserId: json['updatedByUserId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleItemId': scheduleItemId,
      'churchId': churchId,
      'type': type.apiValue,
      'title': title,
      if (description != null) 'description': description,
      'location': location.toJson(),
      'recurrencePattern': recurrencePattern.toJson(),
      'visibility': visibility.apiValue,
      'director': director,
      if (preacher != null) 'preacher': preacher,
      if (observations != null) 'observations': observations,
      'isActive': isActive,
      'createdAt': createdAt,
      'createdByUserId': createdByUserId,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedByUserId != null) 'updatedByUserId': updatedByUserId,
    };
  }
}

class WeeklyOccurrence {
  final String scheduleItemId;
  final String title;
  final ScheduleItemType type;
  final String date; // formato "yyyy-MM-dd"
  final String startTime; // formato "HH:mm"
  final String endTime; // formato "HH:mm"
  final Location location;
  final ScheduleVisibility visibility;

  WeeklyOccurrence({
    required this.scheduleItemId,
    required this.title,
    required this.type,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.visibility,
  });

  factory WeeklyOccurrence.fromJson(Map<String, dynamic> json) {
    return WeeklyOccurrence(
      scheduleItemId: json['scheduleItemId'] as String,
      title: json['title'] as String,
      type: ScheduleItemTypeExtension.fromApiValue(json['type'] as String),
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      visibility: ScheduleVisibilityExtension.fromApiValue(
        json['visibility'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleItemId': scheduleItemId,
      'title': title,
      'type': type.apiValue,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'location': location.toJson(),
      'visibility': visibility.apiValue,
    };
  }
}
