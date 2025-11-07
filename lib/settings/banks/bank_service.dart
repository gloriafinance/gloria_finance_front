import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import '../../core/app_http.dart';
import 'models/bank_model.dart';

class BankService extends AppHttp {
  Future<List<BankModel>> searchBank() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}bank/list/${session.churchId}',
        options: Options(headers: bearerToken()),
      );

      return (response.data as List).map((e) => BankModel.fromJson(e)).toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> saveBank(Map<String, dynamic> payload) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}bank/',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
