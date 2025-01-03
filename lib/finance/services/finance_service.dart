import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/finance/models/bank_model.dart';
import 'package:church_finance_bk/finance/models/financial_concept_model.dart';
import 'package:dio/dio.dart';

class FinanceService extends AppHttp {
  FinanceService({super.tokenAPI});

  Future<List<FinancialConcept>> searchFinancialConcepts(
      String churchId, FinancialConceptType? type) async {
    try {
      String url =
          '${await getUrlApi()}finance/configuration/financial-concepts/$churchId';

      if (type != null) {
        url += '/${type.toString().split('.').last}';
      }

      final response = await http.get(
        url,
        options: Options(
          headers: getHeader(),
        ),
      );

      return (response.data as List)
          .map((e) => FinancialConcept.fromJson(e))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

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
