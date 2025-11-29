import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import 'models/monthly_tithes_filter_model.dart';
import 'models/monthly_tithes_list_model.dart';

class MonthlyTithesService extends AppHttp {
  Future<MonthlyTithesListModel> searchMonthlyTithes(
    MonthlyTithesFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/monthly-tithes',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      return MonthlyTithesListModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
