// lib/finance/reports/pages/income_statement/income_statement_service.dart

import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/income_statement_filter_model.dart';
import 'models/income_statement_model.dart';

class IncomeStatementService extends AppHttp {
  Future<IncomeStatementModel> fetchIncomeStatement(
      IncomeStatementFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/income-statement',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
        ),
      );

      return IncomeStatementModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
