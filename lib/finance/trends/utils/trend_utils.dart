class TrendUtils {
  static Map<String, dynamic>? getVariation(double current, double previous) {
    if (previous == 0) return null;
    final pct = ((current - previous) / previous) * 100;
    final direction =
        pct > 0
            ? "up"
            : pct < 0
            ? "down"
            : "flat";
    return {'pct': pct, 'direction': direction};
  }
}
