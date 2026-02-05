// lib/finance/reports/pages/dre/dre_service.dart

import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import 'download/pdf_downloader.dart';
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
      final response = await http.get(
        '${await getUrlApi()}reports/finance/dre/pdf',
        queryParameters: params.toJson(),
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final downloader = getDREPdfDownloader();
      final bytes = response.data as List<int>;

      // Generar nombre de archivo basado en filtros
      final fileName = _generateFileName(params);

      return await downloader.savePdf(bytes, fileName);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    } catch (e) {
      print('Error al descargar el PDF: $e');
      return false;
    }
  }

  String _generateFileName(DREFilterModel params) {
    if (params.month != null && params.month! > 0) {
      return 'dre-${params.year}-${params.month}.pdf';
    }
    return 'dre-${params.year}.pdf';
  }
}
