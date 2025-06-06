import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/availability_account_model.dart';

class AvailabilityAccountService extends AppHttp {
  Future<List<AvailabilityAccountModel>> searchAvailabilityAccounts() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/configuration/availability-account/${session.churchId}',
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map((e) => AvailabilityAccountModel.fromMap(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> saveAvailabilityAccount(Map<String, dynamic> payload) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}finance/configuration/availability-account',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
