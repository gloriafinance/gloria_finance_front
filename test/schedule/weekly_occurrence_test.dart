import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeeklyOccurrence', () {
    test('parses response without scheduleItemId', () {
      final json = {
        'title': 'Dominical',
        'type': 'SERVICE',
        'date': '2026-01-11',
        'startTime': '18:00',
        'endTime': '20:30',
        'location': {'name': 'Salao'},
        'visibility': 'PUBLIC',
      };

      final model = WeeklyOccurrence.fromJson(json);

      expect(model.scheduleItemId, '');
      expect(model.title, 'Dominical');
      expect(model.type, ScheduleItemType.service);
      expect(model.location.name, 'Salao');
      expect(model.visibility, ScheduleVisibility.public);
    });
  });
}
