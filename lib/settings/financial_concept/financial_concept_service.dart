import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/financial_concept_model.dart';

class FinancialConceptService extends AppHttp {
  Future<List<FinancialConceptModel>> searchFinancialConcepts(
    String churchId,
    FinancialConceptType? type,
  ) async {
    try {
      String url =
          '${await getUrlApi()}finance/configuration/financial-concepts/$churchId';

      if (type != null) {
        url += '/${type.toString().split('.').last}';
      }

      final response = await http.get(
        url,
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map((e) => FinancialConceptModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
