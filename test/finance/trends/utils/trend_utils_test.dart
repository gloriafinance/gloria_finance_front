import 'package:church_finance_bk/finance/trends/utils/trend_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrendUtils.getVariation', () {
    test('returns null when previous value is zero', () {
      expect(TrendUtils.getVariation(100, 0), isNull);
    });

    test('detects upward variation', () {
      final result = TrendUtils.getVariation(150, 100)!;

      expect(result['direction'], 'up');
      expect(result['pct'], closeTo(50, 0.001));
    });

    test('detects downward variation', () {
      final result = TrendUtils.getVariation(50, 100)!;

      expect(result['direction'], 'down');
      expect(result['pct'], closeTo(-50, 0.001));
    });

    test('detects flat variation', () {
      final result = TrendUtils.getVariation(100, 100)!;

      expect(result['direction'], 'flat');
      expect(result['pct'], 0);
    });
  });
}
