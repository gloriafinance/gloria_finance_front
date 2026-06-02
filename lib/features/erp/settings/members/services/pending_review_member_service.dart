import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/core/paginate/paginate_response.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import '../models/member_filter_model.dart';
import '../models/member_model.dart';

class PendingReviewMemberService extends AppHttp {
  PendingReviewMemberService({super.tokenAPI});

  Future<PaginateResponse<MemberModel>> searchPendingMembers(
    MemberFilterModel params,
  ) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      final response = await http.get(
        '${await getUrlApi()}church/member/pending-review',
        queryParameters: {
          'perPage': params.perPage,
          'page': params.page,
        },
        options: Options(headers: bearerToken()),
      );

      return PaginateResponse.fromJson(
        params.perPage,
        response.data,
        (data) => MemberModel.fromJson(data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<MemberModel> getPendingMember(String memberId) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      final response = await http.get(
        '${await getUrlApi()}church/member/pending-review/$memberId',
        options: Options(headers: bearerToken()),
      );

      return MemberModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> approve(String memberId) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      await http.patch(
        '${await getUrlApi()}church/member/$memberId/approve',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> reject(String memberId) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      await http.delete(
        '${await getUrlApi()}church/member/$memberId/reject',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
