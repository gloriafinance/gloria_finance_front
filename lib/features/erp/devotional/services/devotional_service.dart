import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';

class DevotionalService extends AppHttp {
  Future<DevotionalPlanModel?> getPlan(String weekStartDate) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}church/devotional/plan',
        queryParameters: {'weekStartDate': weekStartDate},
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      if (data['data'] == null) return null;

      return DevotionalPlanModel.fromJson(
        Map<String, dynamic>.from(data['data']),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalPlanModel> upsertPlan(DevotionalPlanModel plan) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}church/devotional/plan',
        data: plan.toUpsertPayload(),
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is! Map<String, dynamic> || data['data'] == null) {
        throw Exception('Invalid devotional plan response');
      }

      return DevotionalPlanModel.fromJson(
        Map<String, dynamic>.from(data['data']),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalAgendaResponseModel> getAgenda({
    required String weekStartDate,
    String? status,
    String? audience,
    String? channel,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final query = <String, dynamic>{'weekStartDate': weekStartDate};
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (audience != null && audience.isNotEmpty) query['audience'] = audience;
    if (channel != null && channel.isNotEmpty) query['channel'] = channel;

    try {
      final response = await http.get(
        '${await getUrlApi()}church/devotional/agenda',
        queryParameters: query,
        options: Options(headers: bearerToken()),
      );

      return DevotionalAgendaResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalDetailModel> getDevotional(String devotionalId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}church/devotional/$devotionalId',
        options: Options(headers: bearerToken()),
      );
      return DevotionalDetailModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalDetailModel> editDevotional({
    required String devotionalId,
    required DevotionalContentModel content,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.patch(
        '${await getUrlApi()}church/devotional/$devotionalId/edit',
        data: content.toUpdatePayload(),
        options: Options(headers: bearerToken()),
      );

      return DevotionalDetailModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalDetailModel> regenerate(String devotionalId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}church/devotional/$devotionalId/regenerate',
        options: Options(headers: bearerToken()),
      );

      return DevotionalDetailModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalDetailModel> approve(String devotionalId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}church/devotional/$devotionalId/approve',
        options: Options(headers: bearerToken()),
      );

      return DevotionalDetailModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalDetailModel> retrySend(String devotionalId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}church/devotional/$devotionalId/retry-send',
        options: Options(headers: bearerToken()),
      );

      return DevotionalDetailModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<DevotionalHistoryResponseModel> getHistory({
    String? fromDate,
    String? toDate,
    String? audience,
    String? channel,
    String? overall,
    String? query,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final params = <String, dynamic>{};
    if (fromDate != null && fromDate.isNotEmpty) params['fromDate'] = fromDate;
    if (toDate != null && toDate.isNotEmpty) params['toDate'] = toDate;
    if (audience != null && audience.isNotEmpty) params['audience'] = audience;
    if (channel != null && channel.isNotEmpty) params['channel'] = channel;
    if (overall != null && overall.isNotEmpty) params['overall'] = overall;
    if (query != null && query.isNotEmpty) params['query'] = query;

    try {
      final response = await http.get(
        '${await getUrlApi()}church/devotional/history',
        queryParameters: params,
        options: Options(headers: bearerToken()),
      );

      return DevotionalHistoryResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
