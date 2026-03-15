import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/devotional/utils/devotional_screen_utils.dart';

void main() {
  group('devotionalCurrentWeekMonday', () {
    test('returns current week monday on weekdays before sunday', () {
      final result = devotionalCurrentWeekMonday(
        now: DateTime(2026, 3, 13, 10),
      );

      expect(result, '2026-03-09');
    });

    test('returns next monday when current day is sunday', () {
      final result = devotionalCurrentWeekMonday(
        now: DateTime(2026, 3, 15, 10),
      );

      expect(result, '2026-03-16');
    });

    test('uses timezone local date when deciding sunday rollover', () {
      final result = devotionalCurrentWeekMonday(
        now: DateTime.utc(2026, 3, 16, 2, 30),
        timezone: 'America/Sao_Paulo',
      );

      expect(result, '2026-03-16');
    });
  });
}
