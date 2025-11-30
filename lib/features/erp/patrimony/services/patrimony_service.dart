import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/download/report_downloader.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_inventory_import_result.dart';
import 'package:dio/dio.dart';

class PatrimonyService extends AppHttp {
  PatrimonyService({super.tokenAPI});

  Future<PaginateResponse<PatrimonyAssetModel>> fetchAssets({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
    String? category,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}patrimony',
        queryParameters: {
          'page': page,
          'perPage': perPage,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          if (status != null && status.isNotEmpty) 'status': status,
          if (category != null && category.isNotEmpty) 'category': category,
        },
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        perPage,
        Map<String, dynamic>.from(response.data as Map),
        (json) => PatrimonyAssetModel.fromMap(json),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PatrimonyAssetModel> getAsset(String assetId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}patrimony/$assetId',
        options: Options(headers: bearerToken()),
      );

      return PatrimonyAssetModel.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> createAsset(FormData payload) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}patrimony',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> updateAsset(String assetId, FormData payload) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.put(
        '${await getUrlApi()}patrimony/$assetId',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> deleteAsset(String assetId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.delete(
        '${await getUrlApi()}patrimony/$assetId',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PatrimonyAssetModel> registerDisposal(
    String assetId, {
    required String status,
    required String reason,
    String? disposedAt,
    String? observations,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}patrimony/$assetId/disposal',
        data: {
          'status': status,
          'reason': reason,
          if (disposedAt != null) 'disposedAt': disposedAt,
          if (observations != null) 'observations': observations,
        },
        options: Options(headers: bearerToken()),
      );

      return PatrimonyAssetModel.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PatrimonyAssetModel> registerInventory(
    String assetId, {
    required String status,
    String? checkedAt,
    String? notes,
    required String code,
    required int quantity,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}patrimony/$assetId/inventory',
        data: {
          'status': status,
          if (checkedAt != null) 'checkedAt': checkedAt,
          if (notes != null) 'notes': notes,
          'code': code,
          'quantity': quantity,
        },
        options: Options(headers: bearerToken()),
      );

      return PatrimonyAssetModel.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> downloadInventorySummary({
    required String format,
    String? status,
    String? category,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParameters = <String, dynamic>{
      'format': format,
      if (session.churchId != null) 'churchId': session.churchId,
      if (status != null && status.isNotEmpty) 'status': status,
      if (category != null && category.isNotEmpty) 'category': category,
    };

    try {
      final response = await http.get(
        '${await getUrlApi()}patrimony/report/inventory',
        queryParameters: queryParameters,
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final downloader = getReportDownloader();
      final bytes = response.data as List<int>;
      final normalizedFormat = format.toLowerCase();
      final fileName =
          normalizedFormat == 'pdf'
              ? 'relatorio_patrimonio.pdf'
              : 'relatorio_patrimonio.csv';
      final mimeType =
          normalizedFormat == 'pdf' ? 'application/pdf' : 'text/csv';

      final result = await downloader.saveFile(bytes, fileName, mimeType);
      return result.success;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> downloadPhysicalChecklist({
    String? status,
    String? category,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParameters = <String, dynamic>{
      if (session.churchId != null) 'churchId': session.churchId,
      if (status != null && status.isNotEmpty) 'status': status,
      if (category != null && category.isNotEmpty) 'category': category,
    };

    try {
      final response = await http.get(
        '${await getUrlApi()}patrimony/report/inventory/physical',
        queryParameters: queryParameters,
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final downloader = getReportDownloader();
      final bytes = response.data as List<int>;

      final result = await downloader.saveFile(
        bytes,
        'checklist_inventario.csv',
        'text/csv',
      );
      return result.success;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PatrimonyInventoryImportResult> importInventoryChecklist({
    required MultipartFile file,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final payload = FormData.fromMap({'inventoryFile': file});

    try {
      final response = await http.post(
        '${await getUrlApi()}patrimony/inventory/import',
        data: payload,
        options: Options(headers: bearerToken()),
      );

      return PatrimonyInventoryImportResult.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
