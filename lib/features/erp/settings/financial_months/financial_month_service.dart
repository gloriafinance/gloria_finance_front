import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import 'models/financial_month_model.dart';

class FinancialMonthService extends AppHttp {
  Future<List<FinancialMonthModel>> listFinancialMonths(int year) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/consolidate/',
        queryParameters: {'year': year},
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map((e) => FinancialMonthModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> updateFinancialMonthStatus({
    required int month,
    required int year,
    required String action,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.patch(
        '${await getUrlApi()}finance/consolidate/',
        data: {'month': month, 'year': year, 'action': action},
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
