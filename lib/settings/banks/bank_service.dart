import 'package:dio/dio.dart';

import '../../core/app_http.dart';
import 'models/bank_model.dart';

class BankService extends AppHttp {
  Future<List<BankModel>> searchBank(String churchId) async {
    try {
      final response = await http.get(
        '${await getUrlApi()}finance/configuration/bank/$churchId',
        options: Options(
          headers: getHeader(),
        ),
      );

      return (response.data as List).map((e) => BankModel.fromJson(e)).toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
