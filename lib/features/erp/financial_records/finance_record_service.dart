import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/core/download/report_downloader.dart';
import 'package:gloria_finance/core/paginate/paginate_response.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/financial_records/models/finance_record_export_format.dart';
import 'package:gloria_finance/features/erp/financial_records/models/finance_record_filter_model.dart';
import 'package:dio/dio.dart';

import 'models/finance_record_list_model.dart';

class FinanceRecordService extends AppHttp {
  FinanceRecordService({super.tokenAPI});

  Future<void> sendSaveFinanceRecord(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

    try {
      await http.post(
        '${await getUrlApi()}finance/financial-record',
        data: formData,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PaginateResponse<FinanceRecordListModel>> searchFinanceRecords(
    FinanceRecordFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        params.perPage,
        response.data,
        (data) => FinanceRecordListModel.fromJson(data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> exportFinanceRecords(
    FinanceRecordFilterModel params, {
    required FinanceRecordExportFormat format,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record/export',
        queryParameters: {...params.toJson(), 'format': format.queryValue},
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = response.data as List<int>;
      final fileName = format.fileName;
      final mimeType = format.mimeType;
      final downloader = getReportDownloader();
      final result = await downloader.saveFile(bytes, fileName, mimeType);

      if (!result.success) {
        print("No se pudo guardar el archivo");
        return false;
      }

      final filePath = result.filePath;

      if (filePath == null) {
        print("Descarga iniciada en el navegador para: $fileName");
        return true;
      }

      print("Archivo descargado exitosamente en: $filePath");

      return true;
    } on DioException catch (e) {
      print("Error al descargar el archivo: ${e.message}");
      transformResponse(e.response?.data);
      return false;
    } catch (e) {
      print("Error inesperado: $e");
      return false;
    }
  }

  Future<void> cancelFinanceRecord(String id) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.patch(
        '${await getUrlApi()}finance/financial-record/cancel/$id',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
