import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:intl/intl.dart';

class MemberDevotionalService extends AppHttp {
  static const Set<String> _visibleStatuses = {'approved', 'sending', 'sent'};

  Future<MemberTodayDevotionalModel?> fetchTodayDevotional() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final weekStartDate = _currentWeekMonday(now);

    try {
      final response = await http.get(
        '${await getUrlApi()}church/devotional/agenda',
        queryParameters: {'weekStartDate': weekStartDate},
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) return null;

      final rawItems = data['items'];
      if (rawItems is! List) return null;

      final todayItems =
          rawItems
              .whereType<Map>()
              .map(
                (item) => MemberTodayDevotionalModel.fromAgendaJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .where(
                (item) =>
                    item.scheduleDate == today &&
                    _visibleStatuses.contains(item.status) &&
                    item.devotionalId.isNotEmpty,
              )
              .toList()
            ..sort((a, b) {
              final aDate =
                  a.scheduledAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bDate =
                  b.scheduledAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return aDate.compareTo(bDate);
            });

      if (todayItems.isEmpty) {
        return null;
      }

      return todayItems.first;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<MemberDevotionalDetailModel> fetchDevotionalDetail(
    String devotionalId,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}church/devotional/$devotionalId',
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid devotional detail response');
      }

      return MemberDevotionalDetailModel.fromDetailResponse(
        Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  String _currentWeekMonday(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return DateFormat('yyyy-MM-dd').format(monday);
  }
}
