import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';

const List<String> devotionalDaysOfWeek = [
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY',
];

const List<String> devotionalAudiences = [
  'all',
  'youth',
  'women',
  'men',
  'kids',
];

const List<String> devotionalTones = [
  'pastoral',
  'exhortative_soft',
  'celebrative',
  'contemplative',
];

const List<String> devotionalStatuses = [
  'pending',
  'generating',
  'in_review',
  'approved',
  'sending',
  'sent',
  'failed',
];

bool _timezoneInitialized = false;

void _ensureTimezoneInitialized() {
  if (_timezoneInitialized) return;
  tz_data.initializeTimeZones();
  _timezoneInitialized = true;
}

DateTime devotionalNowInTimezone(String timezone, {DateTime? now}) {
  final normalizedTimezone = timezone.trim();
  final current = now ?? DateTime.now();
  if (normalizedTimezone.isEmpty) return current;

  try {
    _ensureTimezoneInitialized();
    final location = tz.getLocation(normalizedTimezone);
    final tzNow = tz.TZDateTime.from(current.toUtc(), location);
    return DateTime(
      tzNow.year,
      tzNow.month,
      tzNow.day,
      tzNow.hour,
      tzNow.minute,
      tzNow.second,
      tzNow.millisecond,
      tzNow.microsecond,
    );
  } catch (_) {
    return current;
  }
}

String devotionalCurrentWeekMonday({DateTime? now, String? timezone}) {
  final current =
      (timezone != null && timezone.trim().isNotEmpty)
          ? devotionalNowInTimezone(timezone, now: now)
          : (now ?? DateTime.now());
  final monday =
      current.weekday == DateTime.sunday
          ? current.add(const Duration(days: 1))
          : current.subtract(Duration(days: current.weekday - 1));
  return DateFormat('yyyy-MM-dd').format(monday);
}

List<String> devotionalAvailableDaysForPlanWeek(
  String weekStartDate, {
  String? sendTime,
  String? timezone,
  DateTime? now,
}) {
  final weekStart = DateTime.tryParse(weekStartDate);
  if (weekStart == null) {
    return devotionalDaysOfWeek;
  }

  final current =
      (timezone != null && timezone.trim().isNotEmpty)
          ? devotionalNowInTimezone(timezone, now: now)
          : (now ?? DateTime.now());
  final monday = current.subtract(Duration(days: current.weekday - 1));
  final currentWeekStart = DateTime(monday.year, monday.month, monday.day);
  final planWeekStart = DateTime(
    weekStart.year,
    weekStart.month,
    weekStart.day,
  );

  if (planWeekStart != currentWeekStart) {
    return devotionalDaysOfWeek;
  }

  var startIndex = current.weekday - 1;
  if (_hasSendTimePassed(sendTime, current)) {
    startIndex += 1;
  }

  if (startIndex > devotionalDaysOfWeek.length - 1) {
    return <String>[];
  }

  final safeStartIndex = startIndex.clamp(0, devotionalDaysOfWeek.length - 1);
  return devotionalDaysOfWeek.sublist(safeStartIndex);
}

bool _hasSendTimePassed(String? sendTime, DateTime now) {
  final timeValue = (sendTime ?? '').trim();
  if (timeValue.isEmpty) return false;

  final parts = timeValue.split(':');
  if (parts.length != 2) return false;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return false;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return false;

  final nowInMinutes = now.hour * 60 + now.minute;
  final sendInMinutes = hour * 60 + minute;
  return nowInMinutes >= sendInMinutes;
}

DevotionalPlanModel normalizePlanDayConfigs(
  DevotionalPlanModel plan,
  List<String> availableDays,
) {
  final allowedDays = availableDays.toSet();
  final filteredDays =
      plan.daysOfWeek.where((day) => allowedDays.contains(day)).toList();
  final effectiveDays =
      filteredDays.isEmpty &&
              plan.daysOfWeek.isNotEmpty &&
              availableDays.isNotEmpty
          ? [availableDays.first]
          : filteredDays;

  final byDay = <String, DevotionalDayConfigModel>{
    for (final cfg in plan.dayConfigs) cfg.dayOfWeek: cfg,
  };

  final normalized =
      effectiveDays
          .map(
            (day) =>
                byDay[day] ??
                DevotionalDayConfigModel(
                  dayOfWeek: day,
                  titleHint: '',
                  biblicalContext: '',
                  tone: 'pastoral',
                ),
          )
          .toList();

  return plan.copyWith(daysOfWeek: effectiveDays, dayConfigs: normalized);
}

