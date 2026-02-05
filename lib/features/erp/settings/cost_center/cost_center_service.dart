import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import 'models/cost_center_model.dart';

class CostCenterService extends AppHttp {
  Future<List<CostCenterModel>> searchCostCenters() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/configuration/cost-center/${session.churchId}',
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map((e) => CostCenterModel.fromMap(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> saveCostCenter(Map<String, dynamic> payload, bool isEdit) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      if (isEdit) {
        await http.put(
          '${await getUrlApi()}finance/configuration/cost-center/',
          data: payload,
          options: Options(headers: bearerToken()),
        );
      } else {
        await http.post(
          '${await getUrlApi()}finance/configuration/cost-center/',
          data: payload,
          options: Options(headers: bearerToken()),
        );
      }
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
