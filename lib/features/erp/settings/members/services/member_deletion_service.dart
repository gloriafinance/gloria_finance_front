import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

class MemberDeletionService extends AppHttp {
  MemberDeletionService({super.tokenAPI});

  Future<void> deleteMember(String memberId) async {
    try {
      final session = await AuthPersistence().restore();
      tokenAPI = session.token;

      await http.delete(
        '${await getUrlApi()}church/member/$memberId',
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