String devotionalDayLabel(BuildContext context, String day) {
  switch (day) {
    case 'MONDAY':
      return context.l10n.translate('schedule_day_monday');
    case 'TUESDAY':
      return context.l10n.translate('schedule_day_tuesday');
    case 'WEDNESDAY':
      return context.l10n.translate('schedule_day_wednesday');
    case 'THURSDAY':
      return context.l10n.translate('schedule_day_thursday');
    case 'FRIDAY':
      return context.l10n.translate('schedule_day_friday');
    case 'SATURDAY':
      return context.l10n.translate('schedule_day_saturday');
    case 'SUNDAY':
      return context.l10n.translate('schedule_day_sunday');
    default:
      return day;
  }
}

String devotionalAudienceLabel(BuildContext context, String audience) {
  switch (audience) {
    case 'all':
      return context.l10n.devotional_audience_all;
    case 'youth':
      return context.l10n.devotional_audience_youth;
    case 'women':
      return context.l10n.devotional_audience_women;
    case 'men':
      return context.l10n.devotional_audience_men;
    case 'kids':
      return context.l10n.devotional_audience_kids;
    default:
      return audience;
  }
}

String devotionalToneTitle(BuildContext context, String tone) {
  switch (tone) {
    case 'pastoral':
      return context.l10n.devotional_tone_pastoral;
    case 'exhortative_soft':
      return context.l10n.devotional_tone_exhortative;
    case 'celebrative':
      return context.l10n.devotional_tone_celebrative;
    case 'contemplative':
      return context.l10n.devotional_tone_contemplative;
    default:
      return tone;
  }
}

String devotionalToneSubtitle(BuildContext context, String tone) {
  switch (tone) {
    case 'pastoral':
      return context.l10n.devotional_tone_pastoral_desc;
    case 'exhortative_soft':
      return context.l10n.devotional_tone_exhortative_desc;
    case 'celebrative':
      return context.l10n.devotional_tone_celebrative_desc;
    case 'contemplative':
      return context.l10n.devotional_tone_contemplative_desc;
    default:
      return '';
  }
}

String devotionalStatusLabel(BuildContext context, String status) {
  switch (status) {
    case 'pending':
      return context.l10n.devotional_status_pending;
    case 'generating':
      return context.l10n.devotional_status_generating;
    case 'in_review':
      return context.l10n.devotional_status_in_review;
    case 'approved':
      return context.l10n.devotional_status_approved;
    case 'sending':
      return context.l10n.devotional_status_sending;
    case 'sent':
      return context.l10n.devotional_status_sent;
    case 'failed':
    case 'error':
      return context.l10n.devotional_status_failed;
    case 'partial':
      return context.l10n.devotional_status_partial;
    case 'not_enabled':
      return context.l10n.devotional_status_not_enabled;
    default:
      return status;
  }
}

String? validateDevotionalPlan(BuildContext context, DevotionalPlanModel plan) {
  if (!plan.isEnabled) return null;

  if (plan.themeWeek.trim().isEmpty) {
    return context.l10n.devotional_validation_theme_required;
  }

  if (plan.daysOfWeek.isEmpty) {
    return context.l10n.devotional_validation_days_required;
  }

  if (!RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(plan.sendTime)) {
    return context.l10n.devotional_validation_time_invalid;
  }

  if (plan.audience.isEmpty) {
    return context.l10n.devotional_validation_audience_required;
  }

  if (!plan.channels.pushEnabled && !plan.channels.whatsappEnabled) {
    return context.l10n.devotional_validation_channel_required;
  }

  for (final day in plan.daysOfWeek) {
    final cfg = plan.dayConfigs.where((item) => item.dayOfWeek == day).toList();
    if (cfg.isEmpty) {
      return context.l10n.devotional_validation_day_missing(day);
    }

    final current = cfg.first;
    if (current.titleHint.trim().isEmpty) {
      return context.l10n.devotional_validation_title_hint_missing(day);
    }
    if (current.biblicalContext.trim().isEmpty) {
      return context.l10n.devotional_validation_context_missing(day);
    }
  }

  return null;
}
