import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:church_finance_bk/features/erp//providers/models/supplier_model.dart';
import 'package:dio/dio.dart';

class SupplierService extends AppHttp {
  SupplierService({super.tokenAPI});

  Future<void> saveSupplier(Map<String, dynamic> jsonForm) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}account-payable/supplier',
        data: jsonForm,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<List<SupplierModel>> getSuppliers() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}account-payable/supplier',
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map((e) => SupplierModel.fromMap(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
