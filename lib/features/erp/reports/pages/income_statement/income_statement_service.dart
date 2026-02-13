import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import 'models/income_statement_filter_model.dart';
import 'models/income_statement_model.dart';

class IncomeStatementService extends AppHttp {
  Future<IncomeStatementModel> fetchIncomeStatement(
    IncomeStatementFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/income-statement',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      return IncomeStatementModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> downloadIncomeStatementPdf(
    IncomeStatementFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      await http.get(
        '${await getUrlApi()}reports/finance/income-statement/pdf',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );
      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    } catch (e) {
      print('Error al descargar el PDF: $e');
      return false;
    }
  }
}
