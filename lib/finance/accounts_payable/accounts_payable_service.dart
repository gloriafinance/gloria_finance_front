import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:dio/dio.dart';

import 'models/accounts_payable_filter_model.dart';
import 'models/accounts_payable_model.dart';

class AccountsPayableService extends AppHttp {
  Future<void> saveAccountPayable(Map<String, dynamic> data) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}account-payable',
        data: data,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PaginateResponse<AccountsPayableModel>> listAccountsPayable(
    AccountsPayableFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;
    try {
      final response = await http.get(
        '${await getUrlApi()}account-payable',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        params.perPage,
        response.data,
        (data) => AccountsPayableModel.fromJson(data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  sendPayment(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

    try {
      final response = await http.post(
        '${await getUrlApi()}account-payable/pay',
        data: formData,
        options: Options(headers: bearerToken()),
      );

      return response.data;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
