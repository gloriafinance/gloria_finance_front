import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class SupplierService extends AppHttp {
  SupplierService({super.tokenAPI});

  Future<void> saveSupplier(Map<String, dynamic> jsonForm) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}suppliers',
        data: jsonForm,
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
