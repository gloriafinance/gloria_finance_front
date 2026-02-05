import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/core/paginate/paginate_response.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import '../models/member_filter_model.dart';
import '../models/member_model.dart';

class MemberListService extends AppHttp {
  MemberListService({super.tokenAPI});

  Future<PaginateResponse<MemberModel>> searchMembers(
    MemberFilterModel params,
  ) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      params.churchId = session.churchId;

      final response = await http.get(
        '${await getUrlApi()}church/member/list',
        queryParameters: params.toJson(),
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

  Future<List<MemberModel>> members() async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      final response = await http.get(
        '${await getUrlApi()}church/member/all',
        options: Options(headers: bearerToken()),
      );

      return List<MemberModel>.from(
        response.data.map((data) => MemberModel.fromJson(data)),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
