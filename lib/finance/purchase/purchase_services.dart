import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/purchase/pages/purchases/models/purchase_list_model.dart';
import 'package:dio/dio.dart';

import 'pages/purchases/models/purchase_filter_model.dart';

class PurchaseService extends AppHttp {
  sendSavePurchase(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

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
