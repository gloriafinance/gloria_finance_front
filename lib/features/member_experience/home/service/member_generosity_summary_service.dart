import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:church_finance_bk/features/member_experience/home/models/member_generosity_summary_model.dart';
import 'package:dio/dio.dart';

class MemberGenerositySummaryService extends AppHttp {
  MemberGenerositySummaryService({super.tokenAPI});

  Future<MemberGenerositySummaryModel> fetchSummary() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final queryParams = <String, dynamic>{};
      if (session.memberId != null) {
        queryParams['memberId'] = session.memberId;
      }

      final response = await http.get(
        '${await getUrlApi()}me/generosity-summary',
        queryParameters: queryParams.isEmpty ? null : queryParams,
        options: Options(headers: bearerToken()),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload =
            data['summary'] is Map<String, dynamic> ? data['summary'] : data;
        return MemberGenerositySummaryModel.fromJson(
          Map<String, dynamic>.from(payload as Map),
        );
      }

      return const MemberGenerositySummaryModel.empty();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
