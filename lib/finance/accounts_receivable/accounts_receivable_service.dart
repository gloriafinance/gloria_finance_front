import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class AccountsReceivableService extends AppHttp {
  AccountsReceivableService({super.tokenAPI});

  Future<void> sendAccountsReceivable(
      Map<String, dynamic> accountsReceivable) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}account-receivable',
        data: accountsReceivable,
        options: Options(
          headers: getHeader(),
        ),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
