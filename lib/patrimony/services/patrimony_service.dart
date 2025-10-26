import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_model.dart';
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
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
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
}
