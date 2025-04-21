import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/accounts_payable_model.dart';

class AccountsPayableService extends AppHttp {
  Future<void> saveAccountPayable(Map<String, dynamic> data) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}account-payable',
        data: data,
        options: Options(
          headers: getHeader(),
        ),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<List<AccountsPayableModel>> getAccountsPayable() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}account-payable',
        options: Options(
          headers: getHeader(),
        ),
      );

      return (response.data as List<dynamic>)
          .map((e) => AccountsPayableModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<AccountsPayableModel> getAccountPayableById(String id) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}account-payable/$id',
        options: Options(
          headers: getHeader(),
        ),
      );

      return AccountsPayableModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
