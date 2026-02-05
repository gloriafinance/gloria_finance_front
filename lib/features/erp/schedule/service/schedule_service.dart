import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:dio/dio.dart';

class ScheduleService extends AppHttp {
  /// GET /api/v1/schedule
  /// Lista itens de agenda configurados
  Future<List<ScheduleItemConfig>> getScheduleItems({
    ScheduleItemType? type,
    ScheduleVisibility? visibility,
    bool? isActive,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParams = <String, dynamic>{};

    if (type != null) queryParams['type'] = type.apiValue;
    if (visibility != null) queryParams['visibility'] = visibility.apiValue;
    if (isActive != null) queryParams['isActive'] = isActive ? 'true' : 'false';

    try {
      final response = await http.get(
        '${await getUrlApi()}schedule',
        queryParameters: queryParams,
        options: Options(headers: bearerToken()),
      );

      // Handle paginated response structure
      if (response.data is! Map<String, dynamic>) {
        return [];
      }

      final responseData = response.data as Map<String, dynamic>;

      // Check if 'results' field exists and is a List
      if (!responseData.containsKey('results') ||
          responseData['results'] is! List) {
        return [];
      }

      final List<dynamic> data = responseData['results'] as List<dynamic>;
      return data
          .map(
            (json) => ScheduleItemConfig.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// GET /api/v1/schedule/{scheduleItemId}
  /// Detalhe de um item de agenda
  Future<ScheduleItemConfig> getScheduleItemById(String scheduleItemId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}schedule/$scheduleItemId',
        options: Options(headers: bearerToken()),
      );
      return ScheduleItemConfig.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// POST /api/v1/schedule
  /// Cria um item de agenda
  Future<ScheduleItemConfig> createScheduleItem(
    ScheduleItemPayload payload,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}schedule',
        data: payload.toJson(),
        options: Options(headers: bearerToken()),
      );
      return ScheduleItemConfig.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// PUT /api/v1/schedule/{scheduleItemId}
  /// Atualiza um item de agenda
  Future<ScheduleItemConfig> updateScheduleItem(
    String scheduleItemId,
    ScheduleItemUpdatePayload payload,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.put(
        '${await getUrlApi()}schedule/$scheduleItemId',
        data: payload.toJson(),
        options: Options(headers: bearerToken()),
      );
      final responseData = response.data as Map<String, dynamic>;

      // Backend may not return the ID on update, but we already have it.
      if (!responseData.containsKey('scheduleItemId')) {
        responseData['scheduleItemId'] = scheduleItemId;
      }

      return ScheduleItemConfig.fromJson(responseData);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// DELETE /api/v1/schedule/{scheduleItemId}
  /// Desativa (soft delete) um item de agenda
  Future<void> deleteScheduleItem(String scheduleItemId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.delete(
        '${await getUrlApi()}schedule/$scheduleItemId',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// POST /api/v1/schedule/{scheduleItemId}/reactivate
  /// Reativa um item de agenda
  Future<void> reactivateScheduleItem(String scheduleItemId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}schedule/$scheduleItemId/reactivate',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// GET /api/v1/schedule/weekly
  /// Agenda semanal expandida
  Future<List<WeeklyOccurrence>> getWeeklySchedule(
    String weekStartDate, {
    ScheduleVisibility? visibilityScope,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParams = <String, dynamic>{'weekStartDate': weekStartDate};

    if (visibilityScope != null) {
      queryParams['visibilityScope'] = visibilityScope.apiValue;
    }

    try {
      final response = await http.get(
        '${await getUrlApi()}schedule/weekly',
        queryParameters: queryParams,
        options: Options(headers: bearerToken()),
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map(
            (json) => WeeklyOccurrence.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
