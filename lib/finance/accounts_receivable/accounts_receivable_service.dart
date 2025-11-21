import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:dio/dio.dart';

import 'models/index.dart';

class AccountsReceivableService extends AppHttp {
  Future<void> sendAccountsReceivable(
    Map<String, dynamic> accountsReceivable,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}account-receivable',
        data: accountsReceivable,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PaginateResponse<AccountsReceivableModel>> listAccountsReceivable(
    AccountsReceivableFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}account-receivable',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        params.perPage,
        response.data,
        (data) => AccountsReceivableModel.fromJson(data),
      );
    } on DioException catch (e) {
      print("ssss ${e.response?.data}");
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<PaginateResponse<AccountsReceivableModel>> listMemberCommitments(
    MemberCommitmentFilter filter,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}account-receivable/member/commitments',
        queryParameters: filter.toQuery(),
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        filter.perPage,
        response.data,
        (data) => AccountsReceivableModel.fromJson(data),
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
        '${await getUrlApi()}account-receivable/pay',
        data: formData,
        options: Options(headers: bearerToken()),
      );

      return response.data;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> declareMemberPayment(PaymentDeclarationModel declaration) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}account-receivable/member/payment-declaration',
        data: declaration.toFormData(),
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
