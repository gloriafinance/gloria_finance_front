import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:dio/dio.dart';

import '../models/member_filter_model.dart';
import '../models/member_model.dart';

class MemberListService extends AppHttp {
  MemberListService({super.tokenAPI});

  Future<PaginateResponse<MemberModel>> searchMembers(
      MemberFilterModel params) async {
    try {
      final response = await http.get(
        '${await getUrlApi()}church/member/list',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
        ),
      );

      return PaginateResponse.fromJson(
          params.perPage, response.data, (data) => MemberModel.fromJson(data));
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
