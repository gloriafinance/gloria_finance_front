import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate_response.dart';
import 'package:church_finance_bk/finance/models/contribution_filter_mnodel.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:dio/dio.dart';

class FinanceService extends AppHttp {
  FinanceService({super.tokenAPI});

  Future<PaginateResponse<Contribution>> searchContribuitions(
      ContributionFilter params) async {
    try {
      final response = await http.get(
        '${await getUrlApi()}finance/contributions',
        queryParameters: params.toMap(),
        options: Options(
          headers: getHeader(),
        ),
      );
      return PaginateResponse.fromJson(
          response.data, (data) => Contribution.fromJson(data));
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
