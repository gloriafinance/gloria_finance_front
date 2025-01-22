import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:dio/dio.dart';

import 'models/contribution_filter_model.dart';
import 'models/contribution_model.dart';

class ContributionService extends AppHttp {
  ContributionService({super.tokenAPI});

  Future<PaginateResponse<ContributionModel>> searchContributions(
      ContributionFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/contributions',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
        ),
      );

      return PaginateResponse.fromJson(params.perPage, response.data,
          (data) => ContributionModel.fromJson(data));
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> updateContributionStatus(
      String contributionId, ContributionStatus status) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final s = status.toString().split('.').last;
      await http.patch(
        '${await getUrlApi()}finance/contributions_list/$contributionId/status/$s',
        options: Options(
          headers: getHeader(),
        ),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> sendSaveContribution(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
      'memberId': session.memberId,
    });

    try {
      await http.post(
        '${await getUrlApi()}finance/contributions_list',
        data: formData,
        options: Options(
          headers: getHeader(),
        ),
      );
      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
