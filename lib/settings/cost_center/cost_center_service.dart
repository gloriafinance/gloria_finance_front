import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/cost_center_model.dart';

class CostCenterService extends AppHttp {
  Future<List<CostCenterModel>> searchCostCenters() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/configuration/cost-center/${session.churchId}',
        options: Options(
          headers: getHeader(),
        ),
      );

      return (response.data as List)
          .map((e) => CostCenterModel.fromMap(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
