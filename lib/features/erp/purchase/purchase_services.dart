import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/core/paginate/paginate_response.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/purchase/pages/purchases/models/purchase_list_model.dart';
import 'package:dio/dio.dart';

import 'pages/purchases/models/purchase_filter_model.dart';

class PurchaseService extends AppHttp {
  sendSavePurchase(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final payload = Map<String, dynamic>.from(form);
    final files = payload.remove('file');
    final formData = FormData.fromMap(payload);

    if (files is MultipartFile) {
      formData.files.add(MapEntry('file', files));
    } else if (files is List<MultipartFile>) {
      for (final file in files) {
        formData.files.add(MapEntry('file', file));
      }
    }

    try {
      await http.post(
        '${await getUrlApi()}purchase',
        data: formData,
        options: Options(headers: bearerToken()),
      );

      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return false;
    }
  }

  Future<PaginateResponse<PurchaseListModel>> searchPurchases(
    PurchaseFilterModel filter,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}purchase',
        queryParameters: filter.toJson(),
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        filter.perPage,
        response.data,
        (data) => PurchaseListModel.fromJson(data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
