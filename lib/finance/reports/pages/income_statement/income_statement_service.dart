import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/income_statement_filter_model.dart';
import 'models/income_statement_model.dart';
import 'download/pdf_downloader.dart';

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
      final response = await http.get(
        '${await getUrlApi()}reports/finance/income-statement/pdf',
        queryParameters: params.toJson(),
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final downloader = getIncomeStatementPdfDownloader();
      final bytes = response.data as List<int>;
      const fileName = 'estado_ingresos.pdf';

      return await downloader.savePdf(bytes, fileName);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    } catch (e) {
      print('Error al descargar el PDF: $e');
      return false;
    }
  }
}
