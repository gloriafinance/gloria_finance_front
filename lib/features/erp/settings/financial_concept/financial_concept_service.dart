import 'package:gloria_finance/core/app_http.dart';
import 'package:dio/dio.dart';

import 'models/financial_concept_assistance_model.dart';
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
        url += '/${type.apiValue}';
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

  Future<void> saveFinancialConcept(Map<String, dynamic> payload) async {
    try {
      await http.post(
        '${await getUrlApi()}finance/configuration/financial-concepts',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<FinancialConceptAssistanceModel> getFinancialConceptAssistance(
    String context,
  ) async {
    try {
      final response = await http.post(
        '${await getUrlApi()}ai/assistance/financial-concepts',
        data: {'context': context},
        options: Options(headers: bearerToken()),
      );

      return FinancialConceptAssistanceModel.fromJson(
        Map<String, dynamic>.from(response.data ?? const {}),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
