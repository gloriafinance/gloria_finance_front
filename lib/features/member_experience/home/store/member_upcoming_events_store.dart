import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/service/schedule_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class MemberUpcomingEventsStore extends ChangeNotifier {
  final ScheduleService _service;

  bool isLoading = false;
  String? errorMessage;
  List<WeeklyOccurrence> events = const [];

  MemberUpcomingEventsStore({ScheduleService? service})
    : _service = service ?? ScheduleService();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final weekStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final occurrences = await _service.getWeeklySchedule(
        weekStartDate,
        visibilityScope: ScheduleVisibility.public,
      );

      final now = DateTime.now();
      final upcoming =
          occurrences.where((occurrence) {
              final start = _occurrenceStart(occurrence);
              return start.isAfter(now) ||
                  start.isAtSameMomentAs(now) ||
                  start.isAfter(now.subtract(const Duration(minutes: 1)));
            }).toList()
            ..sort(
              (a, b) => _occurrenceStart(a).compareTo(_occurrenceStart(b)),
            );

      events = upcoming.take(10).toList(growable: false);
    } catch (e) {
      errorMessage = e.toString();
      events = const [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  DateTime _occurrenceStart(WeeklyOccurrence occurrence) {
    final date = DateTime.tryParse(occurrence.date) ?? DateTime.now();
    final parts = occurrence.startTime.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
