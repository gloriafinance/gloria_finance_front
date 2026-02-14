// lib/finance/reports/pages/dre/dre_service.dart

import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import 'models/dre_filter_model.dart';
import 'models/dre_model.dart';

class DREService extends AppHttp {
  Future<DREReportModel> fetchDRE(DREFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/dre',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      final payload = response.data;
      if (payload is! List) {
        return DREReportModel.empty();
      }

      return DREReportModel.fromJson(payload);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> downloadDREPdf(DREFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      await http.get(
        '${await getUrlApi()}reports/finance/dre/pdf',
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
