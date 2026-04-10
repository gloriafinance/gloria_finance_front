import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/core/download/report_downloader.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import 'models/cash_flow_export_format.dart';
import 'models/cash_flow_filter_model.dart';
import 'models/cash_flow_model.dart';

class CashFlowService extends AppHttp {
  Future<CashFlowReportModel> fetchCashFlow(CashFlowFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final request = params.copyWith(churchId: session.churchId);

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/cash-flow',
        queryParameters: request.toJson(),
        options: Options(headers: bearerToken()),
      );

      return CashFlowReportModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<CashFlowBucketDetailsModel> fetchCashFlowDetails(
    CashFlowFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final request = params.copyWith(churchId: session.churchId);

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/cash-flow/details',
        queryParameters: request.toJson(),
        options: Options(headers: bearerToken()),
      );

      return CashFlowBucketDetailsModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> exportCashFlow(
    CashFlowFilterModel params, {
    required CashFlowExportFormat format,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final request = params.copyWith(churchId: session.churchId);

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/cash-flow/export',
        queryParameters: {...request.toJson(), 'format': format.queryValue},
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = response.data as List<int>;
      final downloader = getReportDownloader();
      final result = await downloader.saveFile(
        bytes,
        format.fileName,
        format.mimeType,
      );

      return result.success;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return false;
    } catch (_) {
      return false;
    }
  }
}
