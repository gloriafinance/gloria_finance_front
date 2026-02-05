import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import '../models/trend_model.dart';

class TrendService extends AppHttp {
  Future<TrendResponse> getTrends({
    required String churchId,
    required int year,
    required int month,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/dre/trend',
        queryParameters: {'churchId': churchId, 'year': year, 'month': month},
        options: Options(headers: bearerToken()),
      );

      return TrendResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
